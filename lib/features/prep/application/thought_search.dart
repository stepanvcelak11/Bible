import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/services/versification.dart';
import '../../content/application/content_providers.dart';
import '../../search/application/reference_parser.dart';

/// Pojem ze slovníku pro hledání podle myšlenky (assets/content/concepts.json).
@immutable
class ThoughtConcept {
  const ThoughtConcept({
    required this.id,
    required this.label,
    required this.triggers,
    required this.terms,
    required this.links,
  });

  factory ThoughtConcept.fromJson(Map<String, Object?> j) => ThoughtConcept(
    id: j['id']! as String,
    label: j['label']! as String,
    triggers: (j['triggers']! as List<Object?>).cast<String>(),
    terms: (j['terms']! as List<Object?>).cast<String>(),
    links: (j['links']! as List<Object?>).cast<String>(),
  );

  final String id;
  final String label;

  /// Začátky slov, kterými pojem vyjádří uživatel (bez diakritiky).
  final List<String> triggers;

  /// Začátky slov, kterými o něm mluví Bible.
  final List<String> terms;

  /// Témata (t:), situace (s:) a nitě (h:) s vybranými místy.
  final List<String> links;
}

@immutable
class ConceptLexicon {
  const ConceptLexicon(this.stop, this.concepts);

  final Set<String> stop;
  final List<ThoughtConcept> concepts;

  static List<String> _tokens(String text) => RegExp(
    r'[\p{L}\p{N}]+',
    unicode: true,
  ).allMatches(foldCzech(text)).map((m) => m[0]!).toList();

  static bool _hit(String trigger, List<String> tokens, Set<String> stop) {
    if (trigger.contains('_')) {
      final words = trigger.split('_');
      for (var i = 0; i + words.length <= tokens.length; i++) {
        var ok = true;
        for (var k = 0; k < words.length && ok; k++) {
          ok = tokens[i + k].startsWith(words[k]);
        }
        if (ok) return true;
      }
      return false;
    }
    final exact = trigger.endsWith('=');
    final t = exact ? trigger.substring(0, trigger.length - 1) : trigger;
    for (final token in tokens) {
      if (stop.contains(token)) continue;
      // „nebojím“, „nemůžu“ – zápor nemění téma.
      final bare = token.startsWith('ne') && token.length > 5
          ? token.substring(2)
          : null;
      for (final w in [token, ?bare]) {
        if (exact ? w == t : w.startsWith(t)) return true;
      }
    }
    return false;
  }

  /// Pojmy, které myšlenka [text] obsahuje (v pořadí slovníku).
  List<ThoughtConcept> detect(String text) {
    final tokens = _tokens(text);
    return [
      for (final c in concepts)
        if (c.triggers.any((t) => _hit(t, tokens, stop))) c,
    ];
  }

  /// Významová slova myšlenky, která nepokrývá žádný pojem (hledají se
  /// doslova, aby se neztratilo nic konkrétního – jména, místa…).
  List<String> keywords(String text, List<ThoughtConcept> found) {
    return [
      for (final token in _tokens(text).toSet())
        if (token.length >= 4 &&
            !stop.contains(token) &&
            !found.any(
              (c) => c.triggers.any((t) => _hit(t, [token], const {})),
            ))
          token.length > 6 ? token.substring(0, token.length - 2) : token,
    ];
  }
}

final conceptLexiconProvider = FutureProvider<ConceptLexicon>((ref) async {
  final bytes = await rootBundle.load('assets/content/concepts.json');
  final j = jsonDecode(
    utf8.decode(bytes.buffer.asUint8List()),
  ) as Map<String, Object?>;
  return ConceptLexicon((j['stop']! as List<Object?>).cast<String>().toSet(), [
    for (final c in j['concepts']! as List<Object?>)
      ThoughtConcept.fromJson(c! as Map<String, Object?>),
  ]);
});

/// Vybrané klíčové místo k pojmu (z témat, situací, nití).
@immutable
class KeyPassage {
  const KeyPassage(this.passage, this.label, this.source);

  final Passage passage;
  final String label;
  final String source;
}

/// Verš nalezený podle myšlenky a pojmy, které obsahuje.
@immutable
class ThoughtHit {
  const ThoughtHit(this.hit, this.concepts, this.score);

  final SearchHit hit;
  final List<String> concepts;
  final double score;
}

@immutable
class ThoughtResult {
  const ThoughtResult({
    required this.concepts,
    required this.keywords,
    required this.keyPassages,
    required this.hits,
  });

