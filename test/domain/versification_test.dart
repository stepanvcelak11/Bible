import 'package:bible_reader/data/repositories/bible_repository_impl.dart';
import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/domain/services/versification.dart';
import 'package:flutter_test/flutter_test.dart';

VerseRef bkrToCep(int b, int c, int v) =>
    Versification.between(VerseRef(b, c, v), 'BKR', 'CEP');
VerseRef cepToBkr(int b, int c, int v) =>
    Versification.between(VerseRef(b, c, v), 'CEP', 'BKR');

void main() {
  test('jen Kralická čísluje anglicky', () {
    expect(schemeOf('BKR'), VerseScheme.english);
    for (final id in ['CEP', 'B21', 'CSP']) {
      expect(schemeOf(id), VerseScheme.hebrew);
    }
  });

  test('žalmy s nadpisem: „Stvoř mi čisté srdce“ je BKR 51,10 = ČEP 51,12', () {
    expect(bkrToCep(19, 51, 10), const VerseRef(19, 51, 12));
    expect(cepToBkr(19, 51, 12), const VerseRef(19, 51, 10));
    // Nadpis (ČEP v. 1–2) je v Kralické součástí verše 1.
    expect(cepToBkr(19, 51, 1), const VerseRef(19, 51, 1));
    expect(cepToBkr(19, 51, 2), const VerseRef(19, 51, 1));
  });

  test('Jóel, Malachiáš: jiné dělení kapitol', () {
    // „Vyleji svého ducha na všechny lidi“
    expect(bkrToCep(29, 2, 28), const VerseRef(29, 3, 1));
    expect(bkrToCep(29, 3, 1), const VerseRef(29, 4, 1));
    // „Slunce spravedlnosti“
    expect(bkrToCep(39, 4, 2), const VerseRef(39, 3, 20));
    expect(cepToBkr(39, 3, 20), const VerseRef(39, 4, 2));
  });

  test('Izajáš 9 a Daniel 6', () {
    // „Dítě se nám narodilo“
    expect(bkrToCep(23, 9, 6), const VerseRef(23, 9, 5));
    // „Můj Bůh poslal svého anděla“
    expect(bkrToCep(27, 6, 22), const VerseRef(27, 6, 23));
  });

  test('Nový zákon: 2K 13 a Zj 12,18', () {
    expect(bkrToCep(47, 13, 14), const VerseRef(47, 13, 13));
    expect(cepToBkr(66, 12, 18), const VerseRef(66, 13, 1));
    expect(cepToBkr(64, 1, 15), const VerseRef(64, 1, 14));
  });

  test('beze změny tam, kde se číslování shoduje', () {
    for (final r in const [
      VerseRef(43, 3, 16),
      VerseRef(1, 1, 1),
      VerseRef(19, 23, 1),
    ]) {
      expect(Versification.between(r, 'BKR', 'CEP'), r);
      expect(Versification.between(r, 'CEP', 'B21'), r);
    }
  });

  test('převod tam a zpět vrací stejný verš (mimo nadpisy)', () {
    for (final (b, c) in const [(19, 51), (29, 2), (39, 4), (23, 9)]) {
      for (var v = 1; v <= 15; v++) {
        final r = VerseRef(b, c, v);
        final there = Versification.between(r, 'BKR', 'CEP');
        expect(Versification.between(there, 'CEP', 'BKR'), r, reason: '$r');
      }
    }
  });

  test('porovnání BKR × ČEP zarovná verše podle obsahu', () {
    Verse v(String t, int c, int n) =>
        Verse(translationId: t, ref: VerseRef(19, c, n), text: '$t$c:$n');
    final bkr = [for (var n = 1; n <= 3; n++) v('BKR', 51, n)];
    final cep = [for (var n = 1; n <= 5; n++) v('CEP', 51, n)];
    final rows = BibleRepositoryImpl.alignByScheme(
      bkr,
      cep,
      51,
      VerseScheme.hebrew,
      VerseScheme.english,
    );
    expect(rows.first.number, 1);
    expect(rows.first.secondary!.text, 'CEP51:1 CEP51:2 CEP51:3');
    expect(rows.first.secondaryLabel, '1–3');
    expect(rows[1].secondary!.text, 'CEP51:4');
    expect(rows[1].secondaryLabel, '4');
  });
}
