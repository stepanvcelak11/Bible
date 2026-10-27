import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/domain/services/citation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('česká citace rozsahů', () {
    expect(Citation.range('Jan', 3, [16]), 'Jan 3,16');
    expect(Citation.range('Jan', 3, [18, 16, 17]), 'Jan 3,16–18');
    expect(Citation.range('Jan', 3, [1, 5, 6, 7, 9]), 'Jan 3,1.5–7.9');
  });

  test('text ke sdílení', () {
    Verse v(int n, String t) =>
        Verse(translationId: 'BKR', ref: VerseRef(43, 3, n), text: t);
    expect(
      Citation.shareText(
        bookName: 'Jan',
        chapter: 3,
        verses: [v(16, 'Nebo tak Bůh miloval svět.')],
        translationAbbreviation: 'BKR',
      ),
      '„Nebo tak Bůh miloval svět.“\n— Jan 3,16 (BKR)',
    );
    expect(
      Citation.shareText(
        bookName: 'Jan',
        chapter: 3,
        verses: [v(17, 'B'), v(16, 'A')],
        translationAbbreviation: 'BKR',
      ),
      'Jan 3,16–17 (BKR)\n16 A\n17 B',
    );
  });
}
