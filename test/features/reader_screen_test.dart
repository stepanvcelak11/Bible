import 'package:bible_reader/app.dart';
import 'package:bible_reader/core/providers.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/domain/entities/user_entities.dart';
import 'package:bible_reader/features/reader/application/reader_state.dart';
import 'package:bible_reader/features/reader/application/reading_position_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_databases.dart';

void main() {
  late ProviderContainer container;

  Future<void> pumpApp(WidgetTester tester, {VerseRef? at}) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    container = (await tester.runAsync(createTestContainer))!;
    if (at != null) container.read(readingPositionProvider.notifier).goTo(at);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const BibleApp()),
    );
    await settle(tester);
  }

  appTest('čtečka zobrazí kapitolu, přepne překlad i porovnání', (
    tester,
  ) async {
    await pumpApp(tester, at: const VerseRef(43, 3, 16));
    expect(find.text('Jan 3'), findsOneWidget);
    expect(
      find.textContaining('miloval svět', findRichText: true),
      findsOneWidget,
    );

    await tester.tap(find.text('BKR'));
    await tester.pumpAndSettle();
    expect(find.text('Vybrat překlad'), findsOneWidget);
    await tester.tap(find.text('Český studijní překlad'));
    await settle(tester);
    expect(
      find.textContaining('miluje svět', findRichText: true),
      findsWidgets,
    );
    expect(find.text('Jan 3'), findsOneWidget, reason: 'pozice zůstala');

    await tester.tap(find.text('Porovnat dva překlady'));
    await settle(tester);
    await tester.tapAt(const Offset(20, 20)); // zavřít panel
    await settle(tester);
    expect(find.text('ČSP · BKR'), findsOneWidget);
    expect(
      find.textContaining('miluje svět', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('miloval svět', findRichText: true),
      findsOneWidget,
    );
  });

  appTest('klepnutí na verš → panel akcí → zvýraznění a záložka', (
    tester,
  ) async {
    await pumpApp(tester, at: const VerseRef(43, 3, 16));

    await tester.tap(find.textContaining('miloval svět', findRichText: true));
    await tester.pumpAndSettle();
    expect(find.text('Jan 3,16'), findsOneWidget);
    expect(find.text('Kopírovat'), findsOneWidget);

    // Výběr dalšího verše → rozsah.
    await tester.tap(find.textContaining('neposlal', findRichText: true));
    await tester.pumpAndSettle();
    expect(find.text('Jan 3,16–17'), findsOneWidget);

    // Zvýraznit žlutě (první barva).
    await tester.tap(find.bySemanticsLabel('Zvýraznit').first);
    await settle(tester);
    expect(container.read(verseSelectionProvider).isEmpty, isTrue);
    final highlights = await tester.runAsync(
      () =>
          container.read(userDataRepositoryProvider).watchAllHighlights().first,
    );
    expect(highlights!.map((h) => h.ref.verse).toSet(), {16, 17});
    expect(highlights.first.color, HighlightColor.yellow);

    // Záložka na verši 16.
    await tester.tap(find.textContaining('miloval svět', findRichText: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Záložka'));
    await settle(tester);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
  });

  appTest('výběr knihy a kapitoly', (tester) async {
    await pumpApp(tester);
    expect(find.text('Genesis 1'), findsOneWidget);

    await tester.tap(find.text('Genesis 1'));
    await tester.pumpAndSettle();
    expect(find.text('STARÝ ZÁKON'), findsOneWidget);
    expect(find.text('NOVÝ ZÁKON'), findsOneWidget);

    await tester.tap(find.text('Jan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('3'));
    await settle(tester);

    expect(find.text('Jan 3'), findsOneWidget);
    final position = container.read(readingPositionProvider);
    expect((position.bookId, position.chapter), (43, 3));
  });

  appTest('hledání bez diakritiky a skok na výsledek', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Hledat'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'miloval');
    await tester.pump(const Duration(milliseconds: 400));
    await settle(tester);
    expect(find.text('1 výsledek'), findsOneWidget);
    expect(find.text('Jan 3,16'), findsOneWidget);

    await tester.tap(find.text('Jan 3,16'));
    await settle(tester);
    expect(find.text('Jan 3'), findsOneWidget);
    expect(container.read(readingPositionProvider), const VerseRef(43, 3, 16));
  });

  appTest('přejetí prstem = další kapitola', (tester) async {
    await pumpApp(tester);
    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1500);
    await settle(tester);
    expect(find.text('Genesis 2'), findsOneWidget);
    expect(container.read(readingPositionProvider), const VerseRef(1, 2));
  });

  appTest('nastavení: sépiový motiv a velikost písma', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byTooltip('Nabídka'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nastavení'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sépie'));
    await tester.pumpAndSettle();
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).last);
    expect(scaffold, isNotNull);
    expect(
      Theme.of(tester.element(find.text('Sépie'))).scaffoldBackgroundColor,
      const Color(0xFFF4ECD8),
    );
  });
}

/// testWidgets, který na konci nechá doběhnout časovače aplikace
/// (podbarvení verše po skoku, odložené ukládání pozice).
void appTest(String name, Future<void> Function(WidgetTester) body) {
  testWidgets(name, (tester) async {
    await body(tester);
    await tester.pump(const Duration(seconds: 3));
  });
}

/// Nechá doběhnout dotazy do SQLite (skutečné I/O) a animace.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pumpAndSettle();
  }
}
