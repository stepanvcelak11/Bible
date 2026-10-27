import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/entities/user_entities.dart';
import '../web_drift_options.dart';

part 'user_database.g.dart';

// ============================================================================
//  Uživatelská databáze (user.db) – zvýraznění, záložky, poznámky.
//
//  Odkazy na verše jsou záměrně BEZ translation_id: zvýraznění v Janovi 3:16
//  se ukáže v BKR i v ČSP. Číslování veršů mezi překlady se liší jen
//  výjimečně a takový verš pak jednoduše zůstane nezvýrazněný.
//
//  Na rozdíl od obsahové databáze se tato databáze migruje (Drift
//  MigrationStrategy) – data uživatele se nikdy nemažou.
// ============================================================================

/// Barevné zvýraznění verše (nejvýše jedno na verš).
@TableIndex(name: 'highlights_by_chapter', columns: {#bookId, #chapter})
class Highlights extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();

  /// Ukládá se `HighlightColor.name` (ne index), aby přeřazení hodnot
  /// enumu nikdy nezměnilo barvy už uložených zvýraznění.
  TextColumn get color => textEnum<HighlightColor>()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {bookId, chapter, verse},
  ];
}

/// Záložka na verši.
@TableIndex(name: 'bookmarks_by_chapter', columns: {#bookId, #chapter})
class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();

  /// Překlad, ve kterém byla záložka vytvořena (pro návrat ke čtení).
  TextColumn get translationId => text().nullable()();
  TextColumn get label => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {bookId, chapter, verse},
  ];
}

/// Soukromá poznámka k jednomu verši nebo rozsahu veršů v rámci kapitoly.
@TableIndex(name: 'notes_by_chapter', columns: {#bookId, #chapter})
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verseStart => integer()();
  IntColumn get verseEnd => integer()();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => ['CHECK (verse_end >= verse_start)'];
}

/// Deník čtení: každý přečtený úsek kapitoly (pro pokrok, sérii dní a
/// nedávno čtené).
@TableIndex(name: 'reading_log_by_chapter', columns: {#bookId, #chapter})
class ReadingLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId => integer()();
  IntColumn get chapter => integer()();
  TextColumn get translationId => text().nullable()();
  DateTimeColumn get readAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Highlights, Bookmarks, Notes, ReadingLog])
class UserDatabase extends _$UserDatabase {
  UserDatabase(super.executor);

  /// Otevře `user.db` v adresáři aplikace (dotazy běží na pozadí).
  factory UserDatabase.open() => UserDatabase(
    driftDatabase(
      name: 'user',
      native: const DriftNativeOptions(shareAcrossIsolates: true),
      web: webDriftOptions,
    ),
  );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // Změny schématu přidávat jako kroky `if (from < N) …` – nikdy nemazat
    // tabulky s uživatelskými daty.
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(readingLog);
        await m.createIndex(readingLogByChapter);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // WAL: zápis poznámky neblokuje souběžné čtení.
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );
}
