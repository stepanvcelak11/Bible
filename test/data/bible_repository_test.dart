import 'package:bible_reader/data/bible/bible_database.dart';
import 'package:bible_reader/data/repositories/bible_repository_impl.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_databases.dart';

void main() {
  late BibleDatabase db;
  late BibleRepositoryImpl repo;

  setUp(() async {
    db = await createTestBibleDb();
    repo = BibleRepositoryImpl(db);
  });
  tearDown(() => db.close());

  test('překlady jsou seřazené podle sort_order', () async {
    final translations = await repo.getTranslations();
    expect(translations.map((t) => t.id), ['BKR', 'CSP']);
    expect(translations.first.name, 'Bible kralická');
  });

  test('kapitola se načte seřazená podle čísla verše', () async {
    final verses = await repo.getChapter('BKR', 1, 1);
    expect(verses.map((v) => v.number), [1, 2]);
    expect(verses.first.text, startsWith('Na počátku'));
    expect(verses.first.ref, const VerseRef(1, 1, 1));
  });

  test('počty kapitol se liší podle překladu (Jóel)', () async {
    expect((await repo.getChapterCounts('BKR'))[29], 3);
    expect((await repo.getChapterCounts('CSP'))[29], 4);
  });

  test('porovnání zarovná verše a zachová chybějící na jedné straně', () async {
    final rows = await repo.getParallelChapter('BKR', 'CSP', 43, 3);
    expect(rows.map((r) => r.number), [16, 17, 18]);
    expect(rows[0].primary, isNotNull);
    expect(rows[0].secondary, isNotNull);
    expect(rows[1].secondary, isNull, reason: 'v CSP chybí 3:17');
    expect(rows[2].primary, isNull, reason: 'v BKR chybí 3:18');
  });

  group('fulltext', () {
    test('ignoruje diakritiku a velikost písmen', () async {
      final hits = await repo.search('laska hospodinova');
      expect(hits, hasLength(1));
      expect(hits.single.verse.ref, const VerseRef(43, 3, 18));
    });

    test('hledá předponou (české tvary slov)', () async {
      // "milov" → miloval, "milu" → miluje
      expect(await repo.search('milov'), hasLength(1));
      expect((await repo.search('stvoril')).map((h) => h.verse.translationId), [
        'BKR',
        'CSP',
      ]);
    });

    test('filtruje podle překladu', () async {
      final hits = await repo.search('svět', translationIds: {'CSP'});
      expect(hits.map((h) => h.verse.translationId).toSet(), {'CSP'});
    });

    test('vyznačí shody v úryvku', () async {
      final hit = (await repo.search('nebesa', translationIds: {'CSP'})).first;
      expect(
        hit.snippet,
        contains('${SearchHit.matchStart}nebesa${SearchHit.matchEnd}'),
      );
    });

    test('syntaxe FTS5 ve vstupu nevyhodí výjimku', () async {
      expect(await repo.search('AND ( * "'), isEmpty);
      expect(await repo.search('Bůh: (svět'), isNotEmpty);
      expect(await repo.search('   '), isEmpty);
    });

    test('přesná fráze v uvozovkách', () async {
      expect(await repo.search('„Bůh miloval“'), hasLength(1));
      expect(await repo.search('"miloval Bůh"'), isEmpty);
    });
  });
}
