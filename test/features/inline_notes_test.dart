import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/domain/services/versification.dart';
import 'package:flutter_test/flutter_test.dart';

/// Poznámky v textu: každá kapitola Bible má aspoň jednu a míří na
/// existující verš (kanonické číslování).
void main() {
  // Počty veršů v anglickém číslování (data souvislostí) → kanonické
  // (hebrejské) kapitoly a verše.
  final english =
      (jsonDecode(File('assets/content/connections.json').readAsStringSync())
              as Map<String, dynamic>)['verses']
          as List;
  final verses = [
    for (var b = 1; b <= 66; b++)
      () {
        final max = <int, int>{};
        final chapters = (english[b - 1] as List).cast<int>();
        for (var c = 1; c <= chapters.length; c++) {
          for (var v = 1; v <= chapters[c - 1]; v++) {
            final r = Versification.convert(
              VerseRef(b, c, v),
              VerseScheme.english,
              VerseScheme.hebrew,
            );
            if (r.verse > (max[r.chapter] ?? 0)) max[r.chapter] = r.verse;
          }
        }
        return [for (var c = 1; c <= max.length; c++) max[c] ?? 0];
      }(),
  ];

  test('každá kapitola má poznámku v textu na existujícím verši', () {
    final missing = <String>[];
    final invalid = <String>[];
    var total = 0;
    for (var b = 1; b <= 66; b++) {
      final counts = (verses[b - 1] as List).cast<int>();
      final f = File(
        'assets/content/chapter_notes/${b.toString().padLeft(2, '0')}.json',
      );
      final j = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      for (final key in j.keys) {
        final c = int.parse(key);
        if (c < 1 || c > counts.length) invalid.add('$b $key');
      }
      for (var c = 1; c <= counts.length; c++) {
        final notes = j['$c'] as List?;
        if (notes == null || notes.isEmpty) missing.add('$b:$c');
        for (final n in notes ?? const []) {
          total++;
          final v = n[0] as int;
          if (v < 1 || v > counts[c - 1]) invalid.add('$b $c:$v');
          expect(['c', 'z', 'l', 'm'], contains(n[1]));
          expect((n[2] as String).trim(), isNotEmpty);
          expect((n[3] as String).length, greaterThan(20));
        }
      }
    }
    expect(missing, isEmpty);
    expect(invalid, isEmpty);
    expect(total, greaterThan(2000));
  });
}
