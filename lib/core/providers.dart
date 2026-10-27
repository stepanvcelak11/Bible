import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/bible/bible_database.dart' show BibleDatabase;
import '../data/translations/translation_installer.dart';
import '../data/preferences/app_preferences.dart';
import '../data/repositories/bible_repository_impl.dart';
import '../data/repositories/user_data_repository_impl.dart';
import '../data/user/user_database.dart';
import '../domain/entities/bible_entities.dart';
import '../domain/repositories/bible_repository.dart';
import '../domain/repositories/user_data_repository.dart';

// ============================================================================
//  Kořenové závislosti (dependency injection přes Riverpod).
//
//  Providery označené „override“ se naplní v `bootstrap()` ještě před
//  spuštěním UI – databáze, preference i seznam překladů/knih jsou tak
//  v celé aplikaci dostupné SYNCHRONNĚ (žádné načítací stavy pro data,
//  která se za běhu nemění). V testech se přepíšou in-memory verzemi.
// ============================================================================

Never _notOverridden(String name) =>
    throw UnimplementedError('$name musí být přepsán v ProviderScope.');

/// Override: obsahová databáze (pouze pro čtení).
final bibleDatabaseProvider = Provider<BibleDatabase>(
  (ref) => _notOverridden('bibleDatabaseProvider'),
);

/// Override: databáze překladů stažených v aplikaci.
final downloadsDatabaseProvider = Provider<BibleDatabase>(
  (ref) => _notOverridden('downloadsDatabaseProvider'),
);

final translationInstallerProvider = Provider<TranslationInstaller>(
  (ref) => TranslationInstaller(ref.watch(downloadsDatabaseProvider)),
);

/// Override: uživatelská databáze.
final userDatabaseProvider = Provider<UserDatabase>(
  (ref) => _notOverridden('userDatabaseProvider'),
);

/// Override: nastavení.
final appPreferencesProvider = Provider<AppPreferences>(
  (ref) => _notOverridden('appPreferencesProvider'),
);

final bibleRepositoryProvider = Provider<BibleRepository>(
  (ref) => BibleRepositoryImpl(ref.watch(bibleDatabaseProvider)),
);

final userDataRepositoryProvider = Provider<UserDataRepository>(
  (ref) => UserDataRepositoryImpl(ref.watch(userDatabaseProvider)),
);

/// Override: seznam překladů načtený při startu.
final initialTranslationsProvider = Provider<List<Translation>>(
  (ref) => _notOverridden('initialTranslationsProvider'),
);

/// Dostupné překlady (přibalené + stažené). Po stažení nebo odstranění
/// překladu zavolejte [TranslationsController.refresh].
class TranslationsController extends Notifier<List<Translation>> {
  @override
  List<Translation> build() => ref.watch(initialTranslationsProvider);

  Future<void> refresh() async {
    final repo = ref.read(bibleRepositoryProvider)..invalidate();
    final list = await repo.getTranslations();
    ref.invalidate(chapterCountsProvider);
    state = list;
  }
}

final translationsProvider =
    NotifierProvider<TranslationsController, List<Translation>>(
      TranslationsController.new,
    );

/// Override: přednačtený seznam 66 knih.
final booksProvider = Provider<List<Book>>(
  (ref) => _notOverridden('booksProvider'),
);

/// Kniha podle id (O(1) – id je pořadí 1–66).
final bookByIdProvider = Provider.family<Book, int>(
  (ref, id) => ref.watch(booksProvider)[id - 1],
);

/// Počty kapitol jednotlivých knih v daném překladu.
final chapterCountsProvider = FutureProvider.family<Map<int, int>, String>(
  (ref, translationId) =>
      ref.watch(bibleRepositoryProvider).getChapterCounts(translationId),
);
