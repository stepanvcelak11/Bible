import 'dart:io';
import 'dart:ui' as ui;

import 'package:bible_reader/core/providers.dart';
import 'package:bible_reader/core/theme/app_theme.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/domain/entities/study_entities.dart';
import 'package:bible_reader/features/study/presentation/verse_study_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('oblouky souvislostí se vykreslí nad celou Biblí', (
    tester,
  ) async {
    final counts = {for (var b = 1; b <= 66; b++) b: b == 19 ? 150 : 20};
    final key = GlobalKey();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chapterCountsProvider.overrideWith((ref, id) async => counts),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: RepaintBoundary(
              key: key,
              child: SizedBox(
                width: 400,
                child: CrossRefArcs(
                  source: const VerseRef(23, 53, 5),
                  translationId: 'BKR',
                  refs: const [
                    CrossReference(
                      target: VerseRef(40, 8, 17),
                      endVerse: 17,
                      votes: 40,
                    ),
                    CrossReference(
                      target: VerseRef(60, 2, 24),
                      endVerse: 24,
                      votes: 90,
                    ),
                    CrossReference(
                      target: VerseRef(19, 22, 1),
                      endVerse: 1,
                      votes: 10,
                    ),
                    CrossReference(
                      target: VerseRef(1, 3, 15),
                      endVerse: 15,
                      votes: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('4 souvislostí'), findsOneWidget);
    expect(find.textContaining('2 ve Starém, 2 v Novém'), findsOneWidget);
    final out = Platform.environment['ARCS_PNG'];
    if (out != null) {
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 2);
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        File(out).writeAsBytesSync(data!.buffer.asUint8List());
      });
    }
  });
}
