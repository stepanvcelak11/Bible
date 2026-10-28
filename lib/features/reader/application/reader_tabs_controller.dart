import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/versification.dart';
import '../../translations/application/translation_controller.dart';
import 'reading_position_controller.dart';

/// Jedna čtecí karta: místo v Bibli a překlad, ve kterém se na kartě čte.
/// [position] je zapsaná v číslování svého překladu.
@immutable
class ReaderTab {
  const ReaderTab(this.position, this.translationId);

  final VerseRef position;
  final String translationId;

  ReaderTab copyWith({VerseRef? position, String? translationId}) =>
      ReaderTab(position ?? this.position, translationId ?? this.translationId);

  @override
  bool operator ==(Object other) =>
      other is ReaderTab &&
      other.position == position &&
      other.translationId == translationId;

  @override
  int get hashCode => Object.hash(position, translationId);
}

/// Čtecí karty: několik otevřených míst v Bibli (např. Jan 3 a Matouš 5),
/// každé případně v jiném překladu – mezi kartami lze rychle přepínat
/// a porovnávat tak i překlady. Každá karta si pamatuje, kde jsem skončil.
@immutable
class ReaderTabsState {
  const ReaderTabsState(this.tabs, this.active);

  final List<ReaderTab> tabs;
  final int active;

  bool get hasMany => tabs.length > 1;

  /// Karty se liší překladem → na liště ukážeme i zkratku překladu.
  bool get mixedTranslations =>
      tabs.map((t) => t.translationId).toSet().length > 1;
}

class ReaderTabsController extends Notifier<ReaderTabsState> {
  static const maxTabs = 8;

  @override
  ReaderTabsState build() {
    final prefs = ref.read(appPreferencesProvider);
    final position = ref.read(readingPositionProvider);
    final translation = ref.read(translationControllerProvider).primaryId;
    final available = {for (final t in ref.read(translationsProvider)) t.id};
    var tabs = [
      for (final (pos, id) in prefs.readerTabs)
        ReaderTab(pos, id != null && available.contains(id) ? id : translation),
    ];
    var active = prefs.readerActiveTab;
    if (tabs.isEmpty) {
      tabs = [ReaderTab(position, translation)];
      active = 0;
    }
    active = active.clamp(0, tabs.length - 1);
    tabs = [...tabs]..[active] = ReaderTab(position, translation);
    // Aktivní karta sleduje čtení i zvolený překlad.
    ref.listen(readingPositionProvider, (_, next) {
      final current = state.tabs[state.active];
      if (current.position == next) return;
      _replaceActive(current.copyWith(position: next));
    });
    ref.listen(translationControllerProvider.select((s) => s.primaryId), (
      _,
      next,
    ) {
      final current = state.tabs[state.active];
      if (current.translationId == next) return;
      _replaceActive(current.copyWith(translationId: next));
    });
    return ReaderTabsState(tabs, active);
  }

  void _replaceActive(ReaderTab tab) =>
      _set([...state.tabs]..[state.active] = tab, state.active);

  void _set(List<ReaderTab> tabs, int active) {
    state = ReaderTabsState(tabs, active);
    ref.read(appPreferencesProvider).setReaderTabs([
      for (final t in tabs) (t.position, t.translationId),
    ], active);
  }

  /// Přepne na kartu [index] (místo i překlad).
  void select(int index) {
    if (index == state.active || index >= state.tabs.length) return;
    _set(state.tabs, index);
    _show(state.tabs[index]);
  }

  void _show(ReaderTab tab) {
    ref
        .read(translationControllerProvider.notifier)
        .selectPrimary(tab.translationId, convertPosition: false);
    ref.read(readingPositionProvider.notifier).jumpTo(tab.position);
  }

  /// Otevře novou kartu na místě [at] (v aktuálním překladu, nebo
  /// v [translationId]) a přepne na ni.
  void open(VerseRef at, {String? translationId}) {
    final current = ref.read(translationControllerProvider).primaryId;
    final target = translationId ?? current;
    final tab = ReaderTab(Versification.between(at, current, target), target);
    if (state.tabs.length >= maxTabs) {
      // Nejstarší neaktivní karta ustoupí.
      final drop = state.active == 0 ? 1 : 0;
      final tabs = [...state.tabs]..removeAt(drop);
      final active = state.active > drop ? state.active - 1 : state.active;
      _set(tabs, active);
    }
    _set([...state.tabs, tab], state.tabs.length);
    _show(tab);
  }

  /// Zavře kartu; poslední karta zůstává vždy otevřená.
  void close(int index) {
    if (state.tabs.length <= 1) return;
    final tabs = [...state.tabs]..removeAt(index);
    if (index == state.active) {
      final active = index.clamp(0, tabs.length - 1);
      _set(tabs, active);
      _show(tabs[active]);
    } else {
      _set(tabs, state.active > index ? state.active - 1 : state.active);
    }
  }
}

final readerTabsProvider =
    NotifierProvider<ReaderTabsController, ReaderTabsState>(
      ReaderTabsController.new,
    );
