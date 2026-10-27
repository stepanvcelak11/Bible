import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/providers.dart';
import 'data/bible/bible_data_missing_exception.dart';
import 'data/bible/bible_db_connection.dart';
import 'data/preferences/app_preferences.dart';
import 'data/repositories/bible_repository_impl.dart';
import 'data/user/user_database.dart';

/// Připraví vše, co aplikace potřebuje před prvním snímkem, a vrátí
/// overrides pro kořenový `ProviderScope`.
///
/// Celé je to lokální I/O (žádná síť): při běžném startu jde o otevření
/// dvou SQLite databází a dva drobné dotazy (překlady, knihy). Pouze při
/// prvním spuštění / aktualizaci dat se navíc kopíruje databáze z assets.
Future<List<Override>> bootstrap() async {
  final (bibleDb, sharedPrefs) = await (
    openBibleDatabase(),
    SharedPreferences.getInstance(),
  ).wait;
  final userDb = UserDatabase.open();

  // Repozitář si seznamy uloží do cache; providery je pak vydají synchronně.
  final repo = BibleRepositoryImpl(bibleDb);
  final (translations, books) = await (
    repo.getTranslations(),
    repo.getBooks(),
  ).wait;
  if (translations.isEmpty) {
    throw const BibleDataMissingException('Databáze neobsahuje žádný překlad.');
  }

  return [
    bibleDatabaseProvider.overrideWithValue(bibleDb),
    userDatabaseProvider.overrideWithValue(userDb),
    appPreferencesProvider.overrideWithValue(AppPreferences(sharedPrefs)),
    bibleRepositoryProvider.overrideWithValue(repo),
    translationsProvider.overrideWithValue(translations),
    booksProvider.overrideWithValue(books),
  ];
}
