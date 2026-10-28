import 'package:flutter/material.dart';

final _leading = RegExp(r'^[^\p{L}\p{N}]*[\p{L}\p{N}]', unicode: true);

/// Rozdělí text na iniciálu (první písmeno i s úvodní interpunkcí, např.
/// „„A“) a zbytek. Vrací `null`, když text žádné písmeno nemá.
(String, String)? splitInitial(String text) {
  final m = _leading.firstMatch(text);
  if (m == null) return null;
  return (m.group(0)!, text.substring(m.end));
}

/// Odstavec s ozdobnou iniciálou přes dva řádky, jako v tištěné Bibli.
/// Text kolem iniciály skutečně obtéká: první dva řádky jsou užší,
/// zbytek pokračuje v plné šíři.
class DropCapText extends StatelessWidget {
  const DropCapText({
    super.key,
    required this.initial,
    required this.spans,
    required this.style,
    required this.color,
    this.onInitialTap,
  });

  final String initial;

  /// Text za iniciálou.
  final List<InlineSpan> spans;

  /// Úplný styl textu (velikost písma a výška řádku).
  final TextStyle style;
  final Color color;
  final VoidCallback? onInitialTap;

  static const _lines = 2;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final fontSize = style.fontSize ?? 16;
    final lineHeight = fontSize * (style.height ?? 1.4);
    // Verzálka zabírá zhruba 0,7 velikosti písma: od horní hrany prvního
    // řádku po účaří druhého.
    final capStyle = style.copyWith(
      fontSize: (lineHeight * (_lines - 1) + fontSize * 0.8) / 0.7,
      height: 1,
      color: color,
      fontWeight: FontWeight.w600,
      backgroundColor: Colors.transparent,
      letterSpacing: 0,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final cap = TextPainter(
          text: TextSpan(text: initial, style: capStyle),
          textDirection: TextDirection.ltr,
          textScaler: scaler,
        )..layout();
        final capWidth = cap.width + fontSize * 0.35;
        final narrow = constraints.maxWidth - capWidth;
        final measure = TextPainter(
          text: TextSpan(style: style, children: _measurable(spans)),
          textDirection: TextDirection.ltr,
          textScaler: scaler,
        )..layout(maxWidth: narrow);
        final lines = measure.computeLineMetrics();
        final capBaseline = cap.computeDistanceToActualBaseline(
          TextBaseline.alphabetic,
        );
        // Účaří druhého řádku – i když má text jen jeden řádek.
        final baselineLine = lines.isEmpty
            ? lineHeight
            : lines.length >= _lines
            ? lines[_lines - 1].baseline
            : lines.first.baseline + lines.first.height;
        final capTop = baselineLine - capBaseline;
        final minHeight =
            baselineLine + (lines.isEmpty ? 0 : lines.first.descent);
        measure.dispose();

        Widget capWidget = Text(initial, style: capStyle, textScaler: scaler);
        if (onInitialTap case final tap?) {
          capWidget = GestureDetector(onTap: tap, child: capWidget);
        }
        // Iniciála nezvětšuje výšku řádků – visí přes ně.
        Widget withCap(List<InlineSpan> head) => Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(left: capWidth),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: minHeight,
                  minWidth: double.infinity,
                ),
                child: Text.rich(TextSpan(children: head), style: style),
              ),
            ),
            Positioned(left: 0, top: capTop, child: capWidget),
          ],
        );

        if (lines.length <= _lines) return withCap(spans);
        // Začátek třetího řádku v užší sazbě = místo, kde se text rozdělí.
        final third = lines[_lines];
        final split = _positionAt(
          spans,
          style,
          scaler,
          narrow,
          Offset(0, third.baseline - third.ascent + 1),
        );
        final (head, tail) = splitSpans(spans, split);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            withCap(head),
            Text.rich(TextSpan(children: tail), style: style),
          ],
        );
      },
    );
  }

  static int _positionAt(
    List<InlineSpan> spans,
    TextStyle style,
    TextScaler scaler,
    double width,
    Offset offset,
  ) {
    final p = TextPainter(
      text: TextSpan(style: style, children: _measurable(spans)),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
    )..layout(maxWidth: width);
    final pos = p.getPositionForOffset(offset).offset;
    p.dispose();
    return pos;
  }
}

/// Délka vložených prvků (ikon) při měření – nahrazují se dvěma mezerami.
const _widgetPlaceholder = '  ';

/// Spany pro TextPainter: ikony (WidgetSpan) nahradí mezerami, aby šly
/// změřit bez rozměrů zástupných prvků.
List<InlineSpan> _measurable(List<InlineSpan> spans) => [
  for (final s in spans)
    if (s is WidgetSpan)
      const TextSpan(text: _widgetPlaceholder)
    else if (s is TextSpan)
      TextSpan(
        text: s.text,
        style: s.style,
        children: s.children == null ? null : _measurable(s.children!),
      ),
];

/// Rozdělí spany na dvě části na pozici [offset] (v měřeném textu, kde
/// ikona zabírá dva znaky). Styly i rozpoznávače klepnutí zůstanou.
(List<InlineSpan>, List<InlineSpan>) splitSpans(
  List<InlineSpan> spans,
  int offset,
) {
  final head = <InlineSpan>[];
  final tail = <InlineSpan>[];
  var pos = 0;

  void visit(InlineSpan s, TextStyle? inherited) {
    if (s is WidgetSpan) {
      (pos < offset ? head : tail).add(s);
      pos += _widgetPlaceholder.length;
      return;
    }
    if (s is! TextSpan) return;
    final style = inherited?.merge(s.style) ?? s.style;
    final text = s.text;
    if (text != null && text.isNotEmpty) {
      final rec = s.recognizer;
      if (pos + text.length <= offset) {
        head.add(TextSpan(text: text, style: style, recognizer: rec));
      } else if (pos >= offset) {
        tail.add(TextSpan(text: text, style: style, recognizer: rec));
      } else {
        final cut = offset - pos;
        head.add(
          TextSpan(text: text.substring(0, cut), style: style, recognizer: rec),
        );
        tail.add(
          TextSpan(text: text.substring(cut), style: style, recognizer: rec),
        );
      }
      pos += text.length;
    }
    for (final c in s.children ?? const <InlineSpan>[]) {
      visit(c, style);
    }
  }

  for (final s in spans) {
    visit(s, null);
  }
  // Mezera na začátku pokračování by odsadila první řádek.
  if (tail.firstOrNull
      case TextSpan(:final text?, :final style, :final recognizer)
      when text.startsWith(' ')) {
    tail[0] = TextSpan(
      text: text.trimLeft(),
      style: style,
      recognizer: recognizer,
    );
  }
  return (head, tail);
}
