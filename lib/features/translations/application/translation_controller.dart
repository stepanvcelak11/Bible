import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../reader/application/reading_position_controller.dart';

/// Stav výběru překladu: hlavní překlad + volitelný druhý pro porovnání.
@immutable
class TranslationSelection {
  const TranslationSelection({required this.primaryId, this.secondaryId});

  final String primaryId;

  /// `null` = porovnání (dvousloupcové zobrazení) je vypnuté.
  final String? secondaryId;

  bool get isComparing => secondaryId != null;

  @override
  bool operator ==(Object other) =>
      other is TranslationSelection &&
      other.primaryId == primaryId &&
      other.secondaryId == secondaryId;

  @override
  int get hashCode => Object.hash(primaryId, secondaryId);

  @override
  String toString() => 'TranslationSelection($primaryId, $secondaryId)';
}

/// Řídí přepínání překladů.
///
/// Stav je synchronní – seznam překladů je přednačtený při startu – takže
/// přepnutí je okamžité a nikdy nezobrazí prázdný mezistav. Pozice čtení
/// je na překladu nezávislá ([VerseRef]), proto přepnutí zachová kapitolu
/// i verš; výjimkou je kapitola, která v novém překladu neexistuje.
class TranslationController extends Notifier<TranslationSelection> {
  @override
  TranslationSelection build() {
    final available = ref.watch(translationsProvider);
    final prefs = ref.watch(appPreferencesProvider);
    final ids = available.map((t) => t.id).toSet();

    // Uložené volby ověříme – překlad mohl být z nové verze dat odebrán.
    final primary = ids.contains(prefs.primaryTranslationId)
        ? prefs.primaryTranslationId!
        : available.first.id;
    final secondary = prefs.secondaryTranslationId;
    return TranslationSelection(
      primaryId: primary,
      secondaryId: secondary != primary && ids.contains(secondary)
          ? secondary
          : null,
    );
  }

  List<Translation> get _available => ref.read(translationsProvider);

  bool _exists(String id) => _available.any((t) => t.id == id);

  /// Nastaví hlavní překlad. Pokud je zvolený překlad právě druhým
  /// (porovnávaným), oba se prohodí – porovnání tak zůstane zachováno.
  void selectPrimary(String id) {
    if (!_exists(id) || id == state.primaryId) return;
    final secondary = state.secondaryId == id
        ? state.primaryId
        : state.secondaryId;
    _update(TranslationSelection(primaryId: id, secondaryId: secondary));
  }

  /// Nastaví druhý překlad pro porovnání; `null` porovnání vypne.
  void selectSecondary(String? id) {
    if (id != null && (!_exists(id) || id == state.primaryId)) return;
    _update(TranslationSelection(primaryId: state.primaryId, secondaryId: id));
  }

  /// Zapne/vypne porovnání. Při zapnutí použije naposledy porovnávaný
  /// překlad, jinak první jiný dostupný.
  void toggleCompare() {
    if (state.isComparing) {
      selectSecondary(null);
      return;
    }
    final last = ref.read(appPreferencesProvider).lastSecondaryTranslationId;
    final candidate = last != null && last != state.primaryId && _exists(last)
        ? last
        : _available.where((t) => t.id != state.primaryId).firstOrNull?.id;
    if (candidate != null) selectSecondary(candidate);
  }

  /// Prohodí hlavní a porovnávaný překlad.
  void swap() {
    final secondary = state.secondaryId;
    if (secondary == null) return;
    _update(
      TranslationSelection(primaryId: secondary, secondaryId: state.primaryId),
    );
  }

  void _update(TranslationSelection next) {
    final previousPrimary = state.primaryId;
    state = next;

    final prefs = ref.read(appPreferencesProvider);
    prefs.setPrimaryTranslationId(next.primaryId);
    prefs.setSecondaryTranslationId(next.secondaryId);
    if (next.secondaryId != null) {
      prefs.setLastSecondaryTranslationId(next.secondaryId!);
    }

    if (next.primaryId != previousPrimary) {
      // Nový překlad může mít jiný počet kapitol – pozici případně upravíme.
      ref
          .read(readingPositionProvider.notifier)
          .ensureValidFor(next.primaryId, from: previousPrimary);
    }
  }
}

final translationControllerProvider =
    NotifierProvider<TranslationController, TranslationSelection>(
      TranslationController.new,
    );

/// Aktuální hlavní překlad jako entita (pro zobrazení názvu/zkratky).
final primaryTranslationProvider = Provider<Translation>((ref) {
  final id = ref.watch(
    translationControllerProvider.select((s) => s.primaryId),
  );
  return ref.watch(translationsProvider).firstWhere((t) => t.id == id);
});

/// Aktuální porovnávaný překlad, nebo `null`.
final secondaryTranslationProvider = Provider<Translation?>((ref) {
  final id = ref.watch(
    translationControllerProvider.select((s) => s.secondaryId),
  );
  if (id == null) return null;
  return ref.watch(translationsProvider).firstWhere((t) => t.id == id);
});
