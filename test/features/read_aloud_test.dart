import 'package:bible_reader/core/speech/speech.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/features/reader/application/read_aloud_controller.dart';
import 'package:bible_reader/features/reader/application/reading_position_controller.dart';
import 'package:bible_reader/features/translations/application/translation_controller.dart';
import 'package:bible_reader/data/repositories/bible_repository_impl.dart';
import 'package:bible_reader/core/providers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_databases.dart';

class FakeSpeech implements Speech {
  List<String> spoken = [];
  void Function(int)? onStart;
  void Function()? onDone;
  var stopped = 0;

  @override
  bool get available => true;

  @override
  bool get hasCzechVoice => true;

  @override
  void speak(
    List<String> texts, {
    required double rate,
    required void Function(int index) onStart,
    required void Function() onDone,
  }) {
    spoken = texts;
    this.onStart = onStart;
    this.onDone = onDone;
  }

  @override
  void pause() {}

  @override
  void resume() {}

  @override
  void stop() => stopped++;
}

void main() {
  test('text k přečtení bez značek', () {
    expect(
      ReadAloudController.spokenText('Bůh {doslova: Pán} řekl:\n⌈Buď⌉ světlo'),
      'Bůh řekl: Buď světlo',
    );
  });

  test('předčítání od verše, zvýraznění a zastavení', () async {
    final speech = FakeSpeech();
    final c = await createTestContainer(
      overrides: [speechProvider.overrideWithValue(speech)],
    );
    final ctl = c.read(readAloudProvider.notifier);
    await ctl.start(const VerseRef(43, 3, 16));
    expect(speech.spoken, hasLength(2));
    expect(speech.spoken.first, startsWith('Nebo tak Bůh miloval svět'));
    expect(c.read(speakingVerseProvider), const VerseRef(43, 3, 16));

    speech.onStart!(1);
    expect(c.read(speakingVerseProvider), const VerseRef(43, 3, 17));

    ctl.stop();
    expect(c.read(speakingVerseProvider), isNull);
    expect(c.read(readAloudProvider).active, isFalse);
  });

  test('po přepnutí BKR → ČSP zůstane stejný text (Jóel 3 → 4)', () async {
    final c = await createTestContainer();
    c.read(readingPositionProvider.notifier).goTo(const VerseRef(29, 3, 1));
    c.read(translationControllerProvider.notifier).selectPrimary('CSP');
    await Future<void>.delayed(Duration.zero);
    await c.read(readingPositionProvider.notifier).ensureValidFor('CSP');
    expect(c.read(readingPositionProvider), const VerseRef(29, 4, 1));
  });

  test('porovnání BKR × ČSP v Jóelovi spáruje verše podle obsahu', () async {
    final c = await createTestContainer();
    final repo = c.read(bibleRepositoryProvider) as BibleRepositoryImpl;
    final rows = await repo.getParallelChapter('BKR', 'CSP', 29, 3);
    expect(rows.single.primary!.text, startsWith('Nebo aj'));
    expect(rows.single.secondary!.text, startsWith('Neboť hle'));
    expect(rows.single.secondaryLabel, '4:1');
  });
}
