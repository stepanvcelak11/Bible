import 'dart:io';

import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'bible_database.dart';
import 'bible_db_installer.dart';

/// Nativní otevření: instalace z assets (při změně verze) + SQLite soubor.
///
/// Dotazy běží v background isolate, aby nikdy neblokovaly UI vlákno.
Future<BibleDatabase> openBibleDatabase() async {
  final file = await BibleDbInstaller().ensureInstalled();
  return BibleDatabase(
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
}

/// Databáze překladů stažených v aplikaci (zapisovatelná, mimo instalátor –
/// aktualizace přibalených dat ji nepřepíše).
Future<BibleDatabase> openDownloadsDatabase() async {
  final dir = Directory(
    p.join((await getApplicationSupportDirectory()).path, 'bible'),
  );
  await dir.create(recursive: true);
  return BibleDatabase(
    NativeDatabase.createInBackground(
      File(p.join(dir.path, 'downloads.db')),
      setup: (db) => db.execute('PRAGMA journal_mode = WAL;'),
    ),
    downloads: true,
  );
}
