import 'package:drift/drift.dart';

import '../../core/utils/fts_query.dart';
import '../../domain/entities/bible_entities.dart';
import '../../domain/repositories/bible_repository.dart';
import '../bible/bible_database.dart' as db;

/// Implementace [BibleRepository] nad lokální SQLite (Drift).
///
/// Překlady a knihy se mění jen s novou verzí aplikace, proto se po prvním
/// načtení drží v paměti. Kapitoly se čtou vždy z databáze – jeden dotaz
/// přes index `verses_by_ref` trvá jednotky milisekund.
class BibleRepositoryImpl implements BibleRepository {
  BibleRepositoryImpl(this._db);

  final db.BibleDatabase _db;

  List<Translation>? _translations;
  List<Book>? _books;
  final Map<String, Map<int, int>> _chapterCounts = {};

  @override
  Future<List<Translation>> getTranslations() async {
    return _translations ??=
        await (_db.select(_db.translations)
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .map(
              (row) => Translation(
                id: row.id,
                name: row.name,
                abbreviation: row.abbreviation,
                year: row.year,
                license: row.license,
                description: row.description,
              ),
            )
            .get();
  }

  @override
  Future<List<Book>> getBooks() async {
    return _books ??=
        await (_db.select(_db.books)..orderBy([(b) => OrderingTerm.asc(b.id)]))
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

    // MAX místo COUNT: navigace podle čísla kapitoly funguje i tehdy, když
    // zdroj nějakou kapitolu vynechá.
    final count = _db.chapters.chapter.max();
    final rows =
        await (_db.selectOnly(_db.chapters)
              ..addColumns([_db.chapters.bookId, count])
              ..where(_db.chapters.translationId.equals(translationId))
              ..groupBy([_db.chapters.bookId]))
            .get();
    return _chapterCounts[translationId] = {
      for (final row in rows) row.read(_db.chapters.bookId)!: row.read(count)!,
    };
  }

  @override
  Future<List<Verse>> getChapter(
    String translationId,
    int bookId,
    int chapter,
  ) {
    final query = _db.select(_db.verses)
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
  Future<Verse?> getVerse(String translationId, VerseRef ref) {
    final query = _db.select(_db.verses)
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
    final (primary, secondary) = await (
      getChapter(primaryId, bookId, chapter),
      getChapter(secondaryId, bookId, chapter),
    ).wait;
    return alignVerses(primary, secondary);
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

  @override
  Future<List<SearchHit>> search(
    String query, {
    Set<String>? translationIds,
    Testament? testament,
    int limit = 200,
  }) async {
    final match = buildFtsQuery(query);
    if (match == null) return const [];
    if (translationIds != null && translationIds.isEmpty) return const [];

    final ids = translationIds?.toList();
    final filters = [
      if (ids != null)
        'AND v.translation_id IN (${List.filled(ids.length, '?').join(', ')})',
      // Starý zákon = knihy 1–39, Nový zákon = 40–66.
      if (testament == Testament.oldTestament) 'AND v.book_id <= 39',
      if (testament == Testament.newTestament) 'AND v.book_id >= 40',
    ].join(' ');

    // highlight() vrátí celý verš se shodami ohraničenými řídicími znaky
    // \u0002 … \u0003 (v textu Bible se nevyskytují).
    final rows = await _db
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
            if (ids != null) ...ids.map(Variable.withString),
            Variable.withInt(limit),
          ],
          readsFrom: {_db.verses, _db.versesFts},
        )
        .get();

    return [
      for (final row in rows)
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
    ];
  }

  static Verse _toVerse(db.Verse row) => Verse(
    translationId: row.translationId,
    ref: VerseRef(row.bookId, row.chapter, row.verse),
    // Drift přejmenuje sloupec `text` na `text$` (kolize s funkcí text()).
    text: row.text$,
  );
}
