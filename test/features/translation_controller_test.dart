import 'package:bible_reader/core/providers.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/features/reader/application/chapter_content_provider.dart';
import 'package:bible_reader/features/reader/application/reading_position_controller.dart';
import 'package:bible_reader/features/translations/application/translation_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_databases.dart';

void main() {
  test('výchozí stav: první překlad, bez porovnání, Genesis 1:1', () async {
    final c = await createTestContainer();
    expect(
      c.read(translationControllerProvider),
      const TranslationSelection(primaryId: 'BKR'),
    );
    expect(c.read(readingPositionProvider), const VerseRef(1, 1, 1));
  });

  test('neplatné uložené volby se nahradí platnými', () async {
    final c = await createTestContainer(
      prefs: {'translation.primary': 'SMAZANY', 'translation.secondary': 'BKR'},
    );
    // Primární spadne na BKR → sekundární BKR by byl shodný, proto null.
    expect(
      c.read(translationControllerProvider),
      const TranslationSelection(primaryId: 'BKR'),
    );
  });

  test('přepnutí překladu zachová pozici čtení', () async {
    final c = await createTestContainer();
    c.read(readingPositionProvider.notifier).goTo(const VerseRef(43, 3, 16));

    c.read(translationControllerProvider.notifier).selectPrimary('CSP');

    expect(c.read(translationControllerProvider).primaryId, 'CSP');
    await pumpEventQueue();
    expect(c.read(readingPositionProvider), const VerseRef(43, 3, 16));

    final content = await c.read(chapterContentProvider.future);
    expect((content as SingleChapter).verses.first.text, contains('miluje'));
  });

  test(
    'přepnutí na překlad bez dané kapitoly posune na poslední platnou',
    () async {
      final c = await createTestContainer(
        prefs: {'translation.primary': 'CSP'},
      );
      c.read(readingPositionProvider.notifier).goTo(const VerseRef(29, 4, 1));

      c.read(translationControllerProvider.notifier).selectPrimary('BKR');
      await pumpEventQueue();

      expect(c.read(readingPositionProvider), const VerseRef(29, 3));
    },
  );

  test('porovnání: zapnutí, výběr hlavního = prohození, vypnutí', () async {
    final c = await createTestContainer();
    final ctl = c.read(translationControllerProvider.notifier);

    ctl.toggleCompare();
    expect(
      c.read(translationControllerProvider),
      const TranslationSelection(primaryId: 'BKR', secondaryId: 'CSP'),
    );

    // Zvolit porovnávaný překlad jako hlavní → prohodí se, porovnání zůstane.
    ctl.selectPrimary('CSP');
    expect(
      c.read(translationControllerProvider),
      const TranslationSelection(primaryId: 'CSP', secondaryId: 'BKR'),
    );

    ctl.swap();
    expect(
      c.read(translationControllerProvider),
      const TranslationSelection(primaryId: 'BKR', secondaryId: 'CSP'),
    );

    ctl.selectSecondary('BKR'); // stejný jako hlavní → ignorováno
    expect(c.read(translationControllerProvider).secondaryId, 'CSP');

    ctl.toggleCompare();
    expect(c.read(translationControllerProvider).isComparing, isFalse);
  });

  test('porovnání vrací zarovnanou kapitolu', () async {
    final c = await createTestContainer();
    c.read(readingPositionProvider.notifier).goTo(const VerseRef(43, 3, 16));
    c.read(translationControllerProvider.notifier).toggleCompare();

    final content = await c.read(chapterContentProvider.future);
    expect(content, isA<ParallelChapter>());
    expect((content as ParallelChapter).rows.map((r) => r.number), [
      16,
      17,
      18,
    ]);
  });

  test('volby a pozice se ukládají do preferencí', () async {
    final c = await createTestContainer();
    c.read(translationControllerProvider.notifier)
      ..selectPrimary('CSP')
      ..toggleCompare();
    c.read(readingPositionProvider.notifier).goTo(const VerseRef(43, 3, 16));
    await pumpEventQueue();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('translation.primary'), 'CSP');
    expect(prefs.getString('translation.secondary'), 'BKR');
    expect(prefs.getString('reader.position'), '43:3:16');

    // Nový „start aplikace“ se stejnými preferencemi.
    final restarted = await createTestContainer(
      prefs: {for (final k in prefs.getKeys()) k: prefs.get(k)!},
    );
    expect(
      restarted.read(translationControllerProvider),
      const TranslationSelection(primaryId: 'CSP', secondaryId: 'BKR'),
    );
    expect(restarted.read(readingPositionProvider), const VerseRef(43, 3, 16));
  });

  test('listování kapitolami podle hlavního překladu', () async {
    final c = await createTestContainer();
    final pos = c.read(readingPositionProvider.notifier);
    expect(await pos.nextChapter(), isTrue);
    expect(c.read(readingPositionProvider), const VerseRef(1, 2));
    expect(await pos.nextChapter(), isTrue);
    expect(
      c.read(readingPositionProvider),
      const VerseRef(29, 1),
      reason: 'další dostupná kniha ve vzorku je Jóel',
    );
    expect(await pos.previousChapter(), isTrue);
    expect(c.read(readingPositionProvider), const VerseRef(1, 2));
    expect(c.read(bookByIdProvider(29)).name, 'Jóel');
  });
}
