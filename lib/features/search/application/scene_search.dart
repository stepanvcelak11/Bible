import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/content_entities.dart';
import 'app_search.dart';
import 'reference_parser.dart';

/// Druh scény z rejstříku.
enum SceneKind {
  story('Příběh'),
  miracle('Zázrak'),
  parable('Podobenství'),
  verse('Známý verš');

  const SceneKind(this.label);
  final String label;

  static SceneKind of(String code) => switch (code) {
    'z' => miracle,
    'o' => parable,
    'v' => verse,
    _ => story,
  };
}

/// Konkrétní příběh, zázrak, podobenství nebo známý verš s tím, jak ho
/// lidé popisují (assets/content/scenes.json).
@immutable
class BibleScene {
  BibleScene({
    required this.passage,
    required this.kind,
    required this.title,
    required String words,
  }) : titleStems = _stemsOf(title),
       stems = {..._stemsOf(title), ..._stemsOf(words)};

  factory BibleScene.fromJson(Map<String, Object?> j) => BibleScene(
    passage: Passage.fromJson(j['ref']),
    kind: SceneKind.of(j['kind']! as String),
    title: j['title']! as String,
    words: j['words']! as String,
  );

  final Passage passage;
  final SceneKind kind;
  final String title;
  final Set<String> titleStems;
  final Set<String> stems;
}

/// Slova, která nic neurčují: výplň otázek („kde je ten příběh, jak…“).
const _filler = {
  'kde',
  'je',
  'ten',
  'ta',
  'to',
  'tu',
  'tom',
  'te',
  'ty',
  'jak',
  'jaky',
  'jake',
  'jaka',
  'co',
  'kdo',
  'ktery',
  'ktera',
  'ktere',
  'kterem',
  'kteremu',
  'kterou',
  'kteri',
  'kdyz',
  'jsem',
  'jsi',
  'byl',
  'byla',
  'bylo',
  'byli',
  'bible',
  'bibli',
  'biblicky',
  'pribeh',
  'pribehu',
  'vers',
  'verse',
  'versu',
  'misto',
  'pasaz',
  'pise',
  'psano',
  'napsano',
  'rika',
  'rikal',
  'rekl',
  'rekla',
  'jmenuje',
  'hledam',
  'najdi',
  'chci',
  'nekdo',
  'nekde',
  'neco',
  'jeden',
  'jedna',
  'jedno',
  'tam',
  'tak',
  'pak',
  'potom',
  'a',
  'i',
  'o',
  'u',
  'v',
  've',
  'na',
  'se',
  'si',
  'z',
  'ze',
  'do',
  'od',
  'po',
  'pro',
  's',
  'k',
  'ke',
  'za',
  'aby',
  'ale',
  'jeho',
  'jej',
  'ho',
  'mu',
  'jim',
  'ji',
  'jsou',
  'nam',
  'nas',
  'mi',
  'me',
  'mne',
  'muj',
  'moje',
  'take',
  'jako',
  'uz',
  'jen',
  'jenom',
  'pan',
  'buh',
  'boha',
  'bohu',
  'jezis',
  'jezise',
  'jezisi',
  'kristus',
  'krista',
  'podobenstvi',
  'zazrak',
  'zazraku',
};

final _split = RegExp(r'[^a-z0-9]+');

Set<String> _stemsOf(String text) => {
  for (final w in foldCzech(text).split(_split))
    if (w.length >= 2 && !_filler.contains(w)) stemCzech(w),
};

/// Shoda slova dotazu s kmenem scény: 1 = stejný kmen, 0,8 = jedno
/// začíná druhým (aspoň 4 písmena), 0,7 = překlep (aspoň 6 písmen).
double _match(String q, String s) {
  if (q == s) return 1;
  final short = math.min(q.length, s.length);
  if (short >= 4 && (q.startsWith(s) || s.startsWith(q))) return 0.8;
  if (short >= 6 && oneEdit(q, s)) return 0.7;
  return 0;
}

/// Scéna nalezená k dotazu.
@immutable
class SceneHit {
  const SceneHit(this.scene, this.score, this.coverage);

  final BibleScene scene;
  final double score;

  /// Podíl slov dotazu, která scéna vysvětlí (0–1).
  final double coverage;
}

/// Rejstřík scén s vahou slov podle toho, jak vzácná jsou (IDF): slovo,
/// které má jen jedna scéna („střecha“), rozhoduje víc než časté („voda“).
class SceneIndex {
  SceneIndex(this.scenes) {
    final df = <String, int>{};
    for (final s in scenes) {
      for (final st in s.stems) {
        df[st] = (df[st] ?? 0) + 1;
      }
    }
    final n = scenes.length;
    _idf = {
      for (final MapEntry(:key, :value) in df.entries)
        key: math.log(1 + n / value),
    };
    _maxIdf = math.log(1 + n);
  }

  final List<BibleScene> scenes;
  late final Map<String, double> _idf;
  late final double _maxIdf;

  /// Scény, které dotaz nejspíš popisuje (nejlepší první, nejvýš [limit]).
  List<SceneHit> search(String query, {int limit = 3}) {
    final words = _stemsOf(query).toList();
    if (words.isEmpty) return const [];
    final hits = <SceneHit>[];
    for (final scene in scenes) {
      var score = 0.0, covered = 0.0, total = 0.0;
      for (final q in words) {
        var best = 0.0, weight = 0.0;
        for (final s in scene.stems) {
          final m = _match(q, s);
          if (m > best) {
            best = m;
            weight = _idf[s] ?? _maxIdf;
            if (m == 1) break;
          }
        }
        // Slovo, které neznáme z žádné scény, váží jako vzácné.
        final w = best > 0 ? weight : _maxIdf * 0.6;
        total += w;
        if (best > 0) {
          final inTitle = scene.titleStems.any((t) => _match(q, t) > 0);
          score += best * weight * (inTitle ? 1.4 : 1);
          covered += w;
        }
      }
      if (score == 0) continue;
      final coverage = covered / total;
      hits.add(SceneHit(scene, score * (0.4 + coverage), coverage));
    }
    if (hits.isEmpty) return const [];
    hits.sort((a, b) => b.score.compareTo(a.score));
    final top = hits.first.score;
    // Jednoslovný dotaz („bouře“) stačí jedním slovem, delší popis musí
    // scéna vysvětlit aspoň z poloviny a mít dost vzácných slov.
    final minScore = words.length == 1 ? 1.5 : 2.6;
    return [
      for (final h in hits.take(limit))
        if (h.score >= minScore &&
            h.score >= top * 0.55 &&
            (words.length == 1 || h.coverage >= 0.45))
          h,
    ];
  }
}

final sceneIndexProvider = FutureProvider<SceneIndex>((ref) async {
  final bytes = await rootBundle.load('assets/content/scenes.json');
  final j = jsonDecode(
    utf8.decode(bytes.buffer.asUint8List()),
  ) as Map<String, Object?>;
  return SceneIndex([
    for (final s in j['scenes']! as List<Object?>)
      BibleScene.fromJson(s! as Map<String, Object?>),
  ]);
});
