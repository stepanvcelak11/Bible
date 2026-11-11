import 'package:bible_reader/domain/services/progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nejdelší série dní (i přes konec měsíce)', () {
    expect(longestStreak([]), 0);
    expect(
      longestStreak([
        DateTime(2026, 1, 30, 20),
        DateTime(2026, 1, 31, 8),
        DateTime(2026, 1, 31, 21),
        DateTime(2026, 2, 1),
        DateTime(2026, 2, 5),
      ]),
      3,
    );
  });

  test('aktuální série: dnes, nebo ještě ze včerejška', () {
    final today = DateTime(2026, 3, 1);
    final days = [DateTime(2026, 2, 27), DateTime(2026, 2, 28)];
    expect(currentStreak(days, today), 2);
    expect(currentStreak([...days, today], today), 3);
    expect(currentStreak([DateTime(2026, 2, 26)], today), 0);
    expect(currentStreak([], today), 0);
  });

  test('odznaky podle přečtených kapitol a série', () {
    final counts = {for (var b = 1; b <= 66; b++) b: 2};
    final read = {
      41: {1, 2},
      19: {1},
    };
    final badges = {
      for (final b in computeBadges(read: read, counts: counts, streak: 4))
        b.id: b.earned,
    };
    expect(badges['first'], isTrue);
    expect(badges['streak3'], isTrue);
    expect(badges['streak7'], isFalse);
    expect(badges['gospel'], isTrue);
    expect(badges['gospels'], isFalse);
    expect(badges['psalms'], isFalse);
    expect(badges['bible'], isFalse);
  });
}
