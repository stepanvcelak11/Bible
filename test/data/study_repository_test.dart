import 'dart:io';

import 'package:bible_reader/data/study/study_database.dart';
import 'package:bible_reader/data/study/study_repository.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Kontrola skutečného studijního balíčku (build/study/study-*.db).
/// Přeskočí se, pokud ještě nebyl sestaven (tool/build_study_db.py).
void main() {
  final dir = Directory('build/study');
  final files = dir.existsSync()
      ? dir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.db'))
            .toList()
      : <File>[];
  final skip = files.isEmpty ? 'studijní balíček není sestaven' : false;

  late StudyDatabase db;
  late StudyRepository repo;
  setUpAll(() {
    if (files.isEmpty) return;
    db = StudyDatabase(NativeDatabase(files.first));
    repo = StudyRepository(db);
  });
  tearDownAll(() async {
    if (files.isNotEmpty) await db.close();
  });

  test('Gn 1,1 hebrejsky slovo po slově', () async {
    final words = await repo.words(const VerseRef(1, 1, 1), 'B21');
    expect(words.map((w) => w.transliteration).first, 'bereshit');
    expect(words[1].strong, 'H1254');
    final lex = await repo.lexicon('H1254');
    expect(lex?.glossCs, isNull, reason: 'bara není mezi nejčastějšími');
    expect((await repo.lexicon('H1980'))?.glossCs, contains('chodit'));
  }, skip: skip);

  test('číslování žalmů: BKR (KJV) vs. ČEP (hebrejské)', () async {
    // Ž 51: v BKR je verš 1 „Smiluj se…“ (spojený s nadpisem),
    // v hebrejském/českém číslování je to verš 3.
    final bkr = await repo.words(const VerseRef(19, 51, 1), 'BKR');
    final cep = await repo.words(const VerseRef(19, 51, 3), 'CEP');
    expect(bkr.map((w) => w.strong), containsAll(cep.map((w) => w.strong)));
  }, skip: skip);

  test('řecký NZ a souvislosti J 3,16', () async {
    final words = await repo.words(const VerseRef(43, 3, 16), 'B21');
    expect(words.any((w) => w.strong == 'G0025'), isTrue, reason: 'agapaó');
    final xrefs = await repo.crossReferences(const VerseRef(43, 3, 16), 'B21');
    expect(xrefs, isNotEmpty);
    expect(xrefs.any((x) => x.target.bookId == 45), isTrue, reason: 'Římanům');
    final occ = await repo.occurrences('G0025');
    expect(occ.length, greaterThan(100));
    expect(occ.first.bookId, greaterThanOrEqualTo(40));
  }, skip: skip);
}
