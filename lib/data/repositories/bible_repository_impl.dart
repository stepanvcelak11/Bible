import 'package:drift/drift.dart';

import '../../core/utils/fts_query.dart';
import '../../domain/entities/bible_entities.dart';
import '../../domain/repositories/bible_repository.dart';
import '../../domain/services/versification.dart';
import '../bible/bible_database.dart' as db;

/// Implementace [BibleRepository] nad lokální SQLite (Drift).
///
/// Pracuje se dvěma databázemi stejného schématu:
///  * přibalenou (`bible.db`, jen pro čtení),
///  * staženými překlady (`downloads`, zapisuje `TranslationInstaller`).
/// Každý překlad leží právě v jedné z nich; dotazy se směrují podle id.
///
/// Překlady a knihy se drží v paměti (po stažení/odstranění překladu se
/// cache zahodí přes [invalidate]). Kapitoly se čtou vždy z databáze – jeden
/// dotaz přes index `verses_by_ref` trvá jednotky milisekund.
class BibleRepositoryImpl implements BibleRepository {
  BibleRepositoryImpl(this._bundled, [this._downloads]);

  final db.BibleDatabase _bundled;
  final db.BibleDatabase? _downloads;

  List<Translation>? _translations;
  final Map<String, db.BibleDatabase> _owner = {};
  List<Book>? _books;
  final Map<String, Map<int, int>> _chapterCounts = {};

  Iterable<db.BibleDatabase> get _databases => [_bundled, ?_downloads];

  db.BibleDatabase _dbFor(String translationId) =>
      _owner[translationId] ?? _bundled;

  @override
  void invalidate() {
    _translations = null;
    _owner.clear();
    _chapterCounts.clear();
  }

