import 'package:bible_reader/domain/services/bible_content.dart';
import 'package:flutter_test/flutter_test.dart';

/// Počty kapitol (ČEP/ČSP – hebrejské číslování).
const _chapters = [
  50, 40, 27, 36, 34, 24, 21, 4, 31, 24, 22, 25, 29, 36, 10, 13, 10, 42, //
  150, 31, 12, 8, 66, 52, 5, 48, 12, 14, 4, 9, 1, 4, 7, 3, 3, 3, 2, 14, 3,
  28, 16, 24, 21, 28, 16, 16, 13, 6, 6, 4, 4, 5, 3, 6, 4, 3, 1, 13, 5, 5,
  3, 5, 1, 1, 1, 22,
];

void main() {
  final counts = {for (var i = 0; i < 66; i++) i + 1: _chapters[i]};

  for (final plan in readingPlans) {
    test('plán ${plan.id}: každý den má čtení, kapitoly existují', () {
      final days = plan.schedule(counts);
      expect(days, hasLength(plan.days));
      for (final day in days) {
        expect(day, isNotEmpty);
        for (final r in day) {
          expect(r.chapter, inInclusiveRange(1, counts[r.bookId]!));
        }
      }
    });
  }

  test('celá Bible souběžně pokryje všech 1189 kapitol právě jednou', () {
    final plan = readingPlans.firstWhere((p) => p.id == 'both365');
    final all = plan.schedule(counts).expand((d) => d).toList();
    expect(all, hasLength(1189));
    expect(all.toSet(), hasLength(1189));
  });
}
