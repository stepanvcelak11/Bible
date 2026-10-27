import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/entities/bible_entities.dart';
import '../../domain/entities/user_entities.dart';
import '../../domain/services/versification.dart';
import '../web_drift_options.dart';

part 'user_database.g.dart';

// ============================================================================
//  Uživatelská databáze (user.db) – zvýraznění, záložky, poznámky.
//
//  Odkazy na verše jsou záměrně BEZ translation_id a v KANONICKÉM
//  (hebrejském) číslování – zvýraznění Ž 51,12 se ukáže v ČEP u verše 12
//  a v Kralické (jiné číslování) u verše 10. Převod: Versification.
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
  int get schemaVersion => 3;

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
      if (from < 3) await _canonicalizeNumbering();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // WAL: zápis poznámky neblokuje souběžné čtení.
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );

  /// Verze 3: odkazy se ukládají v kanonickém (hebrejském) číslování.
  /// Starší data vznikla v Kralické (anglické číslování) – záložky s jiným
  /// překladem se nechají být.
  Future<void> _canonicalizeNumbering() async {
    VerseRef canon(int b, int c, int v) => Versification.convert(
      VerseRef(b, c, v),
      VerseScheme.english,
      VerseScheme.hebrew,
    );

    Future<void> remap(
      String table,
      String verseColumn, {
      String? where,
      String? endColumn,
    }) async {
      final rows = await customSelect(
        'SELECT id, book_id, chapter, $verseColumn AS v'
        '${endColumn == null ? '' : ', $endColumn AS e'} FROM $table'
        '${where == null ? '' : ' WHERE $where'}',
      ).get();
      final moved = <(int, VerseRef, int?)>[];
      for (final r in rows) {
        final b = r.read<int>('book_id'), c = r.read<int>('chapter');
        final v = r.read<int>('v');
        if (b < 1 || b > 66 || c < 1 || v < 1) continue;
        final to = canon(b, c, v);
        int? end;
        if (endColumn != null) {
          final e = canon(b, c, r.read<int>('e'));
          end = e.chapter == to.chapter && e.verse >= to.verse
              ? e.verse
              : to.verse;
        }
        if (to != VerseRef(b, c, v) ||
            (end != null && end != r.read<int>('e'))) {
          moved.add((r.read<int>('id'), to, end));
        }
      }
      // Nejdřív smazat a pak vložit – posun o verš by jinak narazil na
      // unikátní klíč sousedního řádku.
      for (final (id, to, end) in moved) {
        final old = await customSelect(
          'SELECT * FROM $table WHERE id = ?',
          variables: [Variable.withInt(id)],
        ).getSingle();
        await customStatement('DELETE FROM $table WHERE id = ?', [id]);
        final data = Map.of(old.data)
          ..['book_id'] = to.bookId
          ..['chapter'] = to.chapter
          ..[verseColumn] = to.verse;
        if (endColumn != null) data[endColumn] = end;
        final cols = data.keys.toList();
        await customStatement(
          'INSERT OR REPLACE INTO $table (${cols.join(', ')}) '
          'VALUES (${List.filled(cols.length, '?').join(', ')})',
          [for (final c in cols) data[c]],
        );
      }
    }

    await transaction(() async {
      await remap('highlights', 'verse');
      await remap(
        'bookmarks',
        'verse',
        where: "translation_id IS NULL OR translation_id = 'BKR'",
      );
      await remap('notes', 'verse_start', endColumn: 'verse_end');
    });
  }
}
