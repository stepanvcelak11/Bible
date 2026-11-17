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

  test('kázání: více bloků na jedné obrazovce', () {
    const h1 = PrepBlock(id: 1, kind: PrepBlockKind.heading, text: 'Bod 1');
    const n1 = PrepBlock(id: 2, kind: PrepBlockKind.note, text: 'a');
    const q1 = PrepBlock(
      id: 3,
      kind: PrepBlockKind.question,
      text: 'b',
      withPrevious: true,
    );
    const h2 = PrepBlock(id: 4, kind: PrepBlockKind.heading, text: 'Bod 2');
    const n2 = PrepBlock(
      id: 5,
      kind: PrepBlockKind.note,
      text: 'c',
      withPrevious: true,
    );
    final blocks = [h1, n1, q1, h2, n2];
    List<List<int>> ids(PrepSlideMode m) => [
      for (final g in prepSlides(blocks, m)) [for (final b in g) b.id],
    ];
    expect(ids(PrepSlideMode.custom), [
      [1],
      [2, 3],
      [4, 5],
    ]);
    // Spojené bloky zůstávají spolu v každém režimu.
    expect(ids(PrepSlideMode.single), ids(PrepSlideMode.custom));
    expect(ids(PrepSlideMode.sections), [
      [1, 2, 3],
      [4, 5],
    ]);
    // Nastavení se uloží do zálohy.
    expect(PrepBlock.fromJson(q1.toJson())!.withPrevious, isTrue);
    expect(PrepBlock.fromJson(n1.toJson())!.withPrevious, isFalse);
    expect(n1.copyWith(text: 'x').withPrevious, isFalse);
    expect(q1.copyWith(text: 'x').withPrevious, isTrue);
  });

  test('kázání: rozvržení Bible vlevo, poznámky vpravo', () {
    const p = Passage(43, 3, 16, 16);
    const h = PrepBlock(id: 1, kind: PrepBlockKind.heading, text: 'Bod');
    const v = PrepBlock(id: 2, kind: PrepBlockKind.verse, passage: p);
    const n = PrepBlock(id: 3, kind: PrepBlockKind.note, text: 'a');
    const q = PrepBlock(
      id: 4,
      kind: PrepBlockKind.question,
      text: 'b',
      place: PrepPlace.full,
    );
    String show(PrepLayout l) => prepRows([h, v, n, q], l)
        .map(
          (r) =>
              '${r.left.map((b) => b.id).join()}|'
              '${r.right.map((b) => b.id).join()}',
        )
        .join(' ');
    expect(show(PrepLayout.versesLeft), '1| 2|3 4|');
    expect(show(PrepLayout.versesRight), '1| 3|2 4|');
    expect(show(PrepLayout.stacked), '1| 2| 3| 4|');
    // Vlastní místo bloku má přednost a uloží se.
    final left = n.copyWith(place: PrepPlace.left);
    expect(prepPlaceOf(left, PrepLayout.versesLeft), PrepPlace.left);
    expect(PrepBlock.fromJson(left.toJson())!.place, PrepPlace.left);
    expect(PrepBlock.fromJson(n.toJson())!.place, PrepPlace.auto);
  });

  test('kázání: překlady, ruční rozmístění a klepnutí se uloží', () {
    const p = Passage(43, 3, 16, 16);
    final b = const PrepBlock(id: 7, kind: PrepBlockKind.verse, passage: p)
        .copyWith(
          translations: ['bkr', 'cep'],
          parallel: true,
          frame: () => const PrepFrame(0.1, 0.2, 0.5, 0.3),
          step: 2,
          zoom: 1.3,
        );
    final r = PrepBlock.fromJson(jsonDecode(jsonEncode(b.toJson())))!;
    expect(r.translations, ['bkr', 'cep']);
    expect(r.parallel, isTrue);
    expect(r.frame, const PrepFrame(0.1, 0.2, 0.5, 0.3));
    expect(r.step, 2);
    expect(r.zoom, closeTo(1.3, 1e-9));
    // Zrušení ručního místa.
    expect(r.copyWith(frame: () => null).frame, isNull);
    expect(r.copyWith(text: 'x').frame, isNotNull);
    // Rámeček nevyjede z plochy.
    final f = const PrepFrame(0.8, 0.8, 0.3, 0.3).moved(0, 0);
    expect(f.x + f.w, lessThanOrEqualTo(1));
    expect(const PrepFrame(0.5, 0.5, 0.2, 0.2).moved(0.9, 0.9).x, 0.8);
    expect(const PrepFrame(0.5, 0.5, 0.2, 0.2).resized(1, 1).w, 0.5);
  });

  test('kázání: výchozí rozmístění podle rozvržení', () {
    const p = Passage(43, 3, 16, 16);
    const h = PrepBlock(id: 1, kind: PrepBlockKind.heading, text: 'Bod');
    const v = PrepBlock(id: 2, kind: PrepBlockKind.verse, passage: p);
    const n = PrepBlock(id: 3, kind: PrepBlockKind.note, text: 'a');
    final f = defaultFrames([h, v, n], PrepLayout.versesLeft);
    expect(f[1]!.w, greaterThan(0.9));
    expect(f[2]!.x, lessThan(f[3]!.x));
    expect(f[2]!.y, f[3]!.y);
    expect(f[1]!.y, lessThan(f[2]!.y));
    for (final r in f.values) {
      expect(r.x + r.w, lessThanOrEqualTo(1.0001));
      expect(r.y + r.h, lessThanOrEqualTo(1.0001));
    }
  });

  test('přenos přípravy na jiné zařízení: soubor, nahrazení, kopie', () async {
    final c = await container();
    final ctrl = c.read(prepProvider.notifier);
    final prep = ctrl.create(title: 'Boží láska', template: false);
    ctrl.addBlock(prep.id, PrepBlockKind.note, text: 'Z počítače');
    final sent = ctrl.byId(prep.id)!;
    final file = jsonDecode(jsonEncode(prepFileJson(sent)));
    expect(prepFileName(sent, 'json'), 'bozi-laska.json');

    // Na tabletu zatím není → načte se se stejným id.
    ctrl.remove(prep.id);
    final parsed = parsePrepFile(file);
    expect(parsed.single.blocks.single.text, 'Z počítače');
    ctrl.importPrep(parsed.single, replace: true);
    expect(ctrl.byId(prep.id)!.title, 'Boží láska');

    // Novější verze ze souboru stejnou přípravu nahradí…
    final newer = parsed.single.copyWith(title: 'Boží láska 2');
    ctrl.importPrep(newer, replace: true);
    expect(c.read(prepProvider), hasLength(1));
    expect(ctrl.byId(prep.id)!.title, 'Boží láska 2');
    // …nebo se uloží jako kopie vedle.
    final copy = ctrl.importPrep(parsed.single, replace: false);
    expect(c.read(prepProvider), hasLength(2));
    expect(copy.id, isNot(prep.id));
    expect(copy.title, 'Boží láska (kopie)');

    // Ze zálohy aplikace se vezmou všechny přípravy; nesmysl nic.
    expect(parsePrepFile({'preps': ctrl.exportList()}), hasLength(2));
    expect(parsePrepFile({'foo': 1}), isEmpty);
    expect(parsePrepFile('x'), isEmpty);
  });

  test('kázání: rozmístění platí jen pro obrazovku, pro kterou vzniklo', () {
    const a = PrepBlock(id: 1, kind: PrepBlockKind.note, text: 'a');
    const b = PrepBlock(id: 2, kind: PrepBlockKind.note, text: 'b');
    // Rozmístěno, když byl blok sám na obrazovce (přes celou plochu)…
    final alone = a.copyWith(
      frame: () => const PrepFrame(0.03, 0.03, 0.94, 0.94),
      frameKey: prepSlideKey([a]),
    );
    expect(prepHasFrame(alone, prepSlideKey([a])), isTrue);
    // …po spojení s dalším blokem se staré místo nepoužije.
    final joined = b.copyWith(withPrevious: true);
    final slides = prepSlides([alone, joined], PrepSlideMode.custom);
    expect(slides.single, hasLength(2));
    expect(prepHasFrame(alone, prepSlideKey(slides.single)), isFalse);
    // Klíč se uloží do přípravy.
    expect(PrepBlock.fromJson(alone.toJson())!.frameKey, '1');
  });
}
