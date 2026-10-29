import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/core/utils/fts_query.dart';
import 'package:bible_reader/features/prep/application/thought_search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final j = jsonDecode(
    File('assets/content/concepts.json').readAsStringSync(),
  ) as Map<String, Object?>;
  final lexicon = ConceptLexicon(
    (j['stop']! as List<Object?>).cast<String>().toSet(),
    [
      for (final c in j['concepts']! as List<Object?>)
        ThoughtConcept.fromJson(c! as Map<String, Object?>),
    ],
  );

  List<String> ids(String text) =>
      lexicon.detect(text).map((c) => c.id).toList();

  test('myšlenka vlastními slovy → pojmy', () {
    expect(
      ids('Bůh nás nenechá samotné, když máme strach'),
      containsAll(['abandon', 'fear']),
    );
    expect(ids('Nemusím se bát zítřka'), containsAll(['fear', 'anxiety']));
    expect(
      ids('Bůh mi odpouští i když selžu'),
      containsAll(['forgive', 'sin']),
    );
    expect(ids('Kdo se cítí bezcenný, je pro Boha drahý'), contains('worth'));
    expect(ids('Jsem vyčerpaný a potřebuju odpočinek'), contains('tired'));
    // Obecná slova sama téma neurčují.
    expect(ids('Bůh je a Ježíš řekl'), isEmpty);
  });

  test('slova mimo pojmy se hledají doslova', () {
    const text = 'Abraham věřil Bohu';
    final found = lexicon.detect(text);
    expect(found.map((c) => c.id), contains('faith'));
    expect(lexicon.keywords(text, found), ['abrah']);
  });

  test('dotaz „aspoň jedno z“ pro FTS5', () {
    expect(
      buildFtsAnyQuery(['strach', 'sám=', 's_tebou']),
      '"strach"* OR "sám" OR "s tebou"*',
    );
    expect(buildFtsAnyQuery(['', '*']), isNull);
  });
}
