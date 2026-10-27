import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../data/map/map_data.dart';
import '../../../data/study/study_pack.dart';
import '../../../data/study/study_repository.dart';
import '../../../data/translations/translation_installer.dart'
    show DownloadException, InstallProgress;
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/study_entities.dart';

// ============================================================================
//  Studijní balíček (původní text, slovník, souvislosti) – volitelné stažení.
// ============================================================================

sealed class StudyPackState {
  const StudyPackState();
}

/// Balíček není součástí tohoto sestavení (chybí manifest).
final class StudyUnavailable extends StudyPackState {
  const StudyUnavailable();
}

final class StudyNotInstalled extends StudyPackState {
  const StudyNotInstalled(this.manifest, {this.error});

  final StudyManifest manifest;

  /// Chyba posledního pokusu o stažení.
  final String? error;
}

final class StudyInstalling extends StudyPackState {
  const StudyInstalling(this.manifest, this.progress);

  final StudyManifest manifest;
  final InstallProgress? progress;
}

final class StudyReady extends StudyPackState {
  const StudyReady(this.manifest, this.repository);

  final StudyManifest manifest;
  final StudyRepository repository;
}

final studyPackManagerProvider = Provider<StudyPackManager>(
  (ref) => StudyPackManager(),
);

class StudyPackController extends AsyncNotifier<StudyPackState> {
  @override
  Future<StudyPackState> build() async {
    final manager = ref.read(studyPackManagerProvider);
    final manifest = await manager.loadManifest();
    if (manifest == null) return const StudyUnavailable();
    final prefs = ref.read(appPreferencesProvider);
    if (prefs.studyVersion == manifest.version) {
      final db = await manager.open(manifest.version);
      if (db != null) {
        ref.onDispose(db.close);
        return StudyReady(manifest, StudyRepository(db));
      }
    }
    return StudyNotInstalled(manifest);
  }

  Future<void> install() async {
    final current = state.value;
    final StudyManifest manifest;
    switch (current) {
      case StudyNotInstalled(manifest: final m):
        manifest = m;
      default:
        return;
    }
    final manager = ref.read(studyPackManagerProvider);
    final prefs = ref.read(appPreferencesProvider);
    state = AsyncData(StudyInstalling(manifest, null));
    try {
      final old = prefs.studyVersion;
      if (old != null && old != manifest.version) await manager.remove(old);
      await manager.install(
        manifest,
        onProgress: (p) => state = AsyncData(StudyInstalling(manifest, p)),
      );
      await prefs.setStudyVersion(manifest.version);
      ref.invalidateSelf();
    } on DownloadException catch (e) {
      state = AsyncData(StudyNotInstalled(manifest, error: e.message));
    } catch (e) {
      state = AsyncData(StudyNotInstalled(manifest, error: '$e'));
    }
  }

  Future<void> remove() async {
    final prefs = ref.read(appPreferencesProvider);
    final version = prefs.studyVersion;
    await prefs.setStudyVersion(null);
    if (version != null) {
      await ref.read(studyPackManagerProvider).remove(version);
    }
    ref.invalidateSelf();
  }
}

final studyPackProvider =
    AsyncNotifierProvider<StudyPackController, StudyPackState>(
      StudyPackController.new,
    );

/// Repozitář studijních dat, nebo `null`, pokud balíček není stažen.
final studyRepositoryProvider = Provider<StudyRepository?>((ref) {
  final s = ref.watch(studyPackProvider).value;
  return s is StudyReady ? s.repository : null;
});

/// Slovo původního textu + heslo slovníku (český význam, je-li k dispozici).
typedef StudyWord = ({OriginalWord word, LexiconEntry? entry});

final verseWordsProvider = FutureProvider.autoDispose
    .family<List<StudyWord>, (VerseRef, String)>((ref, key) async {
      final repo = ref.watch(studyRepositoryProvider);
      if (repo == null) return const [];
      final words = await repo.words(key.$1, key.$2);
      final lexicon = await repo.lexiconMany(words.map((w) => w.strong));
      return [for (final w in words) (word: w, entry: lexicon[w.strong])];
    });

final lexiconEntryProvider = FutureProvider.autoDispose
    .family<LexiconEntry?, String>(
      (ref, strong) async =>
          ref.watch(studyRepositoryProvider)?.lexicon(strong),
    );

final occurrencesProvider = FutureProvider.autoDispose
    .family<List<VerseRef>, String>(
      (ref, strong) async =>
          await ref.watch(studyRepositoryProvider)?.occurrences(strong) ??
          const [],
    );

final crossReferencesProvider = FutureProvider.autoDispose
    .family<List<CrossReference>, (VerseRef, String)>(
      (ref, key) async =>
          await ref
              .watch(studyRepositoryProvider)
              ?.crossReferences(key.$1, key.$2) ??
          const [],
    );

// ============================================================================
//  Přibalený obsah: úvody ke knihám a mapy.
// ============================================================================

final bookIntrosProvider = FutureProvider<Map<int, BookIntro>>((ref) async {
  final json = jsonDecode(
    await rootBundle.loadString('assets/content/book_intros.json'),
  ) as Map<String, Object?>;
  final books = json['books']! as Map<String, Object?>;
  return {
    for (final e in books.entries)
      int.parse(e.key): BookIntro.fromJson(e.value! as Map<String, Object?>),
  };
});

final mapDataProvider = FutureProvider<MapData>((ref) => MapData.load());
