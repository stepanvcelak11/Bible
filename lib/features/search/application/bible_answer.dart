import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/content_entities.dart';
import '../../content/application/content_providers.dart';
import 'reference_parser.dart';
import 'scene_search.dart';
import 'thought_search.dart';

/// Odkud odpověď čerpá (téma, situace, lekce, kurz).
enum AnswerSourceKind { topic, situation, lesson, course }

/// Text aplikace, ze kterého se odpověď skládá: odstavce výkladu a verše
/// s popiskem.
@immutable
class AnswerSource {
  const AnswerSource({
    required this.kind,
    required this.id,
    required this.title,
    required this.paragraphs,
    required this.passages,
    required this.priority,
    required this.entity,
  });

  /// Téma / situace / (kurz, lekce) / kurz – pro otevření celého výkladu.
  final Object entity;

  final AnswerSourceKind kind;

  /// `téma`, `situace`, `kurz` nebo `kurz:lekce`.
  final String id;
  final String title;
  final List<String> paragraphs;
  final List<(Passage, String)> passages;

  /// Jak blízko má zdroj k otázce (1 = přímo k ní).
  final double priority;
}

/// Věta výkladu vybraná do odpovědi.
@immutable
class AnswerSentence {
  const AnswerSentence(this.text, this.source);

  final String text;
  final AnswerSource source;
}

/// Verš vybraný do odpovědi a proč (popisek z tématu/lekce).
@immutable
class AnswerVerse {
  const AnswerVerse(this.passage, this.label, this.text);

  final Passage passage;
  final String label;
  final String text;
}

/// Odpověď složená k otázce: krátký výklad z vět, které k otázce sedí
/// nejvíc, verše z Bible a kde číst dál.
@immutable
class BibleAnswer {
  const BibleAnswer({
    required this.question,
    required this.sentences,
    required this.verses,
    required this.sources,
  });

  final String question;
  final List<AnswerSentence> sentences;
  final List<AnswerVerse> verses;
  final List<AnswerSource> sources;
}

final _anaphoric = RegExp(
  r'^(To|Ten|Ta|Tím|Toho|Tomu|Tak|Takže|Proto|Ale|A|Také|Též|Týká|Je|Jsou|'
  r'Má|Mají|Roste|Dává|Ona|On|Oni|Jeho|Její|Jejich|Zde|Tady|Tehdy|Mluví|Říká|Ukazuje|Učí|Nazývá|Popisuje|Bere|Vidí|Zve|Vede|Nese|Dělá|Stojí|Znamená)(?=[\s,])',
);

final _sentenceEnd = RegExp(r'(?<=[.!?…])\s+(?=[A-ZÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ„])');

