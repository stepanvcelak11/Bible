import 'package:bible_reader/features/reader/presentation/reflection_sheet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uložené zamyšlení: otázky a odpovědi', () {
    const body =
        'Zamyšlení: Genesis 1\n\n'
        'Co mě v kapitole nejvíc oslovilo?\nŽe Bůh tvoří slovem.\n\n'
        'Co s tím udělám?\nPoděkuji.\n\nA zítra znovu.';
    expect(isReflectionNote(body), isTrue);
    expect(isReflectionNote('Moje poznámka'), isFalse);
    expect(parseReflection(body), [
      ('Co mě v kapitole nejvíc oslovilo?', 'Že Bůh tvoří slovem.'),
      ('Co s tím udělám?', 'Poděkuji.\n\nA zítra znovu.'),
    ]);
  });
}
