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

  @override
  bool operator ==(Object other) =>
      other is Passage &&
      other.bookId == bookId &&
      other.chapter == chapter &&
      other.verse == verse &&
      other.end == end &&
      other.endChapter == endChapter;

  @override
  int get hashCode => Object.hash(bookId, chapter, verse, end, endChapter);
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
    this.thoughts = const [],
    this.steps = const [],
    this.prayer,
  });

  factory Situation.fromJson(Map<String, Object?> j) => Situation(
    id: j['id']! as String,
    group: j['group']! as String,
    icon: j['icon']! as String,
    title: j['title']! as String,
    intro: j['intro']! as String,
    passages: parsePassages(j['refs']),
    thoughts: (j['thoughts'] as List<Object?>? ?? const []).cast<String>(),
    steps: (j['steps'] as List<Object?>? ?? const []).cast<String>(),
    prayer: j['prayer'] as String?,
  );

  final String id;
  final String group;
  final String icon;
  final String title;
  final String intro;
  final List<Passage> passages;

  /// Rozšířené zamyšlení (odstavce).
  final List<String> thoughts;

  /// Praktické kroky „Co můžu udělat“.
  final List<String> steps;

  /// Krátká modlitba.
  final String? prayer;
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

/// Aplikační poznámka: výklad, spojovací most a aplikace.
class AppNote {
  const AppNote({
    required this.id,
    required this.passage,
    required this.title,
    required this.explanation,
    required this.bridge,
    required this.application,
  });

  factory AppNote.fromJson(Map<String, Object?> j) => AppNote(
    id: j['id']! as String,
    passage: Passage.fromJson(j['ref']),
    title: j['title']! as String,
    explanation: j['explanation']! as String,
    bridge: j['bridge']! as String,
    application: j['application']! as String,
  );

  final String id;
  final Passage passage;
  final String title;
  final String explanation;
  final String bridge;
  final String application;
}

/// Buňka tabulky: text, případně s biblickým odkazem.
class TableCellData {
  const TableCellData(this.text, [this.passage]);

  factory TableCellData.fromJson(Object? j) => j is String
      ? TableCellData(j)
      : TableCellData(
          (j! as Map<String, Object?>)['t']! as String,
          Passage.fromJson((j as Map<String, Object?>)['r']),
        );

  final String text;
  final Passage? passage;
}

/// Tabulka / přehled.
class ContentTable {
  const ContentTable({
    required this.id,
    required this.title,
    required this.intro,
    required this.columns,
    required this.rows,
    required this.note,
  });

  factory ContentTable.fromJson(Map<String, Object?> j) => ContentTable(
    id: j['id']! as String,
    title: j['title']! as String,
    intro: j['intro']! as String,
    columns: (j['columns']! as List<Object?>).cast<String>(),
    rows: [
      for (final r in j['rows']! as List<Object?>)
        [for (final c in r! as List<Object?>) TableCellData.fromJson(c)],
    ],
    note: j['note'] as String? ?? '',
  );

  final String id;
  final String title;
  final String intro;
  final List<String> columns;
  final List<List<TableCellData>> rows;
  final String note;
}

/// Biblické téma: shrnutí a klíčová místa s popiskem.
class BibleTopic {
  const BibleTopic({
    required this.id,
    required this.category,
    required this.icon,
    required this.title,
    required this.summary,
    required this.passages,
    required this.labels,
  });

  factory BibleTopic.fromJson(Map<String, Object?> j) => BibleTopic(
    id: j['id']! as String,
    category: j['category']! as String,
    icon: j['icon']! as String,
    title: j['title']! as String,
    summary: j['summary']! as String,
    passages: parsePassages(j['refs']),
    labels: (j['labels']! as List<Object?>).cast<String>(),
  );

  final String id;
  final String category;
  final String icon;
  final String title;
  final String summary;
  final List<Passage> passages;
  final List<String> labels;
}

/// Otázka biblického kvízu; `answers.first` je správná odpověď.
@immutable
class QuizQuestion {
  const QuizQuestion({
    required this.category,
    required this.question,
    required this.answers,
    required this.passage,
  });

  factory QuizQuestion.fromJson(Map<String, Object?> j) => QuizQuestion(
    category: j['category']! as String,
    question: j['question']! as String,
    answers: (j['answers']! as List<Object?>).cast<String>(),
    passage: Passage.fromJson(j['ref']),
  );

  final String category;
  final String question;
  final List<String> answers;
  final Passage passage;

  String get correct => answers.first;
}

/// Doba nebo svátek církevního roku (texty a čtení; data počítá
/// `ChurchYear`).
class ChurchYearItem {
  const ChurchYearItem({
    required this.id,
    required this.color,
    required this.name,
    required this.text,
    required this.passages,
  });

  factory ChurchYearItem.fromJson(Map<String, Object?> j) => ChurchYearItem(
    id: j['id']! as String,
    color: j['color']! as String,
    name: j['name']! as String,
    text: j['text']! as String,
    passages: parsePassages(j['refs']),
  );

  final String id;

  /// Liturgická barva: violet, white, green, red.
  final String color;
  final String name;
  final String text;
  final List<Passage> passages;
}

/// Zastavení „červené nitě“: místo, nadpis a proč sem patří.
class ThreadStation {
  const ThreadStation(this.passage, this.title, this.text);

  final Passage passage;
  final String title;
  final String text;
}

/// Červená nit Bible – motiv, který se táhne mnoha knihami.
class BibleThread {
  const BibleThread({
    required this.id,
    required this.color,
    required this.icon,
    required this.title,
    required this.intro,
    required this.stations,
  });

