import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/versification.dart';
import '../../../domain/services/chapter_navigator.dart';
import '../../translations/application/translation_controller.dart';
import 'reader_state.dart';

/// Aktuální místo čtení – nezávislé na překladu.
///
/// Každá změna se hned uloží, takže aplikace po restartu (nebo po zabití
/// systémem na pozadí) naběhne přesně tam, kde uživatel skončil.
class ReadingPositionController extends Notifier<VerseRef> {
  static const _start = VerseRef(1, 1); // Genesis 1:1

  @override
  VerseRef build() =>
      ref.read(appPreferencesProvider).readingPosition ?? _start;

  /// Přejde na konkrétní místo (výběr knihy/kapitoly, výsledek hledání,
  /// záložka…).
  void goTo(VerseRef target) {
    if (target == state) return;
    state = target;
    ref.read(appPreferencesProvider).setReadingPosition(target);
  }

  /// Přejde na verš, posune čtečku přímo na něj a krátce ho podbarví
  /// (výsledek hledání, záložka, poznámka).
  void jumpTo(VerseRef target) {
    ref.read(verseSelectionProvider.notifier).clear();
    goTo(target);
    ref.read(jumpRequestProvider.notifier).request(target);
    ref.read(flashVerseProvider.notifier).flash(target);
  }

  /// Zaznamená verš, který je právě nahoře na obrazovce (bez přechodu).
  void updateVisibleVerse(int verse) {
    if (verse < 1 || verse == state.verse) return;
    goTo(state.copyWith(verse: verse));
  }

  /// Další kapitola v aktuálním hlavním překladu. Vrací `false` na konci.
  Future<bool> nextChapter() => _move((nav, current) => nav.next(current));

  /// Předchozí kapitola. Vrací `false` na začátku Bible.
  Future<bool> previousChapter() =>
      _move((nav, current) => nav.previous(current));

  /// Pokud aktuální kapitola v daném překladu neexistuje, posune pozici na
  /// nejbližší platnou (volá se po přepnutí překladu).
  ///
  /// [from] = překlad, ve kterém byla pozice zapsaná: při jiném číslování
  /// (BKR × ČEP) se převede, aby zůstal stejný text (Ž 51,10 → 51,12).
  Future<void> ensureValidFor(String translationId, {String? from}) async {
    final before = state;
    final nav = await _navigatorFor(translationId);
    if (!ref.mounted) return;
    // Mezitím mohl proběhnout skok (např. z výsledku hledání) – ten už je
    // v číslování nového překladu.
    final position = from == null || state != before
        ? state
        : Versification.between(state, from, translationId);
    goTo(nav.clamp(position));
  }

  Future<bool> _move(
    VerseRef? Function(ChapterNavigator, VerseRef) step,
  ) async {
    final translationId = ref.read(translationControllerProvider).primaryId;
    final nav = await _navigatorFor(translationId);
    if (!ref.mounted) return false;
    final target = step(nav, state);
    if (target == null) return false;
    goTo(target);
    return true;
  }

  Future<ChapterNavigator> _navigatorFor(String translationId) async =>
      ChapterNavigator(
        await ref.read(chapterCountsProvider(translationId).future),
      );
}

final readingPositionProvider =
    NotifierProvider<ReadingPositionController, VerseRef>(
      ReadingPositionController.new,
    );
