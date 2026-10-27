import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'bible_database.g.dart';

/// Obsahová databáze (texty Bible) – pouze pro čtení.
///
/// Schéma je definováno v `bible_schema.drift`, který zároveň používá
/// `tool/build_bible_db.py` k sestavení předpřipravené databáze. Za běhu
/// se databáze nikdy nemigruje: novou verzi obsahu nahraje
/// `BibleDbInstaller` jako celý soubor z assets.
@DriftDatabase(include: {'bible_schema.drift'})
class BibleDatabase extends _$BibleDatabase {
  BibleDatabase(super.executor);

  /// Otevře databázi ze souboru na pozadí (vlastní isolate), aby dotazy
  /// nikdy neblokovaly UI vlákno a čtení drželo plynulých 60 fps.
  factory BibleDatabase.open(File file) => BibleDatabase(
    NativeDatabase.createInBackground(
      file,
      setup: (db) {
        // Pojistka: obsahová databáze se nesmí změnit.
        db.execute('PRAGMA query_only = ON;');
        // Paměťově mapované čtení – rychlejší náhodný přístup ke
        // stránkám (načtení kapitoly, fulltext).
        db.execute('PRAGMA mmap_size = 67108864;');
        db.execute('PRAGMA temp_store = MEMORY;');
      },
    ),
  );

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
