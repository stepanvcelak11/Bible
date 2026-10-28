import 'dart:io';

import 'package:bible_reader/data/bible/bible_database.dart';
import 'package:bible_reader/data/repositories/bible_repository_impl.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';

import 'dart:convert';

import 'package:bible_reader/domain/services/bible_content.dart';
import 'package:bible_reader/domain/services/timeline.dart';
import 'package:bible_reader/domain/services/versification.dart';
import 'package:drift/native.dart';
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
    db = BibleDatabase(NativeDatabase(file));
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

  test(
    'odkazy obsahu (časová osa, úvody, verš dne) míří na existující verše',
    () async {
      final refs = <String, VerseRef>{
        for (final e in timelineEvents)
          for (final r in e.refs) '${e.title}: ${r.encode()}': r,
        for (var d = 0; d < 400; d++)
          'verš dne $d': verseOfDay(DateTime(2025).add(Duration(days: d))),
      };
      final intros = jsonDecode(
        File('assets/content/book_intros.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      for (final MapEntry(:key, :value)
          in (intros['books'] as Map<String, dynamic>).entries) {
        for (final kv in (value['keyVerses'] as List).cast<String>()) {
          final parts = kv.split(RegExp('[:-]')).map(int.parse).toList();
          refs['úvod $key $kv'] = VerseRef(int.parse(key), parts[0], parts[1]);
        }
      }
      // Verše do situací, medailony a harmonie evangelií: začátek i konec
      // každého místa.
      Object? load(String name) =>
          jsonDecode(File('assets/content/$name').readAsStringSync());
      void addPassage(String label, Object? json) {
        final l = (json! as List).cast<int>();
        if (l[2] == 0) {
          refs[label] = VerseRef(l[0], l[1]);
          return;
        }
        refs['$label (začátek)'] = VerseRef(l[0], l[1], l[2]);
        refs['$label (konec)'] = VerseRef(
          l[0],
          l.length > 4 ? l[4] : l[1],
          l[3],
        );
      }

      for (final s in (load('situations.json')! as Map)['situations'] as List) {
        for (final r in s['refs'] as List) {
          addPassage('situace ${s['id']} $r', r);
        }
      }
      for (final p in (load('people.json')! as Map)['people'] as List) {
        addPassage('postava ${p['id']} klíčový verš', p['key']);
        for (final r in p['story'] as List) {
          addPassage('postava ${p['id']} $r', r);
        }
      }
      for (final n in (load('notes.json')! as Map)['notes'] as List) {
        addPassage('poznámka ${n['title']}', n['ref']);
      }
      for (final t in (load('tables.json')! as Map)['tables'] as List) {
        for (final row in t['rows'] as List) {
          for (final c in row as List) {
            if (c is Map) addPassage('tabulka ${t['id']} ${c['t']}', c['r']);
          }
        }
      }
      for (final per in (load('harmony.json')! as Map)['periods'] as List) {
        for (final e in per['events'] as List) {
          for (final r in e['refs'] as List) {
            if (r != null) addPassage('harmonie ${e['title']} $r', r);
          }
        }
      }
      // Kanonické číslování → BKR (anglické číslování).
      final missing = <String>[];
      for (final MapEntry(:key, :value) in refs.entries) {
        final r = Versification.fromCanonical(value, 'BKR');
        final verses = await repo.getChapter('BKR', r.bookId, r.chapter);
        if (!verses.any((v) => v.number == r.verse)) missing.add(key);
      }
      expect(missing, isEmpty);
    },
    skip: skip,
  );
}
