import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/user_entities.dart';
import '../../../domain/services/versification.dart';
import '../../translations/application/translation_controller.dart';

// ============================================================================
//  Přechodný stav čtečky (neukládá se): výběr veršů, skok na verš,
//  viditelnost ovládání (Focus Mode) a uživatelská data aktuální kapitoly.
// ============================================================================

/// Vybrané verše v jedné kapitole.
@immutable
class VerseSelection {
  const VerseSelection({
    this.bookId = 0,
    this.chapter = 0,
    this.verses = const {},
  });

  final int bookId;
  final int chapter;
  final Set<int> verses;

  bool get isEmpty => verses.isEmpty;

  bool contains(int bookId, int chapter, int verse) =>
      this.bookId == bookId &&
      this.chapter == chapter &&
      verses.contains(verse);

  List<VerseRef> get refs => [
    for (final v in verses.toList()..sort()) VerseRef(bookId, chapter, v),
  ];
}

class VerseSelectionController extends Notifier<VerseSelection> {
  @override
  VerseSelection build() => const VerseSelection();

  /// Přidá/odebere verš. Výběr v jiné kapitole se nahradí.
  void toggle(int bookId, int chapter, int verse) {
    final same = state.bookId == bookId && state.chapter == chapter;
    final verses = same ? {...state.verses} : <int>{};
    if (!verses.remove(verse)) verses.add(verse);
    state = VerseSelection(bookId: bookId, chapter: chapter, verses: verses);
  }

  void clear() {
    if (!state.isEmpty) state = const VerseSelection();
  }
}

final verseSelectionProvider =
    NotifierProvider<VerseSelectionController, VerseSelection>(
      VerseSelectionController.new,
    );

/// Požadavek na posun na verš (z hledání, záložky…). `id` odliší opakovaný
/// skok na stejný verš.
@immutable
class JumpRequest {
  const JumpRequest(this.ref, this.id, {this.ifNeeded = false});

  final VerseRef ref;
  final int id;

  /// Posunout jen tehdy, když verš není dobře vidět (předčítání).
  final bool ifNeeded;
}

class JumpRequestController extends Notifier<JumpRequest?> {
  var _counter = 0;

  @override
  JumpRequest? build() => null;

  void request(VerseRef ref, {bool ifNeeded = false}) =>
      state = JumpRequest(ref, ++_counter, ifNeeded: ifNeeded);

  void done(int id) {
    if (state?.id == id) state = null;
  }
}

final jumpRequestProvider =
    NotifierProvider<JumpRequestController, JumpRequest?>(
      JumpRequestController.new,
    );

/// Verš krátce podbarvený po skoku (aby oko hned vědělo, kam se dívat).
class FlashVerseController extends Notifier<VerseRef?> {
  @override
  VerseRef? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  Timer? _timer;

  void flash(VerseRef ref) {
    state = ref;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1600), () => state = null);
  }
}

final flashVerseProvider = NotifierProvider<FlashVerseController, VerseRef?>(
  FlashVerseController.new,
);

/// Focus Mode: ovládání se schová při čtení (posun dolů) a vrátí se při
/// posunu nahoru nebo klepnutí do volného místa.
class ControlsVisibilityController extends Notifier<bool> {
  @override
  bool build() => true;

  void show() => state = true;
  void hide() => state = false;
  void toggle() => state = !state;
}

final controlsVisibleProvider =
    NotifierProvider<ControlsVisibilityController, bool>(
      ControlsVisibilityController.new,
    );

// --- Uživatelská data kapitoly ---------------------------------------------

typedef ChapterId = (int bookId, int chapter);

final _highlightsProvider = StreamProvider.autoDispose
    .family<List<Highlight>, ChapterId>(
      (ref, id) => ref
          .watch(userDataRepositoryProvider)
          .watchHighlightsInChapter(id.$1, id.$2),
    );

final _bookmarksProvider = StreamProvider.autoDispose
    .family<List<Bookmark>, ChapterId>(
      (ref, id) => ref
          .watch(userDataRepositoryProvider)
          .watchBookmarksInChapter(id.$1, id.$2),
    );

final _notesProvider = StreamProvider.autoDispose.family<List<Note>, ChapterId>(
  (ref, id) =>
      ref.watch(userDataRepositoryProvider).watchNotesInChapter(id.$1, id.$2),
);

/// Zvýraznění, záložky a poznámky jedné kapitoly indexované číslem verše.
@immutable
class ChapterAnnotations {
  const ChapterAnnotations({
    this.highlights = const {},
    this.bookmarks = const {},
    this.notes = const {},
  });

  final Map<int, HighlightColor> highlights;
  final Set<int> bookmarks;

  /// Poznámka je přiřazena k poslednímu verši svého rozsahu (tam se
  /// zobrazí ikona).
  final Map<int, List<Note>> notes;

  static const empty = ChapterAnnotations();
}

///
/// [ChapterId] je kapitola v číslování HLAVNÍHO překladu; uložená data jsou
/// v kanonickém číslování, proto se načtou kanonické kapitoly, které
/// kapitola pokrývá (BKR Jóel 3 = ČEP Jóel 4), a čísla veršů se převedou.
final chapterAnnotationsProvider = Provider.autoDispose
    .family<ChapterAnnotations, ChapterId>((ref, id) {
      final translationId = ref.watch(
        translationControllerProvider.select((s) => s.primaryId),
      );
      final scheme = schemeOf(translationId);
      final canonical = Versification.chaptersSpanned(
        id.$1,
        id.$2,
        176,
        scheme,
        VerseScheme.hebrew,
      );
      final highlights = [
        for (final c in canonical)
          ...?ref.watch(_highlightsProvider((id.$1, c))).value,
      ];
      final bookmarks = [
        for (final c in canonical)
          ...?ref.watch(_bookmarksProvider((id.$1, c))).value,
      ];
      final notes = [
        for (final c in canonical)
          ...?ref.watch(_notesProvider((id.$1, c))).value,
      ];
      if (highlights.isEmpty && bookmarks.isEmpty && notes.isEmpty) {
        return ChapterAnnotations.empty;
      }
      // Kanonický verš → číslo verše v zobrazené kapitole (nebo null).
      int? local(VerseRef r) {
        final d = Versification.convert(r, VerseScheme.hebrew, scheme);
        return d.chapter == id.$2 ? d.verse : null;
      }

      final byVerse = <int, List<Note>>{};
      for (final n in notes) {
        final v = local(n.ref.copyWith(verse: n.verseEnd));
        if (v != null) (byVerse[v] ??= []).add(n);
      }
      return ChapterAnnotations(
        highlights: {for (final h in highlights) ?local(h.ref): h.color},
        bookmarks: {for (final b in bookmarks) ?local(b.ref)},
        notes: byVerse,
      );
    });

/// Jeden verš v daném překladu (seznamy v Deníku).
final verseTextProvider = FutureProvider.autoDispose
    .family<Verse?, (String, VerseRef)>(
      (ref, key) => ref.watch(bibleRepositoryProvider).getVerse(key.$1, key.$2),
    );
