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
          'GROUP BY book_id, chapter ORDER BY last DESC LIMIT ?',
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
            final day = DateTime(at.year, at.month, at.day);
            days.add(day);
            final key = (r.read<int>('book_id'), r.read<int>('chapter'));
            distinct.add(key);
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
