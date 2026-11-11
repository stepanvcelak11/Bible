import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/domain/entities/content_entities.dart';
import 'package:bible_reader/features/search/application/bible_answer.dart';
import 'package:bible_reader/features/search/application/scene_search.dart';
import 'package:bible_reader/features/search/application/thought_search.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> _load(String f) =>
    jsonDecode(File('assets/content/$f').readAsStringSync())
        as Map<String, Object?>;

void main() {
  final questions = StemIndex([
    for (final q in _load('questions.json')['questions']! as List<Object?>)
      BigQuestion.fromJson(q! as Map<String, Object?>),
  ]);
  final c = _load('concepts.json');
  final lexicon = ConceptLexicon(
    (c['stop']! as List<Object?>).cast<String>().toSet(),
    [
      for (final x in c['concepts']! as List<Object?>)
        ThoughtConcept.fromJson(x! as Map<String, Object?>),
    ],
  );
  final topics = [
    for (final t in _load('topics.json')['topics']! as List<Object?>)
      BibleTopic.fromJson(t! as Map<String, Object?>),
  ];
  final situations = [
    for (final t in _load('situations.json')['situations']! as List<Object?>)
      Situation.fromJson(t! as Map<String, Object?>),
  ];
  final courses = [
    for (final t in _load('courses.json')['courses']! as List<Object?>)
      StudyCourse.fromJson(t! as Map<String, Object?>),
  ];

  BibleAnswer? answer(String q) {
    final question = pickQuestion(questions, q);
    return composeAnswer(
      query: q,
      question: question?.title ?? q,
      sources: answerSources(
        text: q,
        question: question,
        concepts: lexicon.detect(q),
        topics: topics,
        situations: situations,
        courses: courses,
      ),
      verseText: (p) => 'verš',
    );
  }

  test('obecné otázky najdou velkou otázku', () {
    String? title(String q) {
      final m = questions.search(q, limit: 1);
      return m.isEmpty ? null : m.first.item.title;
    }

    expect(title('jak se modlit správně'), 'Jak se správně modlit?');
    expect(title('proč je na světě zlo'), 'Proč je na světě zlo?');
    expect(title('jak vznikl vesmír'), 'Jak vznikl svět a vesmír?');
    expect(
      title('co dělat když nevím jak dál'),
      'Co dělat, když nevím jak dál?',
    );
    expect(title('proč Bůh dopustil holocaust'), 'Proč je na světě zlo?');
  });

  test('odpověď se skládá z vět, které k otázce sedí', () {
    final pray = answer('jak se modlit správně')!;
    expect(pray.sentences, isNotEmpty);
    expect(pray.sentences.first.text, contains('Modlitba'));
    expect(pray.verses.length, 4);

    // Jiná formulace → jiný výběr: otázka na zlo vybere větu o zlu.
    final evil = answer('proč je na světě zlo')!;
    expect(evil.sentences.map((s) => s.text).join(' '), contains('Zlo'));
    // Věty navazující na předchozí („Týká se…“) se samy nevybírají.
    for (final s in evil.sentences) {
      expect(s.text, isNot(startsWith('Týká')));
    }

    // „Stát se křesťanem“ není o státu a politice.
    final christian = answer('jak se stát křesťanem')!;
    expect(
      christian.sources.map((s) => s.title),
      isNot(contains('Křesťan a společnost')),
    );
  });

  test('pocit bez otázky nedostane výklad, otázka podle pojmu ano', () {
    expect(answer('mám radost'), isNull);
    expect(answer('smysl života'), isNotNull);
    expect(looksLikeQuestion('proč mám pořád strach'), isTrue);
    expect(answer('proč mám pořád strach'), isNotNull);
  });
}
