import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/features/illustrations/application/illustrations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('kresba: relativní tahy se převedou na cestu', () {
    final path = parseSketch('M10 10l10 0 0 10M40 40l2 2 2 2 2 2');
    final b = path.getBounds();
    expect(b.left, 10);
    expect(b.top, 10);
    expect(b.right, 46);
    expect(b.bottom, 46);
  });

  test('ilustrace: platná data, kresba v každé kapitole', () {
    final j =
        jsonDecode(File('assets/content/illustrations.json').readAsStringSync())
            as Map<String, Object?>;
    final items = [
      for (final i in j['items']! as List)
        Illustration.fromJson(i as Map<String, Object?>),
    ];
    expect(items.length, greaterThan(1188));
    final chapters = <(int, int)>{};
    for (final il in items) {
      expect(il.caption, isNotEmpty);
      expect(il.width, greaterThan(0));
      expect(il.path.getBounds().isEmpty, isFalse);
      chapters.add((il.ref.bookId, il.ref.chapter));
    }
    // Všech 66 knih má aspoň jednu kresbu.
    expect({for (final c in chapters) c.$1}.length, 66);
    // Kresba je v každé z 1189 kapitol (kanonické číslování).
    expect(chapters.length, 1189);
  });
}
