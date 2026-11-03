import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/domain/services/timeline.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Počty veršů kanonických kapitol (z dat souvislostí).
  final chapters =
      (jsonDecode(File('assets/content/connections.json').readAsStringSync())
              as Map<String, dynamic>)['verses']
          as List;

  test('každá kapitola Bible má místo na časové ose', () {
    final missing = <String>[];
    for (var b = 1; b <= 66; b++) {
      final count = (chapters[b - 1] as List).length;
      for (var c = 1; c <= count; c++) {
        if (timelinePlaceOf(b, c) == null) missing.add('$b:$c');
      }
    }
    expect(missing, isEmpty);
  });

  test('úseky kapitol nepřesahují knihu', () {
    for (final e in timelineEvents) {
      for (final s in e.chapters) {
        final count = (chapters[s.bookId - 1] as List).length;
        expect(s.from, inInclusiveRange(1, count), reason: e.title);
        if (s.to != 999) {
          expect(s.to, inInclusiveRange(s.from, count), reason: e.title);
        }
      }
    }
  });

  test('nejužší úsek vyhrává', () {
    expect(timelinePlaceOf(19, 51)!.span.note, contains('Batšebou'));
    expect(timelinePlaceOf(19, 23)!.event.title, 'Král David');
    expect(timelinePlaceOf(19, 1)!.span, psalterSpan);
    expect(timelinePlaceOf(19, 90)!.event.title, 'Čtyřicet let na poušti');
    expect(timelinePlaceOf(44, 9)!.event.title, 'Obrácení apoštola Pavla');
    expect(timelinePlaceOf(1, 37)!.event.title, 'Josef v Egyptě');
  });
}
