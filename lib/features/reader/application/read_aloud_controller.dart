import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/speech/speech.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../translations/application/translation_controller.dart';
import 'reader_state.dart';
import 'reading_position_controller.dart';

/// Stav předčítání.
@immutable
class ReadAloudState {
  const ReadAloudState({
    this.active = false,
    this.paused = false,
    this.current,
    this.rate = 1.0,
  });

  final bool active;
  final bool paused;

  /// Právě čtený verš (v číslování hlavního překladu).
  final VerseRef? current;
  final double rate;

  ReadAloudState copyWith({
    bool? active,
    bool? paused,
    VerseRef? current,
    double? rate,
  }) => ReadAloudState(
    active: active ?? this.active,
    paused: paused ?? this.paused,
    current: current ?? this.current,
    rate: rate ?? this.rate,
  );
}

/// Předčítání kapitoly verš po verši; po dočtení pokračuje další kapitolou.
class ReadAloudController extends Notifier<ReadAloudState> {
  static const rates = [0.8, 1.0, 1.2, 1.4];

  Speech get _speech => ref.read(speechProvider);

  bool get available => _speech.available;
  bool get hasCzechVoice => _speech.hasCzechVoice;

  List<Verse> _verses = const [];

  @override
  ReadAloudState build() {
    final speech = ref.read(speechProvider);
    ref.onDispose(speech.stop);
    return const ReadAloudState();
  }

  /// Začne číst kapitolu od verše [from].
  Future<void> start(VerseRef from) async {
    final translationId = ref.read(translationControllerProvider).primaryId;
    final text = await ref
        .read(bibleRepositoryProvider)
        .getChapterText(translationId, from.bookId, from.chapter);
    _verses = [
      for (final v in text.verses)
        if (v.number >= from.verse) v,
    ];
    if (_verses.isEmpty) return;
    state = state.copyWith(active: true, paused: false, current: from);
    _speech.speak(
      [for (final v in _verses) spokenText(v.text)],
      rate: state.rate,
      onStart: _onVerse,
      onDone: _onChapterDone,
    );
  }

  void _onVerse(int i) {
    if (i >= _verses.length) return;
    final verse = _verses[i].ref;
    state = state.copyWith(current: verse);
    // Posunout text jen tehdy, když čtený verš není dobře vidět.
    ref.read(jumpRequestProvider.notifier).request(verse, ifNeeded: true);
  }

  Future<void> _onChapterDone() async {
    if (!state.active) return;
    final position = ref.read(readingPositionProvider.notifier);
    final moved = await position.nextChapter();
    if (!moved || !state.active) {
      stop();
      return;
    }
    final next = ref.read(readingPositionProvider);
    await start(VerseRef(next.bookId, next.chapter));
  }

  void togglePause() {
    if (!state.active) return;
    if (state.paused) {
      _speech.resume();
    } else {
      _speech.pause();
    }
    state = state.copyWith(paused: !state.paused);
  }

  /// Další rychlost čtení (dokola); čtení pokračuje od aktuálního verše.
  void cycleRate() {
    final i = rates.indexOf(state.rate);
    final rate = rates[(i + 1) % rates.length];
    state = state.copyWith(rate: rate);
    final current = state.current;
    if (state.active && current != null) start(current);
  }

  void stop() {
    _speech.stop();
    _verses = const [];
    state = ReadAloudState(rate: state.rate);
  }

  /// Text verše k přečtení: bez značek doplněných slov a alternativ.
  @visibleForTesting
  static String spokenText(String text) => text
      .replaceAll(RegExp(r'\{[^}]*\}'), '')
      .replaceAll(RegExp('[⌈⌉\\[\\]]'), '')
      .replaceAll('\n', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

/// Syntéza řeči (v testech nahraditelná).
final speechProvider = Provider<Speech>((_) => Speech.instance);

final readAloudProvider = NotifierProvider<ReadAloudController, ReadAloudState>(
  ReadAloudController.new,
);

/// Právě předčítaný verš (pro zvýraznění v textu).
final speakingVerseProvider = Provider<VerseRef?>((ref) {
  final s = ref.watch(readAloudProvider);
  return s.active ? s.current : null;
});
