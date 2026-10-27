import 'package:drift/drift.dart';

import '../../domain/entities/bible_entities.dart';
import '../../domain/entities/user_entities.dart';
import '../../domain/repositories/user_data_repository.dart';
import '../user/user_database.dart' as db;

/// Implementace [UserDataRepository] nad `user.db` (Drift).
class UserDataRepositoryImpl implements UserDataRepository {
  UserDataRepositoryImpl(this._db);

  final db.UserDatabase _db;

  // --- Zvýraznění ---------------------------------------------------------

  @override
  Stream<List<Highlight>> watchHighlightsInChapter(int bookId, int chapter) =>
      (_db.select(_db.highlights)
            ..where((h) => h.bookId.equals(bookId) & h.chapter.equals(chapter)))
          .map(_toHighlight)
          .watch();

  @override
  Stream<List<Highlight>> watchAllHighlights() =>
      (_db.select(_db.highlights)
            ..orderBy([(h) => OrderingTerm.desc(h.createdAt)]))
          .map(_toHighlight)
          .watch();

  @override
  Future<void> setHighlight(VerseRef ref, HighlightColor? color) async {
    if (color == null) {
      await (_db.delete(
        _db.highlights,
      )..where((h) => _refEquals(h.bookId, h.chapter, h.verse, ref))).go();
      return;
    }
    await _db
        .into(_db.highlights)
        .insert(
          db.HighlightsCompanion.insert(
            bookId: ref.bookId,
            chapter: ref.chapter,
            verse: ref.verse,
            color: color,
          ),
          onConflict: DoUpdate(
            (_) => db.HighlightsCompanion(color: Value(color)),
            target: [
              _db.highlights.bookId,
              _db.highlights.chapter,
              _db.highlights.verse,
            ],
          ),
        );
  }

  // --- Záložky ------------------------------------------------------------

  @override
  Stream<List<Bookmark>> watchBookmarksInChapter(int bookId, int chapter) =>
      (_db.select(_db.bookmarks)
            ..where((b) => b.bookId.equals(bookId) & b.chapter.equals(chapter)))
          .map(_toBookmark)
          .watch();

  @override
  Stream<List<Bookmark>> watchAllBookmarks() => (_db.select(
    _db.bookmarks,
  )..orderBy([(b) => OrderingTerm.desc(b.createdAt)])).map(_toBookmark).watch();

  @override
  Future<bool> toggleBookmark(VerseRef ref, {String? translationId}) {
    return _db.transaction(() async {
      final removed = await (_db.delete(
        _db.bookmarks,
      )..where((b) => _refEquals(b.bookId, b.chapter, b.verse, ref))).go();
      if (removed > 0) return false;
      await _db
          .into(_db.bookmarks)
          .insert(
            db.BookmarksCompanion.insert(
              bookId: ref.bookId,
              chapter: ref.chapter,
              verse: ref.verse,
              translationId: Value(translationId),
            ),
          );
      return true;
    });
  }

  // --- Poznámky -----------------------------------------------------------

  @override
  Stream<List<Note>> watchNotesInChapter(int bookId, int chapter) =>
      (_db.select(_db.notes)
            ..where((n) => n.bookId.equals(bookId) & n.chapter.equals(chapter))
            ..orderBy([(n) => OrderingTerm.asc(n.verseStart)]))
          .map(_toNote)
          .watch();

  @override
  Stream<List<Note>> watchAllNotes() => (_db.select(
    _db.notes,
  )..orderBy([(n) => OrderingTerm.desc(n.updatedAt)])).map(_toNote).watch();

  @override
  Future<int> saveNote({
    int? id,
    required VerseRef ref,
    int? verseEnd,
    required String body,
  }) async {
    final end = verseEnd ?? ref.verse;
    if (id == null) {
      return _db
          .into(_db.notes)
          .insert(
            db.NotesCompanion.insert(
              bookId: ref.bookId,
              chapter: ref.chapter,
              verseStart: ref.verse,
              verseEnd: end,
              body: body,
            ),
          );
    }
    await (_db.update(_db.notes)..where((n) => n.id.equals(id))).write(
      db.NotesCompanion(
        verseStart: Value(ref.verse),
        verseEnd: Value(end),
        body: Value(body),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return id;
  }

  @override
  Future<void> deleteNote(int id) =>
      (_db.delete(_db.notes)..where((n) => n.id.equals(id))).go();

  // --- Mapování -----------------------------------------------------------

  /// Podmínka „řádek odkazuje na verš [ref]“ (Highlights i Bookmarks).
  static Expression<bool> _refEquals(
    GeneratedColumn<int> bookId,
    GeneratedColumn<int> chapter,
    GeneratedColumn<int> verse,
    VerseRef ref,
  ) =>
      bookId.equals(ref.bookId) &
      chapter.equals(ref.chapter) &
      verse.equals(ref.verse);

  static Highlight _toHighlight(db.Highlight row) => Highlight(
    id: row.id,
    ref: VerseRef(row.bookId, row.chapter, row.verse),
    color: row.color,
    createdAt: row.createdAt,
  );

  static Bookmark _toBookmark(db.Bookmark row) => Bookmark(
    id: row.id,
    ref: VerseRef(row.bookId, row.chapter, row.verse),
    translationId: row.translationId,
    label: row.label,
    createdAt: row.createdAt,
  );

  static Note _toNote(db.Note row) => Note(
    id: row.id,
    ref: VerseRef(row.bookId, row.chapter, row.verseStart),
    verseEnd: row.verseEnd,
    body: row.body,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
