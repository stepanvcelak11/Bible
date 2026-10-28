import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Počty kapitol v kanonickém (hebrejském) číslování.
const _chapters = [
  50, 40, 27, 36, 34, 24, 21, 4, 31, 24, 22, 25, 29, 36, 10, 13, 10, 42, //
  150, 31, 12, 8, 66, 52, 5, 48, 12, 14, 4, 9, 1, 4, 7, 3, 3, 3, 2, 14, 3,
  28, 16, 24, 21, 28, 16, 16, 13, 6, 6, 4, 4, 5, 3, 6, 4, 3, 1, 13, 5, 5,
  3, 5, 1, 1, 1, 22,
];

void main() {
  test('zamyšlení: každá kapitola Bible má zaměření a tři otázky', () {
    final books =
        (jsonDecode(File('assets/content/reflections.json').readAsStringSync())
                as Map<String, Object?>)['books']!
            as Map<String, Object?>;
    for (var b = 1; b <= 66; b++) {
      final rows = books['$b']! as List;
      expect(rows, hasLength(_chapters[b - 1]), reason: 'kniha $b');
      for (final r in rows) {
        final parts = (r as List).cast<String>();
        expect(parts, hasLength(4));
        for (final q in parts.skip(1)) {
          expect(q, contains('?'));
        }
      }
    }
  });
}