/// Vyskládá odpověď na [query] ze [sources]. [verseText] dává text verše
/// (podle překladu), aby se verše daly porovnat s otázkou.
///
/// Nic se nevymýšlí: věty jsou z výkladů aplikace a verše z Bible.
/// Přizpůsobí se ale otázce – vybere věty a verše, které obsahují
/// nejvíc jejích slov (vzácná slova váží víc), a zachová pestrost zdrojů.
BibleAnswer? composeAnswer({
  required String query,
  required String question,
  required List<AnswerSource> sources,
  required String Function(Passage) verseText,
  int maxSentences = 3,
  int maxVerses = 4,
}) {
  if (sources.isEmpty) return null;
  final q = meaningStems(query).toList();

  // Věty ze všech zdrojů a jejich kmeny.
  final sentences = <(String, AnswerSource, Set<String>, int, bool)>[];
  for (final s in sources) {
    var pos = 0;
    for (final p in s.paragraphs) {
      var first = true;
      for (final t in p.split(_sentenceEnd)) {
        final text = t.trim();
        if (text.length < 25) continue;
        // Věta, která sama obstojí: první v odstavci a nezačíná odkazem
        // na předchozí („To…“, „Proto…“, „Týká se…“).
        final standalone = first && !_anaphoric.hasMatch(text);
        sentences.add((text, s, meaningStems(text), pos++, standalone));
        first = false;
      }
    }
  }
  // Vzácnost slova mezi kandidáty: „zlo“ v textu o zlu rozhoduje víc
  // než „Bůh“, které je skoro všude.
  double idf(String stem, Iterable<Set<String>> docs) {
    var df = 0, n = 0;
    for (final d in docs) {
      n++;
      if (d.any((s) => stemMatch(stem, s) > 0)) df++;
    }
    return math.log(1 + (n + 1) / (df + 1));
  }

  final sentIdf = {for (final w in q) w: idf(w, sentences.map((s) => s.$3))};
  double overlap(Set<String> stems, Map<String, double> weights) {
    var sum = 0.0;
    for (final w in q) {
      var best = 0.0;
      for (final s in stems) {
        best = math.max(best, stemMatch(w, s));
        if (best == 1) break;
      }
      sum += best * (weights[w] ?? 1);
    }
    return sum;
  }

  final scored = [
    for (final (text, src, stems, pos, standalone) in sentences)
      (
        text,
        src,
        pos,
        overlap(stems, sentIdf),
        overlap(stems, sentIdf) +
            (standalone ? 0.5 : 0) +
            src.priority * 1.6 -
            // Úvodní věty výkladu bývají nejsrozumitelnější.
            math.min(pos, 6) * 0.06,
      ),
  ]..sort((a, b) => b.$5.compareTo(a.$5));

  final picked = <AnswerSentence>[];
  var firstPos = -1;
  final perSource = <AnswerSource, int>{};
  for (final (text, src, pos, relevance, _) in scored) {
    if (picked.length >= maxSentences) break;
    // Věta navazující na předchozí („Týká se všech…“) bez ní nedává smysl.
    if (_anaphoric.hasMatch(text)) continue;
    // První věta může být úvodem nejbližšího zdroje, další už musí
    // s otázkou opravdu souviset.
    if (picked.isNotEmpty &&
        relevance <= 0 &&
        !(picked.length == 1 &&
            src == picked.first.source &&
            pos == firstPos + 1)) {
      continue;
    }
    if ((perSource[src] ?? 0) >= 2) continue;
    // Ne dvě skoro stejné věty.
    final stems = meaningStems(text);
    if (picked.any((p) {
      final o = meaningStems(p.text).intersection(stems).length;
      return o > stems.length * 0.6;
    })) {
      continue;
    }
    if (picked.isEmpty) firstPos = pos;
    picked.add(AnswerSentence(text, src));
    perSource[src] = (perSource[src] ?? 0) + 1;
  }

  // Verše: popisek i text verše porovnat s otázkou.
  final candidates = <(Passage, String, AnswerSource)>[];
  final seen = <Passage>{};
  for (final s in sources) {
    for (final (p, label) in s.passages) {
      if (seen.add(p)) candidates.add((p, label, s));
    }
  }
  final verseStems = {
    for (final (p, label, _) in candidates)
      p: {...meaningStems(label), ...meaningStems(verseText(p))},
  };
  final verseIdf = {for (final w in q) w: idf(w, verseStems.values)};
  final rankedVerses = [
    for (final (i, (p, label, src)) in candidates.indexed)
      (
        p,
        label,
        overlap(verseStems[p]!, verseIdf) +
            src.priority * 1.2 -
            // Pořadí ve zdroji: autoři dávají nejdůležitější místa dopředu.
            math.min(i, 12) * 0.03,
      ),
  ]..sort((a, b) => b.$3.compareTo(a.$3));
  final verses = <AnswerVerse>[];
  final books = <int, int>{};
  for (final (p, label, _) in rankedVerses) {
    if (verses.length >= maxVerses) break;
    if ((books[p.bookId] ?? 0) >= 1 && rankedVerses.length > maxVerses * 2) {
      continue;
    }
    final text = verseText(p);
    if (text.isEmpty) continue;
    verses.add(AnswerVerse(p, label, text));
    books[p.bookId] = (books[p.bookId] ?? 0) + 1;
  }

  if (picked.isEmpty && verses.isEmpty) return null;
  return BibleAnswer(
    question: question,
    sentences: picked,
    verses: verses,
    sources: sources,
  );
}

/// Vypadá dotaz jako otázka („proč…“, „jak…“, „co je…“, „…?“)?
bool looksLikeQuestion(String text) {
  final t = foldCzech(text.trim());
  if (t.endsWith('?')) return true;
  return RegExp(
    r'^(proc|jak|co|kdo|kde|kdy|kam|odkud|cim|ceho|existuje|existujou|'
    r'je|jsou|muze|muzu|smi|smim|plati|opravdu|skutecne|'
    r'potrebuju|potrebuji)\b',
  ).hasMatch(t);
}

