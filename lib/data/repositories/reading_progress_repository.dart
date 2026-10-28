import 'package:drift/drift.dart';

import '../../domain/entities/bible_entities.dart';
import '../user/user_database.dart';

/// Statistiky čtení pro obrazovku „Dnes“.
class ReadingStats {
  const ReadingStats({
    required this.streakDays,
    required this.chaptersThisWeek,
    required this.chaptersTotal,
    required this.readToday,
  });

  /// Kolik dní v řadě (včetně dneška, nebo včerejška, pokud se dnes ještě
  /// nečetlo) uživatel četl.
  final int streakDays;
  final int chaptersThisWeek;

  /// Počet různých přečtených kapitol celkem.
  final int chaptersTotal;
  final bool readToday;

  static const empty = ReadingStats(
    streakDays: 0,
    chaptersThisWeek: 0,
    chaptersTotal: 0,
    readToday: false,
  );
}

/// Záznamy o přečtených kapitolách (tabulka `reading_log` v user.db).
class ReadingProgressRepository {
  ReadingProgressRepository(this._db);

  final UserDatabase _db;

  /// Zaznamená přečtení kapitoly (nejvýš jednou za den pro stejnou kapitolu).
  Future<void> logChapter(
    int bookId,
    int chapter, {
    String? translationId,
  }) async {
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final existing =
        await (_db.select(_db.readingLog)
              ..where(
                (r) =>
                    r.bookId.equals(bookId) &
                    r.chapter.equals(chapter) &
                    r.readAt.isBiggerOrEqualValue(dayStart),
              )
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) return;
    await _db
        .into(_db.readingLog)
        .insert(
          ReadingLogCompanion.insert(
            bookId: bookId,
            chapter: chapter,
            translationId: Value(translationId),
          ),
        );
  }

  /// Datum ručně označených kapitol („přečteno dříve, mimo aplikaci“).
  /// Takové záznamy se počítají do přečtené Bible, ale ne do kalendáře
  /// ani série dní.
  static final manualDate = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

  /// Ručně označí kapitoly jako přečtené (již přečtené přeskočí).
  Future<void> markRead(int bookId, Iterable<int> chapters) =>
      _db.transaction(() async {
        final existing = {
          for (final r in await (_db.select(
            _db.readingLog,
          )..where((r) => r.bookId.equals(bookId))).get())
            r.chapter,
        };
        for (final c in chapters) {
          if (existing.contains(c)) continue;
          await _db
              .into(_db.readingLog)
              .insert(
                ReadingLogCompanion.insert(
                  bookId: bookId,
                  chapter: c,
                  readAt: Value(manualDate),
                ),
              );
        }
      });

  /// Zruší záznamy o přečtení kapitol (ruční i ze čtení v aplikaci).
  Future<void> markUnread(int bookId, Iterable<int> chapters) =>
      (_db.delete(_db.readingLog)..where(
            (r) => r.bookId.equals(bookId) & r.chapter.isIn(chapters.toList()),
          ))
          .go();

  /// Všechny kapitoly, které byly někdy přečteny (`bookId → kapitoly`).
  Stream<Map<int, Set<int>>> watchReadChapters() {
    return _db
        .customSelect(
          'SELECT DISTINCT book_id, chapter FROM reading_log',
          readsFrom: {_db.readingLog},
        )
        .watch()
        .map((rows) {
          final map = <int, Set<int>>{};
          for (final r in rows) {
            (map[r.read<int>('book_id')] ??= {}).add(r.read<int>('chapter'));
          }
          return map;
        });
  }

  /// Naposledy čtené kapitoly (bez opakování), nejnovější první.
  Stream<List<(VerseRef, DateTime)>> watchRecent({int limit = 6}) {
    return _db
        .customSelect(
          'SELECT book_id, chapter, MAX(read_at) AS last FROM reading_log '
          'WHERE read_at > 0 GROUP BY book_id, chapter ORDER BY last DESC '
          'LIMIT ?',
          variables: [Variable.withInt(limit)],
          readsFrom: {_db.readingLog},
        )
        .watch()
        .map(
          (rows) => [
            for (final r in rows)
              (
                VerseRef(r.read<int>('book_id'), r.read<int>('chapter')),
                DateTime.fromMillisecondsSinceEpoch(r.read<int>('last') * 1000),
              ),
          ],
        );
  }

  /// Kolik různých kapitol bylo přečteno v jednotlivých dnech.
  Stream<Map<DateTime, int>> watchDailyCounts() {
    return _db
        .customSelect(
          'SELECT book_id, chapter, read_at FROM reading_log',
          readsFrom: {_db.readingLog},
        )
        .watch()
        .map((rows) {
          final perDay = <DateTime, Set<(int, int)>>{};
          for (final r in rows) {
            if (r.read<int>('read_at') <= 0) continue; // ruční označení
            final at = DateTime.fromMillisecondsSinceEpoch(
              r.read<int>('read_at') * 1000,
            );
            (perDay[DateTime(at.year, at.month, at.day)] ??= {}).add((
              r.read<int>('book_id'),
              r.read<int>('chapter'),
            ));
          }
          return {for (final e in perDay.entries) e.key: e.value.length};
        });
  }

  Stream<ReadingStats> watchStats() {
    return _db
        .customSelect(
          'SELECT book_id, chapter, read_at FROM reading_log',
          readsFrom: {_db.readingLog},
        )
        .watch()
        .map((rows) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final weekStart = today.subtract(Duration(days: today.weekday - 1));
          final days = <DateTime>{};
          final distinct = <(int, int)>{};
          final thisWeek = <(int, int, DateTime)>{};
          for (final r in rows) {
            final at = DateTime.fromMillisecondsSinceEpoch(
              r.read<int>('read_at') * 1000,
            );
            final key = (r.read<int>('book_id'), r.read<int>('chapter'));
            distinct.add(key);
            if (r.read<int>('read_at') <= 0) continue; // ruční označení
            final day = DateTime(at.year, at.month, at.day);
            days.add(day);
            if (!day.isBefore(weekStart)) thisWeek.add((key.$1, key.$2, day));
          }
          var streak = 0;
          var cursor = days.contains(today)
              ? today
              : today.subtract(const Duration(days: 1));
          while (days.contains(cursor)) {
            streak++;
            cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
          }
          return ReadingStats(
            streakDays: streak,
            chaptersThisWeek: thisWeek.length,
            chaptersTotal: distinct.length,
            readToday: days.contains(today),
          );
        });
  }
}
