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
      passages: const [Passage(43, 10, 1, 18), Passage(19, 23, 0, 0)],
    );
    // Hlavní texty + osnova kázání.
    expect(prep.blocks.take(2).map((b) => b.kind), [
      PrepBlockKind.verse,
      PrepBlockKind.verse,
    ]);
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
    expect(restored.passages.map((p) => p.end), [18, 0]);
    final exported = ctrl.exportList();
    ctrl.remove(prep.id);
    expect(c.read(prepProvider), isEmpty);
    expect(ctrl.importList(exported), 1);
    expect(ctrl.importList(exported), 0, reason: 'bez duplicit');
  });

  test('příprava: psaní do bodu a vkládání do bodu osnovy', () async {
    final c = await container();
    final ctrl = c.read(prepProvider.notifier);
    final prep = ctrl.create(kind: PrepKind.sermon);
    final headings = prep.blocks;
    expect(headings.first.hint, isNotEmpty);
    // Do 1. bodu: poznámka a verš se vloží na konec bodu, před 2. bod.
    final first = headings[1];
    final note = ctrl.addBlock(prep.id, PrepBlockKind.note, section: first.id);
    final verse = ctrl.addBlock(
      prep.id,
      PrepBlockKind.verse,
      passage: const Passage(43, 10, 11, 11),
      section: first.id,
    );
    final ids = ctrl.byId(prep.id)!.blocks.map((b) => b.id).toList();
    expect(ids.sublist(1, 5), [first.id, note.id, verse.id, headings[2].id]);
    // Za konkrétní blok.
    final q = ctrl.addBlock(prep.id, PrepBlockKind.question, after: note.id);
    expect(ctrl.byId(prep.id)!.blocks[3].id, q.id);
    // Text pod bodem se uloží.
    ctrl.updateBlock(prep.id, first.copyWith(body: 'Ježíš zná své ovce'));
    final json = jsonEncode(ctrl.byId(prep.id)!.toJson());
    final back = Prep.fromJson(jsonDecode(json))!;
    expect(back.blocks[1].body, 'Ježíš zná své ovce');
    expect(back.words, greaterThan(3));
  });

  test('starší záloha s jedním hlavním textem', () {
    final p = Prep.fromJson({
      'id': 1,
      'title': 'x',
      'ref': [43, 3, 16, 16, 3],
      'blocks': <Object>[],
    })!;
    expect(p.passages.single.verse, 16);
  });
}
