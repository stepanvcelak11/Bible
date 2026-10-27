import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/domain/services/chapter_navigator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Genesis 50, Exodus 40, … Jóel 3 (BKR), Zjevení 22. Kniha 2 chybí úmyslně.
  const nav = ChapterNavigator({1: 50, 3: 27, 29: 3, 66: 22});

  test('další kapitola v knize i přes hranici knihy', () {
    expect(nav.next(const VerseRef(1, 1, 5)), const VerseRef(1, 2));
    expect(
      nav.next(const VerseRef(1, 50)),
      const VerseRef(3, 1),
      reason: 'chybějící kniha 2 se přeskočí',
    );
    expect(nav.next(const VerseRef(66, 22)), isNull);
  });

  test('předchozí kapitola', () {
    expect(nav.previous(const VerseRef(1, 2)), const VerseRef(1, 1));
    expect(nav.previous(const VerseRef(3, 1)), const VerseRef(1, 50));
    expect(nav.previous(const VerseRef(1, 1)), isNull);
  });

  test('clamp pro kapitolu, která v překladu neexistuje', () {
    expect(nav.clamp(const VerseRef(29, 4, 2)), const VerseRef(29, 3));
    expect(nav.clamp(const VerseRef(29, 2, 7)), const VerseRef(29, 2, 7));
  });

  test('VerseRef encode/decode', () {
    expect(
      VerseRef.tryDecode(const VerseRef(43, 3, 16).encode()),
      const VerseRef(43, 3, 16),
    );
    expect(VerseRef.tryDecode('99:1:1'), isNull);
    expect(VerseRef.tryDecode('x'), isNull);
    expect(VerseRef.tryDecode(null), isNull);
  });
}
