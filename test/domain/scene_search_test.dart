import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/features/search/application/scene_search.dart';
import 'package:bible_reader/features/search/application/thought_search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final scenes = SceneIndex([
    for (final s
        in (jsonDecode(File('assets/content/scenes.json').readAsStringSync())
                as Map<String, Object?>)['scenes']!
            as List<Object?>)
      BibleScene.fromJson(s! as Map<String, Object?>),
  ]);
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

  String? first(String q) {
    final r = scenes.search(q);
    return r.isEmpty ? null : r.first.scene.title;
  }

  List<String> concepts(String q) =>
      lexicon.detect(q).map((c) => c.label).toList();

  test('scéna z volného popisu (i bez diakritiky a s překlepem)', () {
    expect(
      first('muž kterého spustili střechou'),
      'Ochrnutého spustili střechou',
    );
    expect(first('jak Petr chodil po vode'), 'Petr kráčí po vodě');
    expect(first('ten verš o lásce co je trpělivá'), 'Láska je trpělivá');
    expect(first('obr a malý pastýř s prakem'), 'David a Goliáš');
    expect(first('syn co utekl z domova a prohýřil peníze'), 'Marnotratný syn');
    expect(
      first('zapřel ho třikrát než kohout zakokrhal'),
      'Petr třikrát zapře',
    );
    expect(first('velryba'), 'Jonáš v břiše ryby');
    expect(first('kdo je můj bližní'), 'Milosrdný Samaritán');
  });

  test('obecná věta nevymyslí scénu', () {
    expect(scenes.search('mám dnes hezký den a jdu nakoupit'), isEmpty);
  });

  test('hovorové věty a překlepy rozpozná jako pojmy', () {
    expect(concepts('jsem na dně'), contains('Beznaděj'));
    expect(concepts('nikdo mě nemá rád'), contains('Odmítnutí'));
    expect(concepts('rozešel jsem se s holkou'), ['Rozvod a rozpad vztahu']);
    expect(concepts('mám strah'), ['Strach']);
    expect(concepts('odpustěni'), ['Odpuštění']);
    final roof = scenes.search('muž, kterého spustili střechou');
    expect(
      lexicon.detect(
        'muž, kterého spustili střechou',
        known: {for (final h in roof) ...h.scene.stems},
      ),
      isEmpty,
    );
    expect(
      concepts('bojím se, že umře máma'),
      isNot(contains('Vítězství nad zlem')),
    );
  });
}
