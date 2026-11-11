import 'package:bible_reader/features/reader/application/glossary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<String> titles(String t, {int book = 40}) => [
    for (final e in glossaryFor(t, bookId: book)) e.title,
  ];

  test('rozpozná mince, míry a skupiny', () {
    expect(titles('smluviv s dělníky po denáru na den'), ['Denár']);
    expect(titles('Ukažte mi peníz daně.'), ['Denár (peníz)']);
    expect(titles('A farizeové a zákoníci reptali'), ['Farizeové', 'Zákoníci']);
    expect(titles('šest loket a píď', book: 9), ['Loket', 'Píď']);
  });

  test('bez falešných shod', () {
    expect(titles('mezi Sukkot a Sartanem', book: 6), isEmpty);
    expect(titles('zvěř polní a ptactvo', book: 1), isEmpty);
    // „peníz“ ve Starém zákoně není denár.
    expect(titles('pro peníz stříbrný', book: 9), isEmpty);
  });
}
