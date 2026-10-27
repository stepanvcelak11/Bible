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
  BibleDatabase(super.executor);

  /// Musí odpovídat `SCHEMA_VERSION` v tool/build_bible_db.py.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // Produkční soubor už má `user_version = 1`, takže onCreate proběhne
    // jen pro prázdnou databázi – tj. v testech (in-memory).
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) => throw UnsupportedError(
      'Obsahová databáze se nemigruje, ale nahrazuje novým souborem '
      '(nalezena verze $from, očekávána $to).',
    ),
  );
}
