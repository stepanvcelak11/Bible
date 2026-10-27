import 'package:bible_reader/app.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/features/reader/application/reading_position_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_databases.dart';

void main() {
  testWidgets('čtečka zobrazí kapitolu a přepne překlad i porovnání', (
    tester,
  ) async {
    final container = await tester.runAsync(createTestContainer);
    container!
        .read(readingPositionProvider.notifier)
        .goTo(const VerseRef(43, 3, 16));

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const BibleApp()),
    );
    Future<void> settle() async {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
    }

    await settle();
    expect(find.text('Jan 3'), findsOneWidget);
    expect(
      find.textContaining('miloval svět', findRichText: true),
      findsOneWidget,
    );

    // Otevřít „Vybrat překlad“ a zvolit ČSP.
    await tester.tap(find.byType(ActionChip));
    await tester.pumpAndSettle();
    expect(find.text('Vybrat překlad'), findsOneWidget);
    await tester.tap(find.text('Český studijní překlad'));
    await settle();
    expect(
      find.textContaining('miluje svět', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Jan 3'), findsOneWidget, reason: 'pozice zůstala');

    // Zapnout porovnání → oba texty vedle sebe.
    await tester.tap(find.text('Porovnat dva překlady'));
    await settle();
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
}
