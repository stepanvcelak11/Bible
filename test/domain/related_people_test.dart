import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/domain/entities/content_entities.dart';
import 'package:bible_reader/features/content/presentation/people_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final json =
      jsonDecode(File('assets/content/people.json').readAsStringSync()) as Map;
  final all = [
    for (final p in json['people'] as List)
      BiblePerson.fromJson(p as Map<String, Object?>),
  ];
  List<String> rel(String id) => [
    for (final p in relatedPeople(all.firstWhere((p) => p.id == id), all)) p.id,
  ];

  test('související postavy podle příbuzných', () {
    expect(rel('adam'), containsAll(['eva', 'kain', 'abel']));
    expect(rel('kain'), containsAll(['adam', 'eva', 'abel']));
    // „Marie“ je nejednoznačná – Marta se neodkáže na Ježíšovu matku.
    expect(rel('marta'), isNot(contains('marie')));
    expect(rel('marta'), contains('lazar'));
    // Jmenovci se nespojí.
    expect(rel('josef'), isNot(contains('menases')));
    expect(rel('absalom'), isNot(contains('tamar')));
    expect(rel('chizkijas'), contains('menases'));
    if (Platform.environment['PRINT'] != null) {
      for (final p in all) {
        // ignore: avoid_print
        print('${p.id}: ${rel(p.id).join(', ')}');
      }
    }
  });
}
