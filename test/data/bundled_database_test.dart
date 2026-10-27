import 'dart:io';

import 'package:bible_reader/data/bible/bible_database.dart';
import 'package:bible_reader/data/repositories/bible_repository_impl.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:flutter_test/flutter_test.dart';

/// Kontrola skutečné vygenerované databáze (assets/db/bible.db).
/// Přeskočí se, pokud ještě nebyla sestavena.
void main() {
  final file = File('assets/db/bible.db');
  final skip = file.existsSync()
      ? false
      : 'assets/db/bible.db neexistuje – spusť tool/build_bible_db.py';

  late BibleDatabase db;
  late BibleRepositoryImpl repo;
  setUpAll(() {
    if (skip != false) return;
    db = BibleDatabase.open(file);
    repo = BibleRepositoryImpl(db);
  });
  tearDownAll(() async {
    if (skip == false) await db.close();
  });

  test('obsahuje 66 knih a BKR s celým kánonem', () async {
    expect(await repo.getBooks(), hasLength(66));
    final translations = await repo.getTranslations();
    expect(translations.map((t) => t.id), contains('BKR'));
    expect((await repo.getChapterCounts('BKR')).length, 66);
  }, skip: skip);

  test('Jan 3:16 v BKR', () async {
    final verses = await repo.getChapter('BKR', 43, 3);
    expect(
      verses.firstWhere((v) => v.number == 16).text,
      startsWith('Nebo tak Bůh miloval svět'),
    );
  }, skip: skip);

  test('fulltext bez diakritiky je rychlý', () async {
    final sw = Stopwatch()..start();
    final hits = await repo.search('laska', translationIds: {'BKR'});
    sw.stop();
    expect(hits, isNotEmpty);
    expect(hits.first.snippet, contains(SearchHit.matchStart));
    // Orientační limit (desktop); na telefonu bývá jednotky až desítky ms.
    expect(sw.elapsedMilliseconds, lessThan(500));
  }, skip: skip);
}