  factory BibleThread.fromJson(Map<String, Object?> j) => BibleThread(
    id: j['id']! as String,
    color: j['color']! as int,
    icon: j['icon']! as String,
    title: j['title']! as String,
    intro: j['intro']! as String,
    stations: [
      for (final s
          in (j['stations']! as List<Object?>).cast<Map<String, Object?>>())
        ThreadStation(
          Passage.fromJson(s['ref']),
          s['title']! as String,
          s['text']! as String,
        ),
    ],
  );

  final String id;

  /// Barva (ARGB).
  final int color;
  final String icon;
  final String title;
  final String intro;
  final List<ThreadStation> stations;
}

/// Období velkého příběhu Bible.
class StoryEra {
  const StoryEra({
    required this.id,
    required this.title,
    required this.period,
    required this.summary,
    required this.books,
    required this.branches,
    required this.key,
  });

  factory StoryEra.fromJson(Map<String, Object?> j) => StoryEra(
    id: j['id']! as String,
    title: j['title']! as String,
    period: j['period']! as String,
    summary: j['summary']! as String,
    books: (j['books']! as List<Object?>).cast<int>(),
    branches: [
      for (final b
          in (j['branches']! as List<Object?>).cast<Map<String, Object?>>())
        (b['label']! as String, (b['books']! as List<Object?>).cast<int>()),
    ],
    key: [
      for (final k in (j['key']! as List<Object?>).cast<Map<String, Object?>>())
        (Passage.fromJson(k['ref']), k['label']! as String),
    ],
  );

  final String id;
  final String title;
  final String period;
  final String summary;

  /// Knihy, které o období vyprávějí.
  final List<int> books;

  /// Knihy, které k období patří (proroci, žalmy, listy…).
  final List<(String, List<int>)> branches;

  /// Klíčové kapitoly.
  final List<(Passage, String)> key;
}

/// Příběh Bible v myšlenkové mapě: patří k období, má postavy
/// a souvislosti s jinými příběhy.
class BibleStory {
  const BibleStory({
    required this.id,
    required this.era,
    required this.title,
    required this.span,
    required this.passage,
    required this.summary,
    required this.people,
    required this.links,
  });

  factory BibleStory.fromJson(Map<String, Object?> j) => BibleStory(
    id: j['id']! as String,
    era: j['era']! as String,
    title: j['title']! as String,
    span: j['span']! as String,
    passage: Passage.fromJson(j['ref']),
    summary: j['summary']! as String,
    people: (j['people']! as List<Object?>).cast<String>(),
    links: [
      for (final l
          in (j['links']! as List<Object?>).cast<Map<String, Object?>>())
        (l['to']! as String, l['label']! as String),
    ],
  );

  final String id;

  /// Id období ([StoryEra.id]).
  final String era;
  final String title;

  /// Rozsah kapitol k zobrazení („Gn 12–15“).
  final String span;

  /// První kapitola příběhu.
  final Passage passage;
  final String summary;

  /// Id postav ([BiblePerson.id]).
  final List<String> people;

  /// Souvislosti zapsané u tohoto příběhu: (id příběhu, proč).
  final List<(String, String)> links;
}

/// Souhrn křížových odkazů (OpenBible.info) v anglickém číslování.
class BibleConnections {
  BibleConnections({
    required this.verses,
    required this.arcs,
    required this.pairs,
    required this.examples,
  }) : chapterStart = [
         for (var b = 0, s = 0; b < verses.length; s += verses[b].length, b++)
           s,
       ];

  factory BibleConnections.fromJson(Map<String, Object?> j) {
    List<List<int>> ints(Object? o) => [
      for (final x in o! as List<Object?>) (x! as List<Object?>).cast<int>(),
    ];
    return BibleConnections(
      verses: ints(j['verses']),
      arcs: ints(j['arcs']),
      pairs: ints(j['pairs']),
      examples: {
        for (final e in (j['examples']! as Map<String, Object?>).entries)
          e.key: ints(e.value),
      },
    );
  }

  /// Počty veršů v kapitolách po knihách.
  final List<List<int>> verses;

  /// [kapitola A, kapitola B, váha] – globální index kapitoly.
  final List<List<int>> arcs;

  /// [kniha A, kniha B, váha], A < B, od nejsilnějších.
  final List<List<int>> pairs;

  /// "A-B" → [kniha, kap., verš, kniha, kap., verš, konec].
  final Map<String, List<List<int>>> examples;

  /// Globální index první kapitoly knihy (0-based podle knihy).
  final List<int> chapterStart;

  int get chapterCount => chapterStart.last + verses.last.length;

  /// Kniha (1–66) kapitoly s globálním indexem [index].
  int bookOfChapter(int index) {
    var b = 0;
    while (b + 1 < chapterStart.length && chapterStart[b + 1] <= index) {
      b++;
    }
    return b + 1;
  }

  /// Nejsilnější spojení knihy [book]: (druhá kniha, váha).
  List<(int, int)> partnersOf(int book) => [
    for (final p in pairs)
      if (p[0] == book) (p[1], p[2]) else if (p[1] == book) (p[0], p[2]),
  ];

  List<List<int>> examplesFor(int a, int b) =>
      examples[a < b ? '$a-$b' : '$b-$a'] ?? const [];
}

/// Zamyšlení ke kapitole: o čem kapitola je a tři vlastní otázky
/// (pozoruj, pochop, pro život).
class ChapterReflection {
  const ChapterReflection(this.focus, this.observe, this.understand, this.life);

  final String focus;
  final String observe;
  final String understand;
  final String life;
}