/// Zdroje odpovědi: cíle nalezené velké otázky ([question]) a témata
/// a situace rozpoznaných pojmů ([concepts]).
List<AnswerSource> answerSources({
  required String text,
  required BigQuestion? question,
  required List<ThoughtConcept> concepts,
  required List<BibleTopic> topics,
  required List<Situation> situations,
  required List<StudyCourse> courses,
}) {
  if (question == null && concepts.isEmpty) return const [];
  // U pocitů („jsem na dně“) odpovídáme jen tehdy, když je to otázka
  // nebo přímo sedí některá z velkých otázek.
  if (question == null && !looksLikeQuestion(text)) return const [];

  final sources = <AnswerSource>[];
  final ids = <String>{};
  void add(String target, double priority) {
    if (!ids.add(target)) return;
    final kind = target.substring(0, 1);
    final id = target.substring(2);
    switch (kind) {
      case 't':
        for (final t in topics.where((t) => t.id == id)) {
          sources.add(
            AnswerSource(
              kind: AnswerSourceKind.topic,
              entity: t,
              id: t.id,
              title: t.title,
              paragraphs: [t.summary, ...t.deeper],
              passages: [
                for (var i = 0; i < t.passages.length; i++)
                  (t.passages[i], t.labels[i]),
              ],
              priority: priority,
            ),
          );
        }
      case 's':
        for (final s in situations.where((s) => s.id == id)) {
          sources.add(
            AnswerSource(
              kind: AnswerSourceKind.situation,
              entity: s,
              id: s.id,
              title: s.title,
              paragraphs: [s.intro, ...s.thoughts],
              passages: [for (final p in s.passages) (p, s.title)],
              priority: priority,
            ),
          );
        }
      case 'l':
        final [cid, n] = id.split(':');
        for (final c in courses.where((c) => c.id == cid)) {
          final l = c.lessons[int.parse(n)];
          sources.add(
            AnswerSource(
              kind: AnswerSourceKind.lesson,
              entity: (c, l),
              id: id,
              title: l.title,
              paragraphs: l.text,
              passages: [
                for (var i = 0; i < l.passages.length; i++)
                  (l.passages[i], l.labels[i]),
              ],
              priority: priority,
            ),
          );
        }
      case 'c':
        for (final c in courses.where((c) => c.id == id)) {
          sources.add(
            AnswerSource(
              kind: AnswerSourceKind.course,
              entity: c,
              id: c.id,
              title: c.title,
              paragraphs: [c.intro, ...c.lessons.first.text],
              passages: [
                for (final l in c.lessons.take(3))
                  for (var i = 0; i < l.passages.length; i++)
                    (l.passages[i], l.labels[i]),
              ],
              priority: priority,
            ),
          );
        }
    }
  }

  if (question != null) {
    for (final (i, t) in question.targets.indexed) {
      add(t, 1 - i * 0.12);
    }
  }
  // Velká otázka má vybrané zdroje; pojmy by přidaly šum („stát se
  // křesťanem“ ≠ stát a politika).
  for (final c
      in question == null ? concepts.take(4) : const <ThoughtConcept>[]) {
    for (final link in c.links) {
      if (link.startsWith('t:') || link.startsWith('s:')) {
        add(link, question == null ? 0.8 : 0.4);
      }
    }
  }
  return sources;
}

/// Velká otázka, na kterou se dotaz ptá. U dotazu, který nevypadá jako
/// otázka („smysl života“), musí sedět skoro všechna slova – pocit jako
/// „mám radost“ nemá dostat výklad.
BigQuestion? pickQuestion(StemIndex<BigQuestion> index, String text) {
  final m = index.search(text, limit: 1);
  if (m.isEmpty) return null;
  final words = meaningStems(text).length;
  if (!looksLikeQuestion(text) && (words < 2 || m.first.coverage < 0.8)) {
    return null;
  }
  return m.first.item;
}

typedef AnswerQuery = ({String text, String translationId});

/// Odpověď z Bible na otázku či myšlenku: zdroje z rejstříku velkých
/// otázek a z rozpoznaných pojmů, z nich se vybere, co sedí nejvíc.
final bibleAnswerProvider = FutureProvider.autoDispose
    .family<BibleAnswer?, AnswerQuery>((ref, q) async {
      final questions = await ref.watch(questionIndexProvider.future);
      final lexicon = await ref.watch(conceptLexiconProvider.future);
      final (_, topics) = await ref.watch(topicsProvider.future);
      final (_, situations) = await ref.watch(situationsProvider.future);
      final courses = await ref.watch(coursesProvider.future);

      final question = pickQuestion(questions, q.text);
      final sources = answerSources(
        text: q.text,
        question: question,
        concepts: lexicon.detect(q.text),
        topics: topics,
        situations: situations,
        courses: courses,
      );
      if (sources.isEmpty) return null;

      // Texty kandidátních veršů v hlavním překladu.
      final texts = <Passage, String>{};
      final all = {
        for (final s in sources)
          for (final (p, _) in s.passages) p,
      };
      await Future.wait([
        for (final p in all)
          ref
              .watch(passageTextProvider((q.translationId, p)).future)
              .then(
                (vs) => texts[p] = vs
                    .take(4)
                    .map((v) => v.text.replaceAll('\n', ' '))
                    .join(' '),
              ),
      ]);

      final title = question?.title ?? _asQuestion(q.text);
      return composeAnswer(
        query: q.text,
        question: title,
        sources: sources,
        verseText: (p) => texts[p] ?? '',
      );
    });

String _asQuestion(String text) {
  var t = text.trim();
  if (t.isEmpty) return t;
  t = t[0].toUpperCase() + t.substring(1);
  return t.endsWith('?') ? t : '$t?';
}
