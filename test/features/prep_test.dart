import 'dart:convert';

import 'package:bible_reader/core/providers.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/domain/entities/content_entities.dart';
import 'package:bible_reader/features/prep/application/prep_controller.dart';
import 'package:bible_reader/features/prep/presentation/prep_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_reader/data/preferences/app_preferences.dart';

void main() {
  final books = [
    for (var i = 1; i <= 66; i++)
      Book(
        id: i,
        osis: 'B$i',
        name: i == 43 ? 'Jan' : (i == 45 ? 'Římanům' : 'Kniha $i'),
        abbreviation: i == 43 ? 'J' : (i == 45 ? 'Ř' : 'K$i'),
        testament: i < 40 ? Testament.oldTestament : Testament.newTestament,
      ),
  ];

  test('odkaz v přípravě: kapitola, verš i rozsah', () {
    final ch = parsePassageInput('J 3', books)!;
    expect((ch.bookId, ch.chapter, ch.wholeChapter), (43, 3, true));
    final v = parsePassageInput('J 3,16', books)!;
    expect((v.verse, v.end), (16, 16));
    final r = parsePassageInput('Ř 8,28-39', books)!;
    expect((r.bookId, r.chapter, r.verse, r.end), (45, 8, 28, 39));
    expect(parsePassageInput('nesmysl', books), isNull);
  });

  Future<ProviderContainer> container() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = AppPreferences(await SharedPreferences.getInstance());
    final c = ProviderContainer(
      overrides: [appPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('příprava: šablona, bloky, přesun, uložení a záloha', () async {
    final c = await container();
    final ctrl = c.read(prepProvider.notifier);
    final prep = ctrl.create(
      title: 'Dobrý pastýř',
      kind: PrepKind.sermon,
      passage: const Passage(43, 10, 1, 18),
    );
    // Hlavní text + osnova kázání.
    expect(prep.blocks.first.kind, PrepBlockKind.verse);
    expect(
      prep.blocks.where((b) => b.kind == PrepBlockKind.heading),
      hasLength(prepTemplates[PrepKind.sermon]!.length),
    );
    final note = ctrl.addBlock(
      prep.id,
      PrepBlockKind.note,
      text: 'Ovce znají hlas',
    );
    expect(ctrl.byId(prep.id)!.blocks.last.id, note.id);
    ctrl.moveBlock(prep.id, ctrl.byId(prep.id)!.blocks.length - 1, 0);
    expect(ctrl.byId(prep.id)!.blocks.first.id, note.id);
    ctrl.removeBlock(prep.id, note.id);
    expect(ctrl.byId(prep.id)!.blocks.any((b) => b.id == note.id), isFalse);

    // Uloženo v nastavení a obnovitelné ze zálohy.
    final saved = c.read(appPreferencesProvider).preps;
    expect(saved, hasLength(1));
    final restored = Prep.fromJson(jsonDecode(saved.single));
    expect(restored!.title, 'Dobrý pastýř');
    expect(restored.passage!.end, 18);
    final exported = ctrl.exportList();
    ctrl.remove(prep.id);
    expect(c.read(prepProvider), isEmpty);
    expect(ctrl.importList(exported), 1);
    expect(ctrl.importList(exported), 0, reason: 'bez duplicit');
  });
}
