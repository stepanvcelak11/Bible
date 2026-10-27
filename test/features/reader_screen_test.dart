import 'package:bible_reader/app.dart';
import 'package:bible_reader/core/providers.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/domain/entities/user_entities.dart';
import 'package:bible_reader/domain/entities/reader_settings.dart';
import 'package:bible_reader/features/reader/application/reader_state.dart';
import 'package:bible_reader/features/reader/application/reading_position_controller.dart';
import 'package:bible_reader/features/reader/presentation/verse_image_sheet.dart';
import 'package:bible_reader/features/settings/application/reader_settings_controller.dart';
import 'package:bible_reader/features/study/application/study_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_databases.dart';

void main() {
  late ProviderContainer container;

  Future<void> pumpApp(
    WidgetTester tester, {
    VerseRef? at,
    bool openBible = true,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    container = (await tester.runAsync(createTestContainer))!;
    if (at != null) container.read(readingPositionProvider.notifier).goTo(at);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const BibleApp()),
    );
    await settle(tester);
    if (openBible) {
      await tester.tap(find.text('Bible'));
      await settle(tester);
    }
  }

  appTest('obrazovka Dnes: pozdrav, verš dne, pokračování ve čtení', (
    tester,
  ) async {
    await pumpApp(tester, at: const VerseRef(43, 3, 16), openBible: false);
    expect(find.text('VERŠ DNE'), findsOneWidget);
    expect(find.text('Pokračovat ve čtení'), findsOneWidget);
    expect(find.text('Jan 3,16'), findsOneWidget);
    expect(find.text('Verše pro tuto chvíli'), findsOneWidget);

    await tester.tap(find.text('Jan 3,16'));
    await settle(tester);
    expect(find.text('Jan 3'), findsOneWidget, reason: 'otevřela se čtečka');
  });

  appTest('čtečka zobrazí kapitolu, přepne překlad i porovnání', (
    tester,
  ) async {
    await pumpApp(tester, at: const VerseRef(43, 3, 16));
    expect(find.text('Jan 3'), findsOneWidget);
    expect(
      find.textContaining('miloval svět', findRichText: true),
      findsOneWidget,
    );

    await tester.tap(find.text('BKR').first);
    await tester.pumpAndSettle();
    expect(find.text('Vybrat překlad'), findsOneWidget);
    await tester.tap(find.text('Český studijní překlad'));
    await settle(tester);
    expect(
      find.textContaining('miluje svět', findRichText: true),
      findsWidgets,
    );

    await tester.tap(find.text('Porovnat dva překlady'));
    await settle(tester);
    await tester.tapAt(const Offset(20, 20));
    await settle(tester);
    expect(find.text('ČSP · BKR'), findsOneWidget);
    expect(
      find.textContaining('miloval svět', findRichText: true),
      findsOneWidget,
    );
  });

  appTest('klepnutí na verš → panel akcí → zvýraznění, záložka, studium', (
    tester,
  ) async {
    await pumpApp(tester, at: const VerseRef(43, 3, 16));

    await tester.tap(find.textContaining('miloval svět', findRichText: true));
    await tester.pumpAndSettle();
    expect(find.text('Jan 3,16'), findsOneWidget);
    expect(find.text('Studovat'), findsOneWidget);

    await tester.tap(find.textContaining('neposlal', findRichText: true));
    await tester.pumpAndSettle();
    expect(find.text('Jan 3,16–17'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Zvýraznit').first);
    await settle(tester);
    expect(container.read(verseSelectionProvider).isEmpty, isTrue);
    final highlights = await tester.runAsync(
      () =>
          container.read(userDataRepositoryProvider).watchAllHighlights().first,
    );
    expect(highlights!.map((h) => h.ref.verse).toSet(), {16, 17});
    expect(highlights.first.color, HighlightColor.yellow);

    await tester.tap(find.textContaining('miloval svět', findRichText: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Záložka'));
    await settle(tester);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);

    // Studium verše bez staženého balíčku nabídne stažení.
    await tester.tap(find.textContaining('miloval svět', findRichText: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Studovat'));
    await settle(tester);
    expect(find.text('Originál'), findsOneWidget);
    expect(find.text('Studijní balíček'), findsOneWidget);
  });

  appTest('sdílení verše: náhled obrázku a volba vzhledu', (tester) async {
    await pumpApp(tester, at: const VerseRef(43, 3, 16));
    await tester.tap(find.textContaining('miloval svět', findRichText: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sdílet'));
    await settle(tester);
    expect(find.text('Sdílet verš'), findsOneWidget);
    expect(find.byType(VerseCard), findsOneWidget);
    expect(find.text('Jan 3,16'), findsWidgets);
    await tester.tap(find.text('Svítání'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<VerseCard>(find.byType(VerseCard)).style,
      VerseCardStyle.dawn,
    );
  });

  appTest('tablet: boční navigace místo spodní lišty', (tester) async {
    await pumpApp(tester, openBible: false);
    tester.view.physicalSize = const Size(2360, 1640);
    tester.view.devicePixelRatio = 2;
    await settle(tester);
    // Popisky sekcí jsou v boční liště; přechod do Bible funguje.
    await tester.tap(find.text('Bible'));
    await settle(tester);
    expect(find.text('Genesis 1'), findsOneWidget);
    expect(find.byTooltip('Další kapitola'), findsOneWidget);
    await tester.tap(find.byTooltip('Další kapitola'));
    await settle(tester);
    expect(find.text('Genesis 2'), findsOneWidget);
  });

  appTest('verše do situací: výběr situace zobrazí verše', (tester) async {
    await pumpApp(tester, openBible: false);
    await tester.tap(find.text('Mám strach'));
    await settle(tester);
    expect(find.text('Mám strach'), findsOneWidget, reason: 'nadpis stránky');
    expect(find.textContaining('Strach k životu patří'), findsOneWidget);
    // Testovací data obsahují Jana 3; ostatní místa jsou prázdná, ale
    // stránka se nesmí rozbít.
    expect(find.byType(Card), findsWidgets);
  });

  appTest('výběr knihy: mřížka, hledání a kapitola', (tester) async {
    await pumpApp(tester);
    expect(find.text('Genesis 1'), findsOneWidget);

    await tester.tap(find.text('Genesis 1'));
    await tester.pumpAndSettle();
    expect(find.text('ZÁKON (TÓRA)'), findsOneWidget);
    await tester.tap(find.text('Nový zákon'));
    await tester.pumpAndSettle();
    expect(find.text('EVANGELIA'), findsOneWidget);

    await tester.tap(find.text('Jan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('3').last);
    await settle(tester);

    expect(find.text('Jan 3'), findsOneWidget);
    final position = container.read(readingPositionProvider);
    expect((position.bookId, position.chapter), (43, 3));
  });

  appTest('hledání: slovo bez diakritiky i biblický odkaz', (tester) async {
    await pumpApp(tester, openBible: false);
    await tester.tap(find.text('Hledat').last);
    await settle(tester);

    await tester.enterText(find.byType(TextField), 'miloval');
    await tester.pump(const Duration(milliseconds: 400));
    await settle(tester);
    expect(find.text('1 výsledek v 1 knize'), findsOneWidget);
    expect(find.text('Jan 3,16'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'J 3,17');
    await tester.pump(const Duration(milliseconds: 400));
    await settle(tester);
    await tester.tap(find.text('Přejít na Jan 3,17'));
    await settle(tester);
    expect(find.text('Jan 3'), findsOneWidget);
    expect(container.read(readingPositionProvider), const VerseRef(43, 3, 17));
  });

  appTest('přejetí prstem = další kapitola', (tester) async {
    await pumpApp(tester);
    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1500);
    await settle(tester);
    expect(find.text('Genesis 2'), findsOneWidget);
    expect(container.read(readingPositionProvider), const VerseRef(1, 2));
  });

  appTest('nastavení: sépiový motiv', (tester) async {
    await pumpApp(tester, openBible: false);
    await tester.tap(find.byTooltip('Nastavení'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sépie'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Sépie'))).colorScheme.surface,
      const Color(0xFFF4ECD8),
    );
    await tester.tap(find.text('Obloha'));
    await tester.pumpAndSettle();
    expect(
      container.read(readerSettingsProvider).background,
      AppBackgroundStyle.sky,
    );
  });

  appTest('mapy a deník se otevřou', (tester) async {
    await pumpApp(tester, openBible: false);
    // Načtení mapových dat z assets je skutečné I/O.
    await tester.runAsync(() => container.read(mapDataProvider.future));
    await tester.tap(find.text('Mapy'));
    await settle(tester);
    expect(find.text('Biblické mapy'), findsOneWidget);
    expect(find.text('Abrahamova cesta'), findsOneWidget);
    await tester.ensureVisible(find.text('Abrahamova cesta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Abrahamova cesta'));
    await settle(tester);
    expect(find.textContaining('Z Uru Kaldejských'), findsOneWidget);

    await tester.tap(find.text('Deník'));
    await settle(tester);
    expect(find.text('Záložky'), findsOneWidget);
  });
}

/// testWidgets, který na konci nechá doběhnout časovače aplikace.
void appTest(String name, Future<void> Function(WidgetTester) body) {
  testWidgets(name, (tester) async {
    await body(tester);
    await tester.pump(const Duration(seconds: 30));
  });
}

/// Nechá doběhnout dotazy do SQLite (skutečné I/O) a animace.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 40)),
    );
    await tester.pumpAndSettle();
  }
}
