import 'package:bible_reader/core/widgets/drop_cap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

String _plain(List<InlineSpan> spans) =>
    spans.map((s) => s is TextSpan ? s.text ?? '' : '[w]').join();

void main() {
  test('iniciála i s úvodní interpunkcí', () {
    expect(splitInitial('Na počátku'), ('N', 'a počátku'));
    expect(splitInitial('„Amen,“ řekl'), ('„A', 'men,“ řekl'));
    expect(splitInitial('…'), isNull);
  });

  test('rozdělení spanů zachová styl, text i ikony', () {
    const bold = TextStyle(fontWeight: FontWeight.bold);
    final spans = <InlineSpan>[
      const TextSpan(
        text: 'ab',
        style: bold,
        children: [TextSpan(text: 'cd')],
      ),
      const TextSpan(text: ' ef'),
      const WidgetSpan(child: SizedBox()),
      const TextSpan(text: 'gh'),
    ];
    final (head, tail) = splitSpans(spans, 3);
    expect(_plain(head), 'abc');
    expect(_plain(tail), 'd ef[w]gh');
    // Vnořený span zdědí tučné písmo rodiče.
    expect((head[1] as TextSpan).style?.fontWeight, FontWeight.bold);
    expect((tail.first as TextSpan).style?.fontWeight, FontWeight.bold);

    // Mezera na začátku pokračování se odstraní; ikona = 2 znaky.
    final (h2, t2) = splitSpans(spans, 4);
    expect(_plain(h2), 'abcd');
    expect(_plain(t2), 'ef[w]gh');
    final (h3, t3) = splitSpans(spans, 9);
    expect(_plain(h3), 'abcd ef[w]');
    expect(_plain(t3), 'gh');
  });
}
