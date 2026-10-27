import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/features/search/application/reference_parser.dart';
import 'package:flutter_test/flutter_test.dart';

const _names = [
  ('Gen', 'Genesis', 'Gn'),
  ('Exod', 'Exodus', 'Ex'),
  ('Lev', 'Leviticus', 'Lv'),
  ('Num', 'Numeri', 'Nu'),
  ('Deut', 'Deuteronomium', 'Dt'),
  ('Josh', 'Jozue', 'Joz'),
  ('Judg', 'Soudců', 'Sd'),
  ('Ruth', 'Rút', 'Rt'),
  ('1Sam', '1. Samuelova', '1S'),
  ('2Sam', '2. Samuelova', '2S'),
  ('1Kgs', '1. Královská', '1Kr'),
  ('2Kgs', '2. Královská', '2Kr'),
  ('1Chr', '1. Paralipomenon', '1Pa'),
  ('2Chr', '2. Paralipomenon', '2Pa'),
  ('Ezra', 'Ezdráš', 'Ezd'),
  ('Neh', 'Nehemjáš', 'Neh'),
  ('Esth', 'Ester', 'Est'),
  ('Job', 'Jób', 'Jb'),
  ('Ps', 'Žalmy', 'Ž'),
  ('Prov', 'Přísloví', 'Př'),
];

void main() {
  final books = [
    for (var i = 1; i <= 66; i++)
      if (i <= _names.length)
        Book(
          id: i,
          osis: _names[i - 1].$1,
          name: _names[i - 1].$2,
          abbreviation: _names[i - 1].$3,
          testament: Testament.oldTestament,
        )
      else
        Book(
          id: i,
          osis: 'B$i',
          name: switch (i) {
            43 => 'Jan',
            46 => '1. Korintským',
            62 => '1. Janův',
            64 => '3. Janův',
            40 => 'Matouš',
            _ => 'Kniha $i',
          },
          abbreviation: switch (i) {
            43 => 'J',
            46 => '1K',
            40 => 'Mt',
            62 => '1J',
            64 => '3J',
            _ => 'K$i',
          },
          testament: i < 40 ? Testament.oldTestament : Testament.newTestament,
        ),
  ];

  test('odkazy v různých zápisech', () {
    expect(parseReference('J 3,16', books), const VerseRef(43, 3, 16));
    expect(parseReference('jan 3:16', books), const VerseRef(43, 3, 16));
    expect(parseReference('1 Kor 13', books), const VerseRef(46, 13, 1));
    expect(parseReference('1kor13,4', books), const VerseRef(46, 13, 4));
    expect(parseReference('Žalm 23', books), const VerseRef(19, 23, 1));
    expect(
      parseReference('zalmy 119,105', books),
      const VerseRef(19, 119, 105),
    );
    expect(parseReference('gn1', books), const VerseRef(1, 1, 1));
    expect(parseReference('3 Jan 2', books), const VerseRef(64, 2, 1));
    expect(parseReference('Mt 5,3', books), const VerseRef(40, 5, 3));
  });

  test('běžná slova nejsou odkaz', () {
    expect(parseReference('láska', books), isNull);
    expect(parseReference('chléb života', books), isNull);
    expect(parseReference('Jan', books), isNull, reason: 'bez kapitoly');
  });

  test('hledání knihy', () {
    expect(bookMatches(books[18], foldCzech('žalm')), isTrue);
    expect(bookMatches(books[45], foldCzech('1kor')), isTrue);
    expect(bookMatches(books[0], foldCzech('exo')), isFalse);
  });
}
