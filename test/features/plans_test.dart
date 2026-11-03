import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/features/plans/application/plans.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('plány měst a staveb: čísla uvnitř plánu, u každého verše', () {
    final j = jsonDecode(
      File('assets/content/plans.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final plans = [
      for (final p in j['plans']! as List<Object?>)
        BiblePlan.fromJson(p! as Map<String, Object?>),
    ];
    expect(plans.length, greaterThanOrEqualTo(9));
    expect(plans.first.group, 'Jeruzalém');
    for (final p in plans) {
      expect(p.shapes, isNotEmpty, reason: p.id);
      expect(p.chapters, isNotEmpty, reason: p.id);
      final numbers = [for (final part in p.parts) part.number];
      expect(numbers, [for (var i = 1; i <= numbers.length; i++) i]);
      for (final part in p.parts) {
        expect(part.refs, isNotEmpty, reason: '${p.id} ${part.name}');
        expect(
          (Offset.zero & p.size).contains(part.at),
          isTrue,
          reason: '${p.id} ${part.name}',
        );
      }
    }
  });
}
