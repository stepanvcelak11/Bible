import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/content_entities.dart';

/// Tvar plánu: obdélník, mnohoúhelník, čára, kruh, popisek, měřítko,
/// směrovka. Souřadnice v plátně plánu.
class PlanShape {
  const PlanShape(this.kind, this.style, this.points, this.text);

  factory PlanShape.fromJson(Map<String, Object?> j) => PlanShape(
    j['k']! as String,
    j['s']! as String,
    [for (final n in j['p']! as List<Object?>) (n! as num).toDouble()],
    j['t'] as String?,
  );

  final String kind;
  final String style;
  final List<double> points;
  final String? text;
}

/// Očíslované místo na plánu s popisem a odkazy.
class PlanPart {
  const PlanPart(this.number, this.at, this.name, this.text, this.refs);

  factory PlanPart.fromJson(Map<String, Object?> j) => PlanPart(
    j['n']! as int,
    Offset((j['x']! as num).toDouble(), (j['y']! as num).toDouble()),
    j['name']! as String,
    j['text']! as String,
    parsePassages(j['refs']),
  );

  final int number;
  final Offset at;
  final String name;
  final String text;
  final List<Passage> refs;
}

/// Plán města nebo stavby (vlastní schematická kresba aplikace).
class BiblePlan {
  const BiblePlan({
    required this.id,
    required this.group,
    required this.title,
    required this.subtitle,
    required this.intro,
    required this.size,
    required this.shapes,
    required this.parts,
    required this.refs,
    required this.chapters,
  });

  factory BiblePlan.fromJson(Map<String, Object?> j) => BiblePlan(
    id: j['id']! as String,
    group: j['group']! as String,
    title: j['title']! as String,
    subtitle: j['subtitle']! as String,
    intro: j['intro']! as String,
    size: Size((j['w']! as num).toDouble(), (j['h']! as num).toDouble()),
    shapes: [
      for (final s in j['shapes']! as List<Object?>)
        PlanShape.fromJson(s! as Map<String, Object?>),
    ],
    parts: [
      for (final p in j['parts']! as List<Object?>)
        PlanPart.fromJson(p! as Map<String, Object?>),
    ],
    refs: parsePassages(j['refs']),
    chapters: {
      for (final c in j['chapters']! as List<Object?>)
        ((c! as List<Object?>)[0]! as int, (c as List<Object?>)[1]! as int),
    },
  );

  final String id;
  final String group;
  final String title;
  final String subtitle;
  final String intro;
  final Size size;
  final List<PlanShape> shapes;
  final List<PlanPart> parts;
  final List<Passage> refs;

  /// Kapitoly (kanonicky), u kterých má smysl plán nabídnout.
  final Set<(int, int)> chapters;
}

final plansProvider = FutureProvider<List<BiblePlan>>((ref) async {
  final bytes = await rootBundle.load('assets/content/plans.json');
  final j = jsonDecode(
    utf8.decode(bytes.buffer.asUint8List()),
  ) as Map<String, Object?>;
  return [
    for (final p in j['plans']! as List<Object?>)
      BiblePlan.fromJson(p! as Map<String, Object?>),
  ];
});

/// Plány ke kapitole (kanonické číslování).
final chapterPlansProvider = Provider.family<List<BiblePlan>, (int, int)>(
  (ref, chapter) => [
    for (final p in ref.watch(plansProvider).value ?? const <BiblePlan>[])
      if (p.chapters.contains(chapter)) p,
  ],
);
