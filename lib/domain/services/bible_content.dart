import '../entities/bible_entities.dart';

/// Skupina biblických knih (pro přehledný výběr knihy).
class BookCategory {
  const BookCategory(this.name, this.first, this.last, this.color);

  final String name;
  final int first;
  final int last;

  /// Barva kategorie (ARGB).
  final int color;

  bool contains(int bookId) => bookId >= first && bookId <= last;
  Testament get testament =>
      first >= 40 ? Testament.newTestament : Testament.oldTestament;
}

const bookCategories = [
  BookCategory('Zákon (Tóra)', 1, 5, 0xFFB0813B),
  BookCategory('Historické knihy', 6, 17, 0xFF7C8B5A),
  BookCategory('Poezie a moudrost', 18, 22, 0xFF8C6BA8),
  BookCategory('Velcí proroci', 23, 27, 0xFFC0603F),
  BookCategory('Malí proroci', 28, 39, 0xFFCF8A45),
  BookCategory('Evangelia', 40, 43, 0xFF3F7CAC),
  BookCategory('Dějiny církve', 44, 44, 0xFF4E9A8A),
  BookCategory('Pavlovy listy', 45, 57, 0xFF5D6FB0),
  BookCategory('Obecné listy', 58, 65, 0xFF8A6F9E),
  BookCategory('Proroctví', 66, 66, 0xFFA8475B),
];

BookCategory categoryOf(int bookId) =>
    bookCategories.firstWhere((c) => c.contains(bookId));

// --- Plány čtení -----------------------------------------------------------------

/// Plán čtení: rozdělení vybraných kapitol do dní.
class ReadingPlan {
  const ReadingPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.days,
    required this.books,
    this.dailyPattern,
  });

  final String id;
  final String name;
  final String description;
  final int days;

  /// Knihy v pořadí čtení.
  final List<int> books;

  /// Vlastní rozvrh (Žalmy + Přísloví) – jinak rovnoměrné rozdělení.
  final List<List<VerseRef>> Function(Map<int, int> counts)? dailyPattern;

  /// Úseky pro jednotlivé dny podle počtu kapitol daného překladu.
  List<List<VerseRef>> schedule(Map<int, int> counts) {
    if (dailyPattern case final p?) return p(counts);
    final chapters = [
      for (final b in books)
        for (var c = 1; c <= (counts[b] ?? 0); c++) VerseRef(b, c),
    ];
    final result = <List<VerseRef>>[];
    for (var d = 0; d < days; d++) {
      final from = (chapters.length * d / days).round();
      final to = (chapters.length * (d + 1) / days).round();
      result.add(chapters.sublist(from, to));
    }
    return result;
  }
}

List<int> _range(int a, int b) => [for (var i = a; i <= b; i++) i];

/// Kapitoly knih [books] rozdělené rovnoměrně do [days] dní.
List<List<VerseRef>> _spread(List<int> books, int days, Map<int, int> counts) {
  final chapters = [
    for (final b in books)
      for (var c = 1; c <= (counts[b] ?? 0); c++) VerseRef(b, c),
  ];
  return [
    for (var d = 0; d < days; d++)
      chapters.sublist(
        (chapters.length * d / days).round(),
        (chapters.length * (d + 1) / days).round(),
      ),
  ];
}

/// Klíčové kapitoly celého biblického příběhu (číslování kapitol je
/// v českých překladech shodné).
const _keyChapters = [
  (1, 1), (1, 3), (1, 6), (1, 12), (1, 22), (1, 37), (1, 45), //
  (2, 3), (2, 12), (2, 14), (2, 20), (4, 14), (5, 6), //
  (6, 1), (6, 6), (7, 2), (8, 1), //
  (9, 3), (9, 16), (9, 17), (10, 7), (10, 11), (11, 3), (11, 18), //
  (12, 17), (12, 25), (19, 23), (19, 51), (23, 53), (24, 31), //
  (27, 6), (32, 3), (15, 1), (16, 8), //
  (42, 1), (42, 2), (40, 5), (43, 3), (42, 15), (43, 11), //
  (43, 19), (42, 24), (44, 2), (44, 9), (45, 8), (46, 13), //
  (49, 2), (50, 2), (58, 11), (66, 21),
];

final readingPlans = [
  ReadingPlan(
    id: 'nt90',
    name: 'Nový zákon za 90 dní',
    description: 'Celý Nový zákon – asi 3 kapitoly denně, 15 minut.',
    days: 90,
    books: _range(40, 66),
  ),
  ReadingPlan(
    id: 'gospels40',
    name: 'Evangelia za 40 dní',
    description: 'Ježíšův život očima Matouše, Marka, Lukáše a Jana.',
    days: 40,
    books: _range(40, 43),
  ),
  ReadingPlan(
    id: 'psalms31',
    name: 'Žalmy a Přísloví za měsíc',
    description: 'Každý den 5 žalmů a 1 kapitola Přísloví.',
    days: 31,
    books: const [19, 20],
    dailyPattern: (counts) => [
      for (var d = 0; d < 31; d++)
        [
          for (
            var p = d * 5 + 1;
            p <= d * 5 + 5 && p <= (counts[19] ?? 150);
            p++
          )
            VerseRef(19, p),
          if (d < (counts[20] ?? 31)) VerseRef(20, d + 1),
        ],
    ],
  ),
  ReadingPlan(
    id: 'bible365',
    name: 'Celá Bible za rok',
    description: 'Od Genesis po Zjevení – asi 3–4 kapitoly denně.',
    days: 365,
    books: _range(1, 66),
  ),
  ReadingPlan(
    id: 'both365',
    name: 'Celá Bible za rok – SZ i NZ souběžně',
    description:
        'Každý den kousek Starého a kousek Nového zákona – pestřejší než '
        'čtení od začátku do konce.',
    days: 365,
    books: _range(1, 66),
    dailyPattern: (counts) {
      final ot = _spread(_range(1, 39), 365, counts);
      final nt = _spread(_range(40, 66), 365, counts);
      return [
        for (var d = 0; d < 365; d++) [...ot[d], ...nt[d]],
      ];
    },
  ),
  ReadingPlan(
    id: 'story50',
    name: 'Bible v kostce (50 dní)',
    description:
        'Každý den jedna klíčová kapitola – od stvoření přes Abrahama, '
        'Mojžíše, Davida a proroky až k Ježíši, církvi a novému stvoření.',
    days: 50,
    books: const [],
    dailyPattern: (_) => [
      for (final (b, c) in _keyChapters) [VerseRef(b, c)],
    ],
  ),
  ReadingPlan(
    id: 'paul30',
    name: 'Pavlovy listy za 30 dní',
    description: 'Od listu Římanům po Filemona – asi 3 kapitoly denně.',
    days: 30,
    books: _range(45, 57),
  ),
  ReadingPlan(
    id: 'start14',
    name: 'Začínám s Biblí (14 dní)',
    description: 'Lukášovo evangelium – ideální první čtení.',
    days: 14,
    books: const [42],
  ),
];

