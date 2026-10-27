import 'package:flutter/foundation.dart';

import 'bible_entities.dart';

/// Biblické místo: verš, rozsah veršů nebo celá kapitola (verse == 0),
/// v kanonickém (hebrejském) číslování.
@immutable
class Passage {
  const Passage(
    this.bookId,
    this.chapter,
    this.verse,
    this.end, [
    int? endChapter,
  ]) : endChapter = endChapter ?? chapter;

  /// `[kniha, kapitola, verš, konec, (kapitola konce)]`.
  factory Passage.fromJson(Object? json) {
    final l = (json! as List<Object?>).cast<int>();
    return Passage(
      l[0],
      l[1],
      l[2],
      l.length > 3 ? l[3] : l[2],
      l.length > 4 ? l[4] : null,
    );
  }

  final int bookId;
  final int chapter;

  /// 0 = celá kapitola.
  final int verse;
  final int end;

  /// Kapitola, ve které úsek končí (Mt 5,1–7,29).
  final int endChapter;

  bool get wholeChapter => verse == 0;

  VerseRef get start => VerseRef(bookId, chapter, verse == 0 ? 1 : verse);

  /// „Ž 34,19“, „Fp 4,6–7“, „Mt 5,1–7,29“, „Gn 12“.
  String label(String bookAbbreviation) =>
      '$bookAbbreviation $shortLabel'.trim();

  /// Bez knihy: „34,19“, „5,1–7,29“.
  String get shortLabel => wholeChapter
      ? '$chapter'
      : endChapter != chapter
      ? '$chapter,$verse–$endChapter,$end'
      : end > verse
      ? '$chapter,$verse–$end'
      : '$chapter,$verse';
}

List<Passage> parsePassages(Object? json) => [
  for (final p in (json as List<Object?>? ?? const [])) Passage.fromJson(p),
];

/// Skupina situací („Pocity“…).
class SituationGroup {
  const SituationGroup(this.id, this.name);

  final String id;
  final String name;
}

/// Verše do životní situace.
class Situation {
  const Situation({
    required this.id,
    required this.group,
    required this.icon,
    required this.title,
    required this.intro,
    required this.passages,
  });

  factory Situation.fromJson(Map<String, Object?> j) => Situation(
    id: j['id']! as String,
    group: j['group']! as String,
    icon: j['icon']! as String,
    title: j['title']! as String,
    intro: j['intro']! as String,
    passages: parsePassages(j['refs']),
  );

  final String id;
  final String group;
  final String icon;
  final String title;
  final String intro;
  final List<Passage> passages;
}

/// Medailon biblické postavy.
class BiblePerson {
  const BiblePerson({
    required this.id,
    required this.name,
    required this.role,
    required this.books,
    required this.where,
    required this.occupation,
    required this.relatives,
    required this.strengths,
    required this.weaknesses,
    required this.lessons,
    required this.key,
    required this.story,
  });

  factory BiblePerson.fromJson(Map<String, Object?> j) {
    List<String> strings(String k) => (j[k]! as List<Object?>).cast<String>();
    return BiblePerson(
      id: j['id']! as String,
      name: j['name']! as String,
      role: j['role']! as String,
      books: (j['books']! as List<Object?>).cast<int>(),
      where: j['where']! as String,
      occupation: j['occupation']! as String,
      relatives: j['relatives']! as String,
      strengths: strings('strengths'),
      weaknesses: strings('weaknesses'),
      lessons: strings('lessons'),
      key: Passage.fromJson(j['key']),
      story: parsePassages(j['story']),
    );
  }

  final String id;
  final String name;
  final String role;

  /// Knihy, ve kterých se o postavě vypráví (pro odkazy z úvodů).
  final List<int> books;
  final String where;
  final String occupation;
  final String relatives;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> lessons;
  final Passage key;
  final List<Passage> story;

  bool get isNewTestament => books.first >= 40;
}

/// Událost harmonie evangelií: paralelní místa u Mt, Mk, L a J.
class HarmonyEvent {
  const HarmonyEvent(this.title, this.refs);

  factory HarmonyEvent.fromJson(Map<String, Object?> j) =>
      HarmonyEvent(j['title']! as String, [
        for (final r in j['refs']! as List<Object?>)
          r == null ? null : Passage.fromJson(r),
      ]);

  final String title;

  /// Vždy 4 položky (Mt, Mk, L, J); `null` = evangelium událost nemá.
  final List<Passage?> refs;
}

class HarmonyPeriod {
  const HarmonyPeriod(this.name, this.events);

  final String name;
  final List<HarmonyEvent> events;
}
