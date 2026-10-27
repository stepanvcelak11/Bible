import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/data/bible/bible_database.dart';
import 'package:bible_reader/data/repositories/bible_repository_impl.dart';
import 'package:bible_reader/data/translations/translation_installer.dart';
import 'package:bible_reader/data/translations/translation_parsers.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_databases.dart';

const _osis = '''<?xml version="1.0" encoding="UTF-8"?>
<osis><osisText><header><work><title>Hlavička</title></work></header>
<div type="book" osisID="Gen"><title type="main">První kniha</title>
<chapter sID="Gen.1" osisID="Gen.1" />
<div type="section"><title>Na počátku</title>
<p><verse sID="Gen.1.1" osisID="Gen.1.1" />Na počátku Bůh
   stvořil nebe a zemi.<verse eID="Gen.1.1" />
<verse sID="Gen.1.2" osisID="Gen.1.2" />Země byla
<note>hebr. <hi type="italic">tohu</hi>a bohu</note>pustá.<verse eID="Gen.1.2" /></p>
<lg><l><verse sID="Gen.1.3" osisID="Gen.1.3" />Bůh řekl:</l>
<l>„Ať je světlo!“ &amp; bylo.<verse eID="Gen.1.3" /></l></lg>
</div><chapter eID="Gen.1" /></div>
<div type="book" osisID="Tob"><chapter osisID="Tob.1"><verse osisID="Tob.1.1">Deuterokanonická</verse></chapter></div>
</osisText></osis>''';

void main() {
  test('OSIS: nadpisy, odstavce, poezie, poznámky, entity', () async {
    final p = await parseOsis(_osis);
    expect(p.verses.map((v) => v.verse), [1, 2, 3], reason: 'Tobiáš vynechán');
    expect(p.verses[0].text, 'Na počátku Bůh stvořil nebe a zemi.');
    expect(p.verses[0].paragraph, isTrue);
    expect(p.verses[1].text, 'Země byla pustá.');
    expect(p.verses[2].text, 'Bůh řekl:\n„Ať je světlo!“ & bylo.');
    expect(p.verses[2].poetry, isTrue);
    expect(p.headings.single.text, 'Na počátku');
    expect(p.footnotes.single.text, 'hebr. tohu a bohu');
  });

  test('Zefania a JSON', () async {
    final z = await parseTranslation(
      '<XMLBIBLE><BIBLEBOOK bnumber="43"><CHAPTER cnumber="3">'
      '<VERS vnumber="16">Neboť Bůh<NOTE>pozn.</NOTE> miloval svět.</VERS>'
      '</CHAPTER></BIBLEBOOK></XMLBIBLE>',
    );
    expect(z.verses.single.text, 'Neboť Bůh miloval svět.');
    expect(z.verses.single.bookId, 43);

    final j = await parseTranslation(
      jsonEncode({
        'verses': [
          {'book': 'John', 'chapter': 3, 'verse': 16, 'text': 'A'},
        ],
      }),
    );
    expect(j.verses.single.bookId, 43);
  });

  test('instalace do DB stažených překladů, čtení a hledání', () async {
    final bundled = await createTestBibleDb();
    final downloads = BibleDatabase(NativeDatabase.memory(), downloads: true);
    addTearDown(() async {
      await bundled.close();
      await downloads.close();
    });
    final installer = TranslationInstaller(downloads);
    await installer.save(
      await parseOsis(_osis),
      id: 'B21',
      name: 'Bible 21',
      abbreviation: 'B21',
      sortOrder: 100,
    );
    final repo = BibleRepositoryImpl(bundled, downloads);
    final translations = await repo.getTranslations();
    expect(translations.map((t) => t.id), ['BKR', 'CSP', 'B21']);
    expect(translations.last.downloaded, isTrue);

    final chapter = await repo.getChapterText('B21', 1, 1);
    expect(chapter.verses, hasLength(3));
    expect(chapter.headings[1], ['Na počátku']);
    expect(chapter.footnotes[2], ['hebr. tohu a bohu']);
    expect(chapter.verses[2].poetry, isTrue);

    // Hledání přes obě databáze, bez diakritiky.
    final hits = await repo.search('stvoril');
    expect(hits.map((h) => h.verse.translationId).toSet(), {'BKR', 'CSP', 'B21'});
    expect(await repo.searchCounts('stvoril'), {1: 3});

    // Odstranění.
    await installer.remove('B21');
    repo.invalidate();
    expect((await repo.getTranslations()).map((t) => t.id), ['BKR', 'CSP']);
    expect(
      (await repo.search('stvoril')).where((h) => h.verse.translationId == 'B21'),
      isEmpty,
    );
  });

  // Kontrola na skutečných souborech (jen lokálně, pokud jsou stažené).
  final dir = Platform.environment['BIBLE_SOURCES'];
  for (final (file, verses, headings) in [
    ('CzeB21.xml', 31157, 2181),
    ('CzeCEP.xml', 31169, 0),
  ]) {
    final f = File('$dir/$file');
    test(
      'skutečný soubor $file odpovídá Python parseru',
      () async {
        final p = await parseOsis(f.readAsStringSync());
        expect(p.verses, hasLength(verses));
        expect(p.headings, hasLength(headings));
        final john316 = p.verses.firstWhere(
          (v) => v.bookId == 43 && v.chapter == 3 && v.verse == 16,
        );
        expect(john316.text, startsWith('Neboť Bůh'));
        expect(john316.text, isNot(contains('\n')));
      },
      skip: dir == null || !f.existsSync() ? 'BIBLE_SOURCES nenastaveno' : false,
    );
  }

  test('VerseRef zůstává kompatibilní', () {
    expect(const VerseRef(43, 3, 16).encode(), '43:3:16');
  });
}