  final List<ThoughtConcept> concepts;
  final List<String> keywords;
  final List<KeyPassage> keyPassages;
  final List<ThoughtHit> hits;
}

typedef ThoughtQuery = ({
  String text,
  String translationId,
  String excluded, // id vypnutých pojmů oddělená čárkou
});

/// Hledání podle myšlenky: myšlenku rozloží na pojmy, ke každému najde
/// verše, kde o něm Bible mluví (i jinými slovy), a seřadí verše podle
/// toho, kolik pojmů myšlenky spojují.
final thoughtSearchProvider = FutureProvider.autoDispose
    .family<ThoughtResult, ThoughtQuery>((ref, q) async {
      final lexicon = await ref.watch(conceptLexiconProvider.future);
      final repo = ref.watch(bibleRepositoryProvider);
      final excluded = q.excluded.split(',').toSet();
      final all = lexicon.detect(q.text);
      final concepts = [
        for (final c in all)
          if (!excluded.contains(c.id)) c,
      ];
      final keywords = lexicon.keywords(q.text, all);

      // Klíčová místa z obsahu aplikace.
      final (_, topics) = await ref.watch(topicsProvider.future);
      final (_, situations) = await ref.watch(situationsProvider.future);
      final threads = await ref.watch(threadsProvider.future);
      // Po kolech: z každého pojmu jeho první místo, pak druhé…
      final perConcept = <List<KeyPassage>>[];
      final keyCount = <Passage, int>{};
      for (final c in concepts) {
        final items = <KeyPassage>[];
        for (final link in c.links) {
          final id = link.substring(2);
          items.addAll([
            if (link.startsWith('t:'))
              for (final t in topics.where((t) => t.id == id))
                for (var i = 0; i < t.passages.length; i++)
                  KeyPassage(t.passages[i], t.labels[i], t.title),
            if (link.startsWith('s:'))
              for (final s in situations.where((s) => s.id == id))
                for (final p in s.passages) KeyPassage(p, '', s.title),
            if (link.startsWith('h:'))
              for (final t in threads.where((t) => t.id == id))
                for (final st in t.stations)
                  KeyPassage(st.passage, st.title, t.title),
          ]);
        }
        final seen = <Passage>{};
        items.retainWhere((k) => seen.add(k.passage));
        for (final k in items) {
          keyCount[k.passage] = (keyCount[k.passage] ?? 0) + 1;
        }
        perConcept.add(items);
      }
      final ordered = <KeyPassage>[];
      final taken = <Passage>{};
      for (var round = 0; perConcept.any((l) => l.length > round); round++) {
        for (final l in perConcept) {
          if (l.length > round && taken.add(l[round].passage)) {
            ordered.add(l[round]);
          }
        }
      }
      final keyPassages = ordered;

      // Verše podle pojmů (každý pojem jedním dotazem, řazení BM25).
      final scores = <VerseRef, double>{};
      final hitByRef = <VerseRef, SearchHit>{};
      final labels = <VerseRef, List<String>>{};
      Future<void> collect(
        List<String> terms,
        String? label,
        double weight,
      ) async {
        final hits = await repo.searchAny(
          terms,
          translationId: q.translationId,
          limit: 160,
        );
        for (var i = 0; i < hits.length; i++) {
          final r = hits[i].verse.ref;
          scores[r] =
              (scores[r] ?? 0) + weight * (1 + 0.5 * (1 - i / hits.length));
          hitByRef.putIfAbsent(r, () => hits[i]);
          if (label != null) (labels[r] ??= []).add(label);
        }
      }

      await Future.wait([
        for (final c in concepts) collect(c.terms, c.label, 1),
        if (keywords.isNotEmpty)
          collect(keywords, null, concepts.isEmpty ? 1 : 0.4),
      ]);
      // Klíčová místa navíc posílí.
      for (final p in keyCount.keys) {
        final r = Versification.fromCanonical(p.start, q.translationId);
        if (scores.containsKey(r)) scores[r] = scores[r]! + 1;
      }
      final hits = [
        for (final MapEntry(key: r, value: s) in scores.entries)
          ThoughtHit(hitByRef[r]!, labels[r] ?? const [], s),
      ]..sort((a, b) => b.score.compareTo(a.score));
      return ThoughtResult(
        concepts: all,
        keywords: keywords,
        keyPassages: keyPassages.take(16).toList(),
        hits: hits.take(60).toList(),
      );
    });
