import 'package:drift/native.dart';

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
