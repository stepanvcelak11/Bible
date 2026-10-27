import 'package:drift/drift.dart';

part 'bible_database.g.dart';

/// Obsahová databáze (texty Bible) – pouze pro čtení.
///
/// Schéma je definováno v `bible_schema.drift`, který zároveň používá
/// `tool/build_bible_db.py` k sestavení předpřipravené databáze. Za běhu
/// se databáze nikdy nemigruje: novou verzi obsahu nahraje
/// `BibleDbInstaller` jako celý soubor z assets.
///
/// Otevření podle platformy: `bible_db_connection.dart` (nativně soubor
/// v úložišti aplikace, na webu SQLite ve WebAssembly).
@DriftDatabase(include: {'bible_schema.drift'})
class BibleDatabase extends _$BibleDatabase {
  /// [downloads] = databáze překladů stažených v aplikaci (zapisovatelná,
  /// při změně schématu se vytvoří znovu – překlady lze stáhnout znovu).
  BibleDatabase(super.executor, {this.downloads = false});

  final bool downloads;

  /// Musí odpovídat `SCHEMA_VERSION` v tool/build_bible_db.py.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // Přibalený soubor už má `user_version`, takže onCreate proběhne jen pro
    // prázdnou databázi – tj. databázi stažených překladů a v testech.
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (!downloads) {
        throw UnsupportedError(
          'Obsahová databáze se nemigruje, ale nahrazuje novým souborem '
          '(nalezena verze $from, očekávána $to).',
        );
      }
      // Stažené překlady: starou strukturu zahodit a vytvořit znovu.
      for (final table in allTables.toList().reversed) {
        await m.deleteTable(table.actualTableName);
      }
      await m.createAll();
    },
  );
}
