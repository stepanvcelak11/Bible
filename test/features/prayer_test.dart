import 'package:bible_reader/core/theme/app_theme.dart';
import 'package:bible_reader/domain/entities/reader_settings.dart';
import 'package:bible_reader/features/prayer/application/prayer_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_databases.dart';

void main() {
  test('modlitby: vyslyšení, počítadlo, obnovení a záloha', () async {
    final container = await createTestContainer();
    addTearDown(container.dispose);
    final ctl = container.read(prayerProvider.notifier);

    final a = ctl.add('  Za rodinu ', now: DateTime(2026, 1, 1));
    final b = ctl.add('Za práci', now: DateTime(2026, 1, 2));
    expect(a.text, 'Za rodinu');
    expect(
      [for (final p in container.read(prayerProvider)) p.id],
      [b.id, a.id],
    );

    ctl
      ..markPrayed(a.id)
      ..markPrayed(a.id)
      ..setAnswered(a.id, answered: true, answer: 'Uzdravení');
    var first = container.read(prayerProvider).last;
    expect(
      (first.prayed, first.isAnswered, first.answer),
      (2, true, 'Uzdravení'),
    );

    // Smazání a vrácení na původní místo.
    ctl.remove(a.id);
    ctl.restore(first);
    expect(container.read(prayerProvider).last.id, a.id);

    // Záloha: duplicity a poškozené položky se přeskočí.
    final backup = ctl.exportList();
    ctl.remove(a.id);
    expect(
      ctl.importList([
        ...backup,
        'nesmysl',
        {'id': 1},
      ]),
      1,
    );
    expect(ctl.importList(backup), 0);
    first = container.read(prayerProvider).last;
    expect(
      (first.text, first.prayed, first.answer),
      ('Za rodinu', 2, 'Uzdravení'),
    );

    // Uloženo v nastavení – nový kontejner načte totéž.
    final again = container.read(prayerProvider.notifier).build();
    expect(again.length, 2);
  });

  test('barevný akcent: uložení a motivy', () {
    const s = ReaderSettings(accent: AppAccent.ocean);
    expect(ReaderSettings.fromJson(s.toJson()).accent, AppAccent.ocean);
    expect(ReaderSettings.fromJson(const {}).accent, AppAccent.gold);
    final tones = AccentTones.of(AppAccent.ocean);
    expect(AppTheme.light(AppAccent.ocean).colorScheme.primary, tones.primary);
    expect(AppTheme.dark(AppAccent.ocean).colorScheme.primary, tones.bright);
    for (final a in AppAccent.values) {
      expect(AppTheme.sepia(a).extension<AppPalette>(), isNotNull);
    }
  });
}