/// Plán podle id: vestavěný, nebo vlastní (`custom:<dní>:<kniha,kniha…>`).
ReadingPlan? planById(String id) {
  for (final p in readingPlans) {
    if (p.id == id) return p;
  }
  return customPlan(id);
}

/// Id vlastního plánu z vybraných knih a počtu dní.
String customPlanId(List<int> books, int days) =>
    'custom:$days:${books.join(',')}';

ReadingPlan? customPlan(String id) {
  final parts = id.split(':');
  if (parts.length != 3 || parts[0] != 'custom') return null;
  final days = int.tryParse(parts[1]);
  final books = [
    for (final b in parts[2].split(','))
      if (int.tryParse(b) case final n? when n >= 1 && n <= 66) n,
  ];
  if (days == null || days < 1 || books.isEmpty) return null;
  return ReadingPlan(
    id: id,
    name: 'Vlastní plán',
    description: books.length == 1
        ? 'Jedna kniha'
        : '${books.length} knih podle vašeho výběru',
    days: days,
    books: books,
  );
}

// --- Verš dne ----------------------------------------------------------------------

/// Pečlivě vybrané verše (číslování platí shodně pro české překlady).
const _versesOfDay = [
  (43, 3, 16),
  (19, 23, 1),
  (20, 3, 5),
  (50, 4, 13),
  (24, 29, 11),
  (45, 8, 28),
  (23, 40, 31),
  (6, 1, 9),
  (40, 11, 28),
  (45, 12, 2),
  (48, 5, 22),
  (62, 4, 8),
  (43, 14, 6),
  (49, 2, 8),
  (40, 6, 33),
  (58, 11, 1),
  (46, 13, 4),
  (19, 119, 105),
  (43, 11, 25),
  (33, 6, 8),
  (60, 5, 7),
  (45, 5, 8),
  (47, 5, 17),
  (43, 8, 12),
  (59, 1, 5),
  (25, 3, 22),
  (43, 15, 5),
  (40, 5, 9),
  (51, 3, 23),
  (55, 1, 7),
  (19, 37, 4),
  (23, 41, 10),
  (45, 15, 13),
  (40, 7, 7),
  (43, 16, 33),
  (58, 4, 16),
  (50, 4, 6),
  (40, 22, 37),
  (45, 10, 9),
  (47, 12, 9),
  (62, 1, 9),
  (43, 10, 10),
  (40, 28, 20),
  (49, 4, 32),
  (43, 13, 34),
  (5, 31, 6),
  (23, 26, 3),
  (19, 121, 2),
  (45, 12, 12),
  (52, 5, 16),
  (35, 3, 18),
  (43, 1, 1),
  (45, 3, 23),
  (40, 5, 14),
  (66, 21, 4),
  (58, 12, 2),
  (43, 6, 35),
  (50, 4, 7),
  (47, 4, 18),
  (59, 1, 22),
  (21, 3, 1),
  (43, 1, 14),
  (49, 6, 10),
  (60, 2, 9),
  (45, 8, 1),
  (40, 18, 20),
  (23, 43, 1),
  (19, 103, 2),
  (43, 20, 29),
  (48, 2, 20),
  (20, 16, 9),
  (42, 1, 37),
  (45, 6, 23),
  (58, 13, 8),
  (62, 3, 1),
  (24, 31, 3),
  (40, 16, 26),
  (50, 1, 6),
  (55, 3, 16),
  (20, 4, 23),
  (43, 4, 24),
  (42, 6, 31),
  (46, 10, 13),
  (45, 13, 10),
  (43, 14, 27),
  (23, 53, 5),
  (42, 19, 10),
  (54, 4, 12),
  (60, 3, 15),
  (49, 3, 20),
  (41, 10, 45),
  (43, 21, 17),
  (66, 3, 20),
  (19, 139, 14),
  (18, 19, 25),
];

/// Verš dne – stejný po celý den, každý den jiný.
VerseRef verseOfDay(DateTime date) {
  final start = DateTime(date.year);
  final dayOfYear = DateTime(
    date.year,
    date.month,
    date.day,
  ).difference(start).inDays;
  final (b, c, v) =
      _versesOfDay[(dayOfYear + date.year * 7) % _versesOfDay.length];
  return VerseRef(b, c, v);
}
