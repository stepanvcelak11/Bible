import 'package:drift/drift.dart';

import '../../domain/entities/bible_entities.dart';
import '../../domain/entities/user_entities.dart';
import '../../domain/repositories/user_data_repository.dart';
import '../../domain/services/versification.dart';
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

  // --- Záloha -------------------------------------------------------------

  static const _backupApp = 'bible_reader';

  /// 2 = odkazy v kanonickém (hebrejském) číslování; zálohy verze 1
  /// vznikly v Kralické (anglické číslování) a při obnově se převedou.
  static const _backupFormat = 2;

  @override
  Future<Map<String, Object?>> exportBackup() async {
    final (highlights, bookmarks, notes, readings) = await (
      _db.select(_db.highlights).get(),
      _db.select(_db.bookmarks).get(),
      _db.select(_db.notes).get(),
      _db.select(_db.readingLog).get(),
    ).wait;
    return {
      'app': _backupApp,
      'format': _backupFormat,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'highlights': [
        for (final h in highlights)
          {
            'ref': VerseRef(h.bookId, h.chapter, h.verse).encode(),
            'color': h.color.name,
            'createdAt': h.createdAt.toUtc().toIso8601String(),
          },
      ],
      'bookmarks': [
        for (final b in bookmarks)
          {
            'ref': VerseRef(b.bookId, b.chapter, b.verse).encode(),
            'translationId': b.translationId,
            'label': b.label,
            'createdAt': b.createdAt.toUtc().toIso8601String(),
          },
      ],
      'notes': [
        for (final n in notes)
          {
            'ref': VerseRef(n.bookId, n.chapter, n.verseStart).encode(),
            'verseEnd': n.verseEnd,
            'body': n.body,
            'createdAt': n.createdAt.toUtc().toIso8601String(),
            'updatedAt': n.updatedAt.toUtc().toIso8601String(),
          },
      ],
      // Přečtené kapitoly (i ručně označené – ty mají datum 1970-01-01).
      'readingLog': [
        for (final r in readings)
          {
            'book': r.bookId,
            'chapter': r.chapter,
            'translationId': r.translationId,
            'readAt': r.readAt.toUtc().toIso8601String(),
          },
      ],
    };
  }

  /// Konec rozsahu poznámky; u starých záloh převedený stejně jako
  /// začátek ([raw] = začátek v původním číslování).
  static int _noteEnd(VerseRef raw, int? end, {required bool legacy}) {
    if (!legacy) return end ?? raw.verse;
    VerseRef convert(VerseRef r) =>
        Versification.convert(r, VerseScheme.english, VerseScheme.hebrew);
    final start = convert(raw);
    final e = convert(raw.copyWith(verse: end ?? raw.verse));
    return e.chapter == start.chapter && e.verse >= start.verse
        ? e.verse
        : start.verse;
  }

  @override
  Future<BackupImportResult> importBackup(Map<String, Object?> json) async {
    // 1) Nejdřív celé ověřit a převést – při chybě se nic nezapíše.
    if (json['app'] != _backupApp) {
      throw const InvalidBackupException('Soubor není záloha této aplikace.');
    }
    final format = json['format'];
    if (format is! int || format > _backupFormat) {
      throw const InvalidBackupException('Nepodporovaná verze zálohy.');
    }

    List<Map<String, Object?>> list(String key) {
      final value = json[key] ?? const <Object?>[];
      if (value is! List) throw InvalidBackupException('Chybný seznam $key.');
      return [
        for (final item in value)
          if (item is Map<String, Object?>)
            item
          else
            throw InvalidBackupException('Chybná položka v $key.'),
      ];
    }

    final legacy = format < 2;
    VerseRef raw(Map<String, Object?> item) =>
        VerseRef.tryDecode(item['ref'] as String?) ??
        (throw InvalidBackupException('Neplatný odkaz ${item['ref']}.'));
    VerseRef convert(VerseRef r) =>
        Versification.convert(r, VerseScheme.english, VerseScheme.hebrew);
    VerseRef ref(Map<String, Object?> item) {
      final translationId = item['translationId'] as String?;
      return legacy && (translationId == null || translationId == 'BKR')
          ? convert(raw(item))
          : raw(item);
    }

    DateTime date(Object? value) =>
        DateTime.tryParse(value as String? ?? '') ?? DateTime.now();

    final colors = HighlightColor.values.asNameMap();
    final highlights = [
      for (final h in list('highlights'))
        (
          ref(h),
          colors[h['color']] ??
              (throw InvalidBackupException('Neznámá barva ${h['color']}.')),
          date(h['createdAt']),
        ),
    ];
    final bookmarks = [
      for (final b in list('bookmarks'))
        (
          ref(b),
          b['translationId'] as String?,
          b['label'] as String?,
          date(b['createdAt']),
        ),
    ];
    final notes = [
      for (final n in list('notes'))
        (
          ref(n),
          _noteEnd(raw(n), n['verseEnd'] as int?, legacy: legacy),
          (n['body'] as String?) ??
              (throw const InvalidBackupException('Poznámka bez textu.')),
          date(n['createdAt']),
          date(n['updatedAt']),
        ),
    ];

    final readings = [
      for (final r in list('readingLog'))
        if ((r['book'], r['chapter']) case (final int b, final int c)
            when b >= 1 && b <= 66 && c >= 1)
          (b, c, r['translationId'] as String?, date(r['readAt']))
        else
          throw const InvalidBackupException('Chybný záznam čtení.'),
    ];

    // 2) Zapsat v jedné transakci.
    return _db.transaction(() async {
      for (final (r, color, created) in highlights) {
        await _db
            .into(_db.highlights)
            .insert(
              db.HighlightsCompanion.insert(
                bookId: r.bookId,
                chapter: r.chapter,
                verse: r.verse,
                color: color,
                createdAt: Value(created),
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
      for (final (r, translationId, label, created) in bookmarks) {
        await _db
            .into(_db.bookmarks)
            .insert(
              db.BookmarksCompanion.insert(
                bookId: r.bookId,
                chapter: r.chapter,
                verse: r.verse,
                translationId: Value(translationId),
                label: Value(label),
                createdAt: Value(created),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
      var addedNotes = 0;
      for (final (r, end, body, created, updated) in notes) {
        final exists =
            await (_db.select(_db.notes)..where(
                  (n) =>
                      n.bookId.equals(r.bookId) &
                      n.chapter.equals(r.chapter) &
                      n.verseStart.equals(r.verse) &
                      n.body.equals(body),
                ))
                .getSingleOrNull();
        if (exists != null) continue;
        await _db
            .into(_db.notes)
            .insert(
              db.NotesCompanion.insert(
                bookId: r.bookId,
                chapter: r.chapter,
                verseStart: r.verse,
                verseEnd: end < r.verse ? r.verse : end,
                body: body,
                createdAt: Value(created),
                updatedAt: Value(updated),
              ),
            );
        addedNotes++;
      }
      var addedReadings = 0;
      for (final (b, c, translationId, at) in readings) {
        final exists =
            await (_db.select(_db.readingLog)
                  ..where(
                    (r) =>
                        r.bookId.equals(b) &
                        r.chapter.equals(c) &
                        r.readAt.equals(at),
                  )
                  ..limit(1))
                .getSingleOrNull();
        if (exists != null) continue;
        await _db
            .into(_db.readingLog)
            .insert(
              db.ReadingLogCompanion.insert(
                bookId: b,
                chapter: c,
                translationId: Value(translationId),
                readAt: Value(at),
              ),
            );
        addedReadings++;
      }
      return BackupImportResult(
        highlights: highlights.length,
        bookmarks: bookmarks.length,
        notes: addedNotes,
        readings: addedReadings,
      );
    });
  }

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
