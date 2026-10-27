import 'package:bible_reader/core/providers.dart';
import 'package:bible_reader/data/bible/bible_database.dart';
import 'package:bible_reader/data/preferences/app_preferences.dart';
import 'package:bible_reader/data/repositories/bible_repository_impl.dart';
import 'package:bible_reader/data/user/user_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Malý vzorek dat: dva překlady s odlišným číslováním Jóele (BKR 3
/// kapitoly, CSP 4) a verš, který v jednom překladu chybí.
const _books = [
  // id, osis, name, abbr, testament
  (1, 'Gen', 'Genesis', 'Gn', 'OT'),
  (29, 'Joel', 'Jóel', 'Jl', 'OT'),
  (43, 'John', 'Jan', 'J', 'NT'),
];

const _verses = <(String, int, int, int, String)>[
  ('BKR', 1, 1, 1, 'Na počátku stvořil Bůh nebe a zemi.'),
  ('BKR', 1, 1, 2, 'Země pak byla nesličná a pustá.'),
  ('BKR', 1, 2, 1, 'A tak dokonána jsou nebesa i země.'),
  ('BKR', 29, 3, 1, 'Nebo aj, v těch dnech a v ten čas.'),
  (
    'BKR',
    43,
    3,
    16,
    'Nebo tak Bůh miloval svět, že Syna svého jednorozeného dal.',
  ),
  (
    'BKR',
    43,
    3,
    17,
    'Neboť neposlal Bůh Syna svého na svět, aby odsoudil svět.',
  ),
  ('CSP', 1, 1, 1, 'Na počátku stvořil Bůh nebesa a zemi.'),
  ('CSP', 1, 2, 1, 'Tak byla dokončena nebesa i země.'),
  ('CSP', 29, 3, 1, 'Potom vyleji svého Ducha.'),
  ('CSP', 29, 4, 1, 'Neboť hle, v oněch dnech.'),
  ('CSP', 43, 3, 16, '„Neboť tak Bůh miluje svět, že dal svého jediného Syna.'),
  ('CSP', 43, 3, 18, 'Kdo v něho věří, není souzen. Láska Hospodinova.'),
];

/// In-memory obsahová databáze (onCreate spustí schéma z .drift souboru,
/// včetně FTS5 tabulky) naplněná vzorkem.
Future<BibleDatabase> createTestBibleDb() async {
  final db = BibleDatabase(NativeDatabase.memory());
  await db.batch((b) {
    b.insertAll(db.translations, [
      TranslationsCompanion.insert(
        id: 'BKR',
        name: 'Bible kralická',
        abbreviation: 'BKR',
        year: const Value(1613),
        sortOrder: const Value(1),
      ),
      TranslationsCompanion.insert(
        id: 'CSP',
        name: 'Český studijní překlad',
        abbreviation: 'ČSP',
        sortOrder: const Value(2),
      ),
    ]);
    // Aplikace počítá vždy se všemi 66 knihami – ostatní doplníme zástupně.
    final named = {for (final b in _books) b.$1: b};
    b.insertAll(db.books, [
      for (var id = 1; id <= 66; id++)
        if (named[id] case (_, final osis, final name, final abbr, final t))
          BooksCompanion.insert(
            id: Value(id),
            osis: osis,
            name: name,
            abbreviation: abbr,
            testament: t,
          )
        else
          BooksCompanion.insert(
            id: Value(id),
            osis: 'B$id',
            name: 'Kniha $id',
            abbreviation: 'K$id',
            testament: id <= 39 ? 'OT' : 'NT',
          ),
    ]);
    b.insertAll(db.verses, [
      for (final (tr, book, ch, v, text) in _verses)
        VersesCompanion.insert(
          translationId: tr,
          bookId: book,
          chapter: ch,
          verse: v,
          text$: text,
        ),
    ]);
  });
  await db.customStatement(
    'INSERT INTO chapters (translation_id, book_id, chapter, verse_count) '
    'SELECT translation_id, book_id, chapter, MAX(verse) FROM verses '
    'GROUP BY translation_id, book_id, chapter',
  );
  await db.customStatement(
    "INSERT INTO verses_fts (verses_fts) VALUES ('rebuild')",
  );
  return db;
}

/// ProviderContainer se vzorkovými daty – stejné overrides jako `bootstrap()`.
Future<ProviderContainer> createTestContainer({
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final sharedPrefs = await SharedPreferences.getInstance();
  final bibleDb = await createTestBibleDb();
  final downloadsDb = BibleDatabase(NativeDatabase.memory(), downloads: true);
  final repo = BibleRepositoryImpl(bibleDb, downloadsDb);
  final container = ProviderContainer(
    overrides: [
      bibleDatabaseProvider.overrideWithValue(bibleDb),
      downloadsDatabaseProvider.overrideWithValue(downloadsDb),
      userDatabaseProvider.overrideWithValue(
        UserDatabase(NativeDatabase.memory()),
      ),
      appPreferencesProvider.overrideWithValue(AppPreferences(sharedPrefs)),
      bibleRepositoryProvider.overrideWithValue(repo),
      initialTranslationsProvider.overrideWithValue(
        await repo.getTranslations(),
      ),
      booksProvider.overrideWithValue(await repo.getBooks()),
    ],
  );
  addTearDown(() async {
    container.dispose();
    await bibleDb.close();
    await downloadsDb.close();
  });
  return container;
}
