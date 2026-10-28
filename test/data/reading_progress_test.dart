import 'package:bible_reader/data/repositories/reading_progress_repository.dart';
import 'package:bible_reader/data/repositories/user_data_repository_impl.dart';
import 'package:bible_reader/data/user/user_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UserDatabase db;
  late ReadingProgressRepository repo;

  setUp(() {
    db = UserDatabase(NativeDatabase.memory());
    repo = ReadingProgressRepository(db);
  });
  tearDown(() => db.close());

  test('ručně označené kapitoly: pokrok ano, kalendář a série ne', () async {
    await repo.logChapter(43, 3); // dnes v aplikaci
    await repo.markRead(40, [1, 2, 3]);
    await repo.markRead(43, [3, 4]); // 3 už je přečtená → přeskočí

    final read = await repo.watchReadChapters().first;
    expect(read[40], {1, 2, 3});
    expect(read[43], {3, 4});

    final stats = await repo.watchStats().first;
    expect(stats.chaptersTotal, 5);
    expect(stats.streakDays, 1);
    expect(stats.chaptersThisWeek, 1);

    final daily = await repo.watchDailyCounts().first;
    expect(daily.values.single, 1);
    final recent = await repo.watchRecent().first;
    expect(recent.single.$1.bookId, 43);

    await repo.markUnread(40, [2, 3]);
    expect((await repo.watchReadChapters().first)[40], {1});
  });

  test('záloha přenese i přečtené kapitoly', () async {
    await repo.markRead(19, [1, 23]);
    await repo.logChapter(43, 3);
    final backup = await UserDataRepositoryImpl(db).exportBackup();

    final other = UserDatabase(NativeDatabase.memory());
    addTearDown(other.close);
    final target = UserDataRepositoryImpl(other);
    final result = await target.importBackup(backup);
    expect(result.readings, 3);
    // Opakovaná obnova nic nezdvojí.
    expect((await target.importBackup(backup)).readings, 0);
    final read = await ReadingProgressRepository(other)
        .watchReadChapters()
        .first;
    expect(read, {
      19: {1, 23},
      43: {3},
    });
    final stats = await ReadingProgressRepository(other).watchStats().first;
    expect(stats.streakDays, 1);
  });
}