  @override
  Future<List<Translation>> getTranslations() async {
    final cached = _translations;
    if (cached != null) return cached;
    final result = <Translation>[];
    for (final database in _databases) {
      final rows = await (database.select(
        database.translations,
      )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
      for (final row in rows) {
        // Překlad přibalený i stažený zároveň → přednost má přibalený.
        if (_owner.containsKey(row.id)) continue;
        _owner[row.id] = database;
        result.add(
          Translation(
            id: row.id,
            name: row.name,
            abbreviation: row.abbreviation,
            year: row.year,
            license: row.license,
            description: row.description,
            downloaded: database.downloads,
          ),
        );
      }
    }
    return _translations = result;
  }

  @override
  Future<List<Book>> getBooks() async {
    return _books ??=
        await (_bundled.select(_bundled.books)
              ..orderBy([(b) => OrderingTerm.asc(b.id)]))
            .map(
              (row) => Book(
                id: row.id,
                osis: row.osis,
                name: row.name,
                abbreviation: row.abbreviation,
                testament: Testament.fromCode(row.testament),
              ),
            )
            .get();
  }

  @override
  Future<Map<int, int>> getChapterCounts(String translationId) async {
    final cached = _chapterCounts[translationId];
    if (cached != null) return cached;
    await getTranslations();
    final d = _dbFor(translationId);

    // MAX místo COUNT: navigace podle čísla kapitoly funguje i tehdy, když
    // zdroj nějakou kapitolu vynechá.
    final count = d.chapters.chapter.max();
    final rows =
        await (d.selectOnly(d.chapters)
              ..addColumns([d.chapters.bookId, count])
              ..where(d.chapters.translationId.equals(translationId))
              ..groupBy([d.chapters.bookId]))
            .get();
    return _chapterCounts[translationId] = {
      for (final row in rows) row.read(d.chapters.bookId)!: row.read(count)!,
    };
  }

  @override
  Future<List<Verse>> getChapter(
    String translationId,
    int bookId,
    int chapter,
  ) async {
    await getTranslations();
    final d = _dbFor(translationId);
    final query = d.select(d.verses)
      ..where(
        (v) =>
            v.translationId.equals(translationId) &
            v.bookId.equals(bookId) &
            v.chapter.equals(chapter),
      )
      ..orderBy([(v) => OrderingTerm.asc(v.verse)]);
    return query.map(_toVerse).get();
  }

  @override
  Future<ChapterText> getChapterText(
    String translationId,
    int bookId,
    int chapter,
  ) async {
    await getTranslations();
    final d = _dbFor(translationId);

    Future<Map<int, List<String>>> notes(String table) async {
      final rows = await d
          .customSelect(
            'SELECT verse, text FROM $table WHERE translation_id = ? '
            'AND book_id = ? AND chapter = ? ORDER BY verse, ord',
            variables: [
              Variable.withString(translationId),
              Variable.withInt(bookId),
              Variable.withInt(chapter),
            ],
          )
          .get();
      final map = <int, List<String>>{};
      for (final r in rows) {
        (map[r.read<int>('verse')] ??= []).add(r.read<String>('text'));
      }
      return map;
    }

    final (verses, headings, footnotes) = await (
      getChapter(translationId, bookId, chapter),
      notes('headings'),
      notes('footnotes'),
    ).wait;
    return ChapterText(
      verses: verses,
      headings: headings,
      footnotes: footnotes,
    );
  }

  @override
  Future<Verse?> getVerse(String translationId, VerseRef ref) async {
    await getTranslations();
    final d = _dbFor(translationId);
    final query = d.select(d.verses)
      ..where(
        (v) =>
            v.translationId.equals(translationId) &
            v.bookId.equals(ref.bookId) &
            v.chapter.equals(ref.chapter) &
            v.verse.equals(ref.verse),
      );
    return query.map(_toVerse).getSingleOrNull();
  }

  @override
  Future<List<ParallelVerse>> getParallelChapter(
    String primaryId,
    String secondaryId,
    int bookId,
    int chapter,
  ) async {
    final from = schemeOf(secondaryId);
    final to = schemeOf(primaryId);
    if (from == to) {
      final (primary, secondary) = await (
        getChapter(primaryId, bookId, chapter),
        getChapter(secondaryId, bookId, chapter),
      ).wait;
      return alignVerses(primary, secondary);
    }
    // Různé číslování: verše druhého překladu se přiřadí podle obsahu
    // (převodní tabulka), ne podle čísla.
    final primary = await getChapter(primaryId, bookId, chapter);
    final lastVerse = primary.isEmpty ? 1 : primary.last.number;
    final chapters = {
      chapter,
      ...Versification.chaptersSpanned(bookId, chapter, lastVerse, to, from),
    }.toList()..sort();
    final secondary = [
      for (final c in chapters) ...await getChapter(secondaryId, bookId, c),
    ];
    return alignByScheme(primary, secondary, chapter, from, to);
  }

  /// Zarovnání překladů s různým číslováním: každý verš druhého překladu
  /// se převede do číslování hlavního a připojí k odpovídajícímu verši.
  static List<ParallelVerse> alignByScheme(
    List<Verse> primary,
    List<Verse> secondary,
    int chapter,
    VerseScheme from,
    VerseScheme to,
  ) {
    final groups = <int, List<Verse>>{};
    for (final v in secondary) {
      final mapped = Versification.convert(v.ref, from, to);
      if (mapped.chapter == chapter) (groups[mapped.verse] ??= []).add(v);
    }
    final byNumber = {for (final v in primary) v.number: v};
    final numbers = {...byNumber.keys, ...groups.keys}.toList()..sort();
    return [
      for (final n in numbers)
        ParallelVerse(
          number: n,
          primary: byNumber[n],
          secondary: _merge(groups[n]),
          secondaryLabel: _label(groups[n], chapter, n),
        ),
    ];
  }

  static Verse? _merge(List<Verse>? verses) {
    if (verses == null || verses.isEmpty) return null;
    if (verses.length == 1) return verses.single;
    final first = verses.first;
    return Verse(
      translationId: first.translationId,
      ref: first.ref,
      text: verses.map((v) => v.text).join(' '),
      paragraph: first.paragraph,
      poetry: verses.any((v) => v.poetry),
    );
  }

  static String? _label(List<Verse>? verses, int chapter, int number) {
    if (verses == null || verses.isEmpty) return null;
    final a = verses.first.ref, b = verses.last.ref;
    if (verses.length == 1 && a.chapter == chapter && a.verse == number) {
      return null;
    }
    final prefix = a.chapter == chapter ? '' : '${a.chapter}:';
    if (a == b) return '$prefix${a.verse}';
    final end = b.chapter == a.chapter
        ? '${b.verse}'
        : '${b.chapter}:${b.verse}';
    return '$prefix${a.verse}–$end';
  }

  /// Zarovná dva seznamy veršů podle čísla verše (sloučení dvou
  /// seřazených seznamů v O(n)). Chybějící verš jedné strany zůstane `null`.
  static List<ParallelVerse> alignVerses(
    List<Verse> primary,
    List<Verse> secondary,
  ) {
    final result = <ParallelVerse>[];
    var i = 0, j = 0;
    while (i < primary.length || j < secondary.length) {
      final a = i < primary.length ? primary[i] : null;
      final b = j < secondary.length ? secondary[j] : null;
      if (b == null || (a != null && a.number < b.number)) {
        result.add(ParallelVerse(number: a!.number, primary: a));
        i++;
      } else if (a == null || b.number < a.number) {
        result.add(ParallelVerse(number: b.number, secondary: b));
        j++;
      } else {
        result.add(ParallelVerse(number: a.number, primary: a, secondary: b));
        i++;
        j++;
      }
    }
    return result;
  }

  /// Překlady rozdělené podle databáze, ve které leží.
  Future<Map<db.BibleDatabase, List<String>>> _group(
    Set<String>? translationIds,
  ) async {
    final all = await getTranslations();
    final ids = translationIds ?? {for (final t in all) t.id};
    final groups = <db.BibleDatabase, List<String>>{};
    for (final id in ids) {
      if (!_owner.containsKey(id)) continue;
      (groups[_owner[id]!] ??= []).add(id);
    }
    return groups;
  }

  static (String, List<Variable<Object>>) _filters(
    List<String> ids,
    Testament? testament,
    int? bookId,
  ) {
    final sql = [
      'AND v.translation_id IN (${List.filled(ids.length, '?').join(', ')})',
      // Starý zákon = knihy 1–39, Nový zákon = 40–66.
      if (testament == Testament.oldTestament) 'AND v.book_id <= 39',
      if (testament == Testament.newTestament) 'AND v.book_id >= 40',
      if (bookId != null) 'AND v.book_id = ?',
    ].join(' ');
    return (
      sql,
      [
        ...ids.map(Variable.withString),
        if (bookId != null) Variable.withInt(bookId),
      ],
    );
  }

  @override
  Future<List<SearchHit>> search(
    String query, {
    Set<String>? translationIds,
    Testament? testament,
    int? bookId,
    int limit = 200,
    int offset = 0,
  }) async {
    final match = buildFtsQuery(query);
    if (match == null) return const [];
    final groups = await _group(translationIds);
    final hits = <SearchHit>[];

    for (final MapEntry(key: d, value: ids) in groups.entries) {
      final (filters, vars) = _filters(ids, testament, bookId);
      // highlight() vrátí celý verš se shodami ohraničenými řídicími znaky
      // \u0002 … \u0003 (v textu Bible se nevyskytují).
      final rows = await d
          .customSelect(
            '''
            SELECT v.translation_id, v.book_id, v.chapter, v.verse, v.text,
                   highlight(verses_fts, 0, char(2), char(3)) AS marked
            FROM verses_fts
            JOIN verses v ON v.id = verses_fts.rowid
            WHERE verses_fts MATCH ? $filters
            ORDER BY v.book_id, v.chapter, v.verse, v.translation_id
            LIMIT ?
            ''',
            variables: [
              Variable.withString(match),
              ...vars,
              Variable.withInt(offset + limit),
            ],
            readsFrom: {d.verses, d.versesFts},
          )
          .get();
      for (final row in rows) {
        hits.add(
          SearchHit(
            verse: Verse(
              translationId: row.read<String>('translation_id'),
              ref: VerseRef(
                row.read<int>('book_id'),
                row.read<int>('chapter'),
                row.read<int>('verse'),
              ),
              text: row.read<String>('text'),
            ),
            snippet: row.read<String>('marked'),
          ),
        );
      }
    }
    // Sloučit výsledky z obou databází v kanonickém pořadí.
    hits.sort((a, b) {
      final c = a.verse.ref.compareTo(b.verse.ref);
      return c != 0
          ? c
          : a.verse.translationId.compareTo(b.verse.translationId);
    });
    return hits.skip(offset).take(limit).toList();
  }

  @override
  Future<List<SearchHit>> searchAny(
    List<String> terms, {
    required String translationId,
    int limit = 150,
  }) async {
    final match = buildFtsAnyQuery(terms);
    if (match == null) return const [];
    final groups = await _group({translationId});
    final hits = <SearchHit>[];
    for (final MapEntry(key: d, value: ids) in groups.entries) {
      final (filters, vars) = _filters(ids, null, null);
      final rows = await d
          .customSelect(
            '''
            SELECT v.translation_id, v.book_id, v.chapter, v.verse, v.text,
                   highlight(verses_fts, 0, char(2), char(3)) AS marked
            FROM verses_fts
            JOIN verses v ON v.id = verses_fts.rowid
            WHERE verses_fts MATCH ? $filters
            ORDER BY rank
            LIMIT ?
            ''',
            variables: [
              Variable.withString(match),
              ...vars,
              Variable.withInt(limit),
            ],
            readsFrom: {d.verses, d.versesFts},
          )
          .get();
      for (final row in rows) {
        hits.add(
          SearchHit(
            verse: Verse(
              translationId: row.read<String>('translation_id'),
              ref: VerseRef(
                row.read<int>('book_id'),
                row.read<int>('chapter'),
                row.read<int>('verse'),
              ),
              text: row.read<String>('text'),
            ),
            snippet: row.read<String>('marked'),
          ),
        );
      }
    }
    return hits;
  }

  @override
  Future<Map<int, int>> searchCounts(
    String query, {
    Set<String>? translationIds,
    Testament? testament,
  }) async {
    final match = buildFtsQuery(query);
    if (match == null) return const {};
    final groups = await _group(translationIds);
    final counts = <int, int>{};
    for (final MapEntry(key: d, value: ids) in groups.entries) {
      final (filters, vars) = _filters(ids, testament, null);
      final rows = await d
          .customSelect(
            '''
            SELECT v.book_id AS book, COUNT(*) AS n
            FROM verses_fts
            JOIN verses v ON v.id = verses_fts.rowid
            WHERE verses_fts MATCH ? $filters
            GROUP BY v.book_id
            ''',
            variables: [Variable.withString(match), ...vars],
            readsFrom: {d.verses, d.versesFts},
          )
          .get();
      for (final r in rows) {
        final book = r.read<int>('book');
        counts[book] = (counts[book] ?? 0) + r.read<int>('n');
      }
    }
    return counts;
  }

  static Verse _toVerse(db.Verse row) => Verse(
    translationId: row.translationId,
    ref: VerseRef(row.bookId, row.chapter, row.verse),
    // Drift přejmenuje sloupec `text` na `text$` (kolize s funkcí text()).
    text: row.text$,
    paragraph: row.paragraph == 1,
    poetry: row.poetry == 1,
  );
}
