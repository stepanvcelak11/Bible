import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/domain/entities/content_entities.dart';
import 'package:bible_reader/domain/entities/study_entities.dart';
import 'package:bible_reader/features/search/application/bible_answer.dart';
import 'package:bible_reader/features/search/application/scene_search.dart';
import 'package:bible_reader/features/search/application/thought_search.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> _load(String f) =>
    jsonDecode(File('assets/content/$f').readAsStringSync())
        as Map<String, Object?>;

List<T> _list<T>(String file, String key, T Function(Map<String, Object?>) f) =>
    [
      for (final x in _load(file)[key]! as List<Object?>)
        f(x! as Map<String, Object?>),
    ];

/// Kvalita odpovědí na typické dotazy: co odpověď vybere jako hlavní
/// zdroj a jakou větu nabídne. Hlídá, aby ladění jedné otázky nerozbilo
/// jiné.
void main() {
  final c = _load('concepts.json');
  final lexicon = ConceptLexicon(
    (c['stop']! as List<Object?>).cast<String>().toSet(),
    _list('concepts.json', 'concepts', ThoughtConcept.fromJson),
  );
  final questions = StemIndex(
    _list('questions.json', 'questions', BigQuestion.fromJson),
  );
  final scenes = StemIndex(_list('scenes.json', 'scenes', BibleScene.fromJson));
  final topics = _list('topics.json', 'topics', BibleTopic.fromJson);
  final situations = _list('situations.json', 'situations', Situation.fromJson);
  final courses = _list('courses.json', 'courses', StudyCourse.fromJson);
  final people = _list('people.json', 'people', BiblePerson.fromJson);
  final intros = {
    for (final e
        in (_load('book_intros.json')['books']! as Map<String, Object?>)
            .entries)
      int.parse(e.key): BookIntro.fromJson(e.value! as Map<String, Object?>),
  };
  final books = [
    for (final b in jsonDecode(
      File('test/fixtures/books.json').readAsStringSync(),
    ) as List<Object?>)
      if (b case [
        final int id,
        final String osis,
        final String name,
        final String abbr,
        final String t,
      ])
        Book(
          id: id,
          osis: osis,
          name: name,
          abbreviation: abbr,
          testament: t == 'OT'
              ? Testament.oldTestament
              : Testament.newTestament,
        ),
  ];

  BibleAnswer? ask(String q) {
    final plan = planAnswer(
      text: q,
      questions: questions,
      lexicon: lexicon,
      scenes: scenes,
      topics: topics,
      situations: situations,
      courses: courses,
      people: people,
      books: books,
      intros: intros,
    );
    if (plan == null) return null;
    return composeAnswer(
      query: stripBibleFrame(q),
      question: plan.title,
      sources: plan.sources,
      verseText: (p) => 'verš',
    );
  }

  // dotaz → (hlavní zdroj, kus textu odpovědi)
  const cases = {
    'kdo byl Mojžíš': ('Mojžíš', 'vysvoboditel'),
    'proč Mojžíš nevešel do zaslíbené země': ('Mojžíš', 'skály'),
    'jakou chybu udělal David': ('David', 'Batšebou'),
    'kdo byl otec Jana Křtitele': ('Jan Křtitel', 'Zachariáš'),
    'čím se živil Petr': ('Petr (Šimon)', 'rybář'),
    'proč Jidáš zradil Ježíše': ('Jidášův polibek', 'zradil'),
    'o čem je kniha Rút': ('Rút', 'Věrná láska'),
    'kdo napsal Římanům': ('Římanům', 'Pavel'),
    'kdy vznikla kniha Daniel': ('Daniel', 'př. Kr.'),
    'o čem je Zjevení': ('Zjevení Janovo', 'vítězství'),
    'o čem je evangelium podle Marka': ('Marek', 'služebník'),
    'kdo napsal Žalmy': ('Žalmy', 'David'),
    'kdo zabil Goliáše': ('David a Goliáš', '1. Samuelova'),
    'kde se narodil Ježíš': ('Ježíš se narodil v Betlémě', 'Lukáš'),
    'co se stalo v Getsemane': ('Modlitba v Getsemane', 'Getsemane'),
    'kdo byli farizeové': ('Farizeové', 'Zákon'),
    'co je talent': ('Talent', 'denárů'),
    'jak se modlit správně': ('Modlitba', 'rozhovor s Bohem'),
    'proč Ježíš zemřel': ('Kříž a smíření', 'kříži'),
    'co bude po smrti': ('Nebe a Boží domov', 'nového nebe'),
    'smí křesťan pít alkohol': ('Smí křesťan pít alkohol?', 'Neopíjejte'),
    'už nechci žít': ('Co když už nechci žít?', '116 123'),
    'jak odpustit': ('Odpuštění', 'Odpustit'),
    'co je Duch svatý': ('Duch svatý', 'Duch svatý'),
  };

  for (final MapEntry(key: q, value: (source, text)) in cases.entries) {
    test(q, () {
      final a = ask(q);
      expect(a, isNotNull, reason: q);
      final all = a!.sentences.map((s) => s.text).join(' ');
      expect(
        a.sources.map((s) => s.title).take(2),
        contains(source),
        reason: '$q → ${a.sources.map((s) => s.title).toList()}',
      );
      expect(all, contains(text), reason: '$q → $all');
    });
  }

  test('bez výkladu v aplikaci nic nevymýšlí', () {
    expect(ask('co Bible říká o potratech'), isNull);
    // „žít“ samo o sobě nespouští krizovou odpověď.
    expect(ask('jak žít podle Bible')!.question, 'Jak žít podle Bible?');
  });
}
