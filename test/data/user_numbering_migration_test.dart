import 'package:bible_reader/data/user/user_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'migrace 2 → 3 převede odkazy z Kralické na kanonické číslování',
    () async {
      // Schéma vezmeme z aktuální databáze (verze 2 a 3 se liší jen daty).
      final current = UserDatabase(NativeDatabase.memory());
      final ddl = await current
          .customSelect(
            'SELECT sql FROM sqlite_master WHERE sql IS NOT NULL '
            "AND name NOT LIKE 'sqlite_%'",
          )
          .map((r) => r.read<String>('sql'))
          .get();
      await current.close();

      final raw = sqlite3.openInMemory();
      for (final s in ddl) {
        raw.execute(s);
      }
      raw
        ..execute(
          'INSERT INTO highlights (book_id, chapter, verse, color, created_at) '
          "VALUES (19, 51, 10, 'yellow', 0), (19, 51, 11, 'green', 0), "
          "(43, 3, 16, 'blue', 0)",
        )
        ..execute(
          'INSERT INTO bookmarks (book_id, chapter, verse, translation_id, '
          "created_at) VALUES (29, 2, 28, 'BKR', 0), (39, 4, 2, 'CEP', 0)",
        )
        ..execute(
          'INSERT INTO notes (book_id, chapter, verse_start, verse_end, body, '
          "created_at, updated_at) VALUES (39, 4, 2, 3, 'slunce', 0, 0)",
        )
        ..execute('PRAGMA user_version = 2');

      final db = UserDatabase(NativeDatabase.opened(raw));
      final highlights = await db
          .customSelect(
            'SELECT book_id, chapter, verse, color FROM highlights '
            'ORDER BY book_id, chapter, verse',
          )
          .map(
            (r) => (
              r.read<int>('book_id'),
              r.read<int>('chapter'),
              r.read<int>('verse'),
              r.read<String>('color'),
            ),
          )
          .get();
      expect(highlights, [
        (19, 51, 12, 'yellow'), // „Stvoř mi čisté srdce“
        (19, 51, 13, 'green'),
        (43, 3, 16, 'blue'),
      ]);

      final bookmarks = await db
          .customSelect('SELECT book_id, chapter, verse FROM bookmarks')
          .map(
            (r) => (
              r.read<int>('book_id'),
              r.read<int>('chapter'),
              r.read<int>('verse'),
            ),
          )
          .get();
      // BKR převedena, záložka z ČEP zůstala.
      expect(bookmarks, containsAll([(29, 3, 1), (39, 4, 2)]));

      final note = await db
          .customSelect('SELECT chapter, verse_start, verse_end FROM notes')
          .getSingle();
      expect(note.read<int>('chapter'), 3);
      expect(note.read<int>('verse_start'), 20);
      expect(note.read<int>('verse_end'), 21);
      await db.close();
    },
  );
}
