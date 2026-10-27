import 'package:bible_reader/data/repositories/user_data_repository_impl.dart';
import 'package:bible_reader/data/user/user_database.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/domain/entities/user_entities.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UserDatabase db;
  late UserDataRepositoryImpl repo;
  const john316 = VerseRef(43, 3, 16);

  setUp(() {
    db = UserDatabase(NativeDatabase.memory());
    repo = UserDataRepositoryImpl(db);
  });
  tearDown(() => db.close());

  test('zvýraznění: vložení, změna barvy, odstranění', () async {
    await repo.setHighlight(john316, HighlightColor.yellow);
    await repo.setHighlight(john316, HighlightColor.blue);
    var list = await repo.watchHighlightsInChapter(43, 3).first;
    expect(list.single.color, HighlightColor.blue);

    await repo.setHighlight(john316, null);
    list = await repo.watchHighlightsInChapter(43, 3).first;
    expect(list, isEmpty);
  });

  test('záložka se přepíná', () async {
    expect(await repo.toggleBookmark(john316, translationId: 'BKR'), isTrue);
    expect((await repo.watchAllBookmarks().first).single.translationId, 'BKR');
    expect(await repo.toggleBookmark(john316), isFalse);
    expect(await repo.watchAllBookmarks().first, isEmpty);
  });

  test('poznámka: vytvoření, úprava, smazání', () async {
    final id = await repo.saveNote(ref: john316, verseEnd: 17, body: 'Láska');
    await repo.saveNote(id: id, ref: john316, body: 'Boží láska');
    final note = (await repo.watchNotesInChapter(43, 3).first).single;
    expect(note.body, 'Boží láska');
    expect(note.verseEnd, 16);

    await repo.deleteNote(id);
    expect(await repo.watchAllNotes().first, isEmpty);
  });
}
