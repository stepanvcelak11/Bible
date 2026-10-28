import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import 'reading_position_controller.dart';

/// Čtecí karty: několik otevřených míst v Bibli (např. Jan 3 a Matouš 5),
/// mezi kterými lze rychle přepínat. Každá karta si pamatuje, kde jsem
/// skončil.
@immutable
class ReaderTabsState {
  const ReaderTabsState(this.tabs, this.active);

  /// Pozice jednotlivých karet (aktivní karta = aktuální pozice čtení).
  final List<VerseRef> tabs;
  final int active;

  bool get hasMany => tabs.length > 1;
}

class ReaderTabsController extends Notifier<ReaderTabsState> {
  static const maxTabs = 8;

  @override
  ReaderTabsState build() {
    final prefs = ref.read(appPreferencesProvider);
    final position = ref.read(readingPositionProvider);
    var tabs = prefs.readerTabs;
    var active = prefs.readerActiveTab;
    if (tabs.isEmpty) {
      tabs = [position];
      active = 0;
    }
    active = active.clamp(0, tabs.length - 1);
    tabs = [...tabs]..[active] = position;
    // Aktivní karta sleduje čtení.
    ref.listen(readingPositionProvider, (_, next) {
      if (state.tabs[state.active] == next) return;
      _set([...state.tabs]..[state.active] = next, state.active);
    });
    return ReaderTabsState(tabs, active);
  }

  void _set(List<VerseRef> tabs, int active) {
    state = ReaderTabsState(tabs, active);
    ref.read(appPreferencesProvider).setReaderTabs(tabs, active);
  }

  /// Přepne na kartu [index].
  void select(int index) {
    if (index == state.active || index >= state.tabs.length) return;
    final target = state.tabs[index];
    _set(state.tabs, index);
    ref.read(readingPositionProvider.notifier).jumpTo(target);
  }

  /// Otevře novou kartu na místě [at] a přepne na ni.
  void open(VerseRef at) {
    if (state.tabs.length >= maxTabs) {
      // Nejstarší neaktivní karta ustoupí.
      final drop = state.active == 0 ? 1 : 0;
      final tabs = [...state.tabs]..removeAt(drop);
      final active = state.active > drop ? state.active - 1 : state.active;
      _set(tabs, active);
    }
    _set([...state.tabs, at], state.tabs.length);
    ref.read(readingPositionProvider.notifier).jumpTo(at);
  }

  /// Zavře kartu; poslední karta zůstává vždy otevřená.
  void close(int index) {
    if (state.tabs.length <= 1) return;
    final tabs = [...state.tabs]..removeAt(index);
    if (index == state.active) {
      final active = index.clamp(0, tabs.length - 1);
      _set(tabs, active);
      ref.read(readingPositionProvider.notifier).jumpTo(tabs[active]);
    } else {
      _set(tabs, state.active > index ? state.active - 1 : state.active);
    }
  }
}

final readerTabsProvider =
    NotifierProvider<ReaderTabsController, ReaderTabsState>(
      ReaderTabsController.new,
    );
