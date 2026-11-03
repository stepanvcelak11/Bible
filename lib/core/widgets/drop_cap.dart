import 'dart:math' as math;

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
    this.ornament,
    this.accent,
  });

  final String initial;

  /// Text za iniciálou.
  final List<InlineSpan> spans;

  /// Úplný styl textu (velikost písma a výška řádku).
  final TextStyle style;
  final Color color;
  final VoidCallback? onInitialTap;

  /// Zdobená iniciála (jako v rukopisech): vzor rámečku podle druhu knihy
  /// (viz [IlluminatedCapPainter]). `null` = jen velké písmeno.
  final int? ornament;

  /// Barva rámečku zdobené iniciály (barva skupiny knih).
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    // Za iniciálou v rámečku nesmí zůstat mezera („V| těch dnech“).
    final spans = ornament == null ? this.spans : _trimStart(this.spans);
    final scaler = MediaQuery.textScalerOf(context);
    final fontSize = style.fontSize ?? 16;
    final lineHeight = fontSize * (style.height ?? 1.4);
    final ornate = ornament != null;
    final lines_ = ornate ? 3 : 2;
    // Zdobená iniciála: čtverec přes tři řádky, písmeno uvnitř.
    final box = ornate
        ? scaler.scale(lineHeight * (lines_ - 1) + fontSize * 0.95)
        : 0.0;
    // Verzálka zabírá zhruba 0,7 velikosti písma: od horní hrany prvního
    // řádku po účaří druhého.
    final capStyle = style.copyWith(
      fontSize: ornate
          ? box * 0.62 / scaler.scale(1)
          : (lineHeight * (lines_ - 1) + fontSize * 0.8) / 0.7,
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
        final capWidth = ornate
            ? box + fontSize * 0.5
            : cap.width + fontSize * 0.35;
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
        final lineH = lines.isEmpty
            ? scaler.scale(lineHeight)
            : lines.first.height;
        final baselineLine = lines.isEmpty
            ? lineHeight
            : lines.length >= lines_
            ? lines[lines_ - 1].baseline
            : lines.first.baseline + lineH * (lines_ - 1);
        final firstTop = lines.isEmpty
            ? 0.0
            : lines.first.baseline - lines.first.ascent;
        final capTop = ornate ? firstTop + 1 : baselineLine - capBaseline;
        final minHeight = ornate
            ? capTop + box + fontSize * 0.2
            : baselineLine + (lines.isEmpty ? 0 : lines.first.descent);
        measure.dispose();

        Widget capWidget = Text(initial, style: capStyle, textScaler: scaler);
        if (ornate) {
          capWidget = _AnimatedCap(
            child: CustomPaint(
              painter: IlluminatedCapPainter(
                variant: ornament!,
                accent: accent ?? color,
                gold: color,
              ),
              child: SizedBox.square(
                dimension: box,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: box * 0.04),
                    child: Text(
                      initial.trim(),
                      style: capStyle,
                      textScaler: scaler,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
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

        if (lines.length <= lines_) return withCap(spans);
        // Začátek řádku pod iniciálou v užší sazbě = místo, kde se text
        // rozdělí.
        final third = lines[lines_];
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

/// Odstraní mezery na začátku textu (i ve vnořených spanech).
List<InlineSpan> _trimStart(List<InlineSpan> spans) {
  final out = [...spans];
  for (var i = 0; i < out.length; i++) {
    final s = out[i];
    if (s is! TextSpan) return out;
    final text = s.text?.trimLeft();
    final children = text == null || text.isEmpty
        ? (s.children == null ? null : _trimStart(s.children!))
        : s.children;
    out[i] = TextSpan(
      text: text == null || text.isEmpty ? null : text,
      style: s.style,
      recognizer: s.recognizer,
      children: children,
    );
    if (text != null && text.isNotEmpty) return out;
    if (s.children?.isNotEmpty ?? false) return out;
  }
  return out;
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

/// Iniciála se při otevření kapitoly jemně objeví a zlatě zasvítí.
class _AnimatedCap extends StatelessWidget {
  const _AnimatedCap({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.scale(scale: 0.92 + 0.08 * t, child: child),
      ),
    );
  }
}

/// Rámeček zdobené iniciály. Vzor podle skupiny knih (index do
/// `bookCategories`): Zákon – desky, dějiny – úponky, poezie – květy,
/// proroci – paprsky, evangelia – kříže, Skutky – plaménky, listy – svitky,
/// Zjevení – hvězdy. Vlastní kresba aplikace.
class IlluminatedCapPainter extends CustomPainter {
  IlluminatedCapPainter({
    required this.variant,
    required this.accent,
    required this.gold,
  });

  final int variant;
  final Color accent;
  final Color gold;

  @override
  void paint(Canvas canvas, Size size) {
    final r = Offset.zero & size;
    final u = size.width / 14; // jednotka vzoru
    final rr = RRect.fromRectAndRadius(r, Radius.circular(u * 1.6));
    // Podklad: jemný přechod barvy knihy.
    canvas.drawRRect(
      rr,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.20),
            accent.withValues(alpha: 0.07),
          ],
        ).createShader(r),
    );
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1, u * 0.22)
      ..color = gold.withValues(alpha: 0.85);
    final thin = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.6, u * 0.1)
      ..color = accent.withValues(alpha: 0.7);
    final fill = Paint()..color = gold.withValues(alpha: 0.85);
    final soft = Paint()..color = accent.withValues(alpha: 0.55);
    canvas.drawRRect(rr.deflate(u * 0.25), line);
    canvas.drawRRect(rr.deflate(u * 0.85), thin);

    final k = u * 1.7;
    final corners = [
      Offset(k, k),
      Offset(size.width - k, k),
      Offset(k, size.height - k),
      Offset(size.width - k, size.height - k),
    ];
    switch (variant) {
      case 0: // Zákon: malé desky
        for (final c in corners) {
          final t = Rect.fromCenter(center: c, width: u * 1.4, height: u * 1.8);
          canvas.drawRRect(
            RRect.fromRectAndCorners(
              t,
              topLeft: Radius.circular(u * 0.7),
              topRight: Radius.circular(u * 0.7),
            ),
            fill,
          );
        }
      case 1: // dějiny: úponky s lístky
        for (final c in corners) {
          final dx = c.dx < size.width / 2 ? 1.0 : -1.0;
          final dy = c.dy < size.height / 2 ? 1.0 : -1.0;
          final path = Path()
            ..moveTo(c.dx - dx * u * 0.6, c.dy - dy * u * 0.6)
            ..quadraticBezierTo(
              c.dx + dx * u * 2.4,
              c.dy - dy * u * 0.4,
              c.dx + dx * u * 3.2,
              c.dy + dy * u * 1.2,
            );
          canvas.drawPath(path, thin..strokeWidth = math.max(0.8, u * 0.18));
          _leaf(canvas, c + Offset(dx * u * 1.6, -dy * u * 0.1), u, dx, soft);
          _leaf(canvas, c + Offset(dx * u * 0.2, dy * u * 1.4), u, dx, soft);
        }
      case 2: // poezie: květy
        for (final c in corners) {
          for (var i = 0; i < 5; i++) {
            final a = i * 2 * math.pi / 5 - math.pi / 2;
            canvas.drawCircle(
              c + Offset(math.cos(a), math.sin(a)) * u * 0.7,
              u * 0.5,
              soft,
            );
          }
          canvas.drawCircle(c, u * 0.4, fill);
        }
      case 3 || 4: // proroci: paprsky z rohů
        for (final c in corners) {
          final dx = c.dx < size.width / 2 ? 1.0 : -1.0;
          final dy = c.dy < size.height / 2 ? 1.0 : -1.0;
          for (var i = 0; i < 4; i++) {
            final a = i * math.pi / 6 + math.pi / 12;
            final dir = Offset(math.cos(a) * dx, math.sin(a) * dy);
            canvas.drawLine(
              c - Offset(dx, dy) * u * 0.4 + dir * u * 0.3,
              c - Offset(dx, dy) * u * 0.4 + dir * u * (i.isEven ? 2.4 : 1.6),
              line,
            );
          }
        }
      case 5: // evangelia: kříže a perlička
        for (final c in corners) {
          canvas.drawRect(
            Rect.fromCenter(center: c, width: u * 0.45, height: u * 1.7),
            fill,
          );
          canvas.drawRect(
            Rect.fromCenter(
              center: c - Offset(0, u * 0.25),
              width: u * 1.2,
              height: u * 0.45,
            ),
            fill,
          );
        }
        for (var i = 1; i < 4; i++) {
          final x = k + (size.width - 2 * k) * i / 4;
          canvas.drawCircle(Offset(x, u * 0.55), u * 0.18, soft);
          canvas.drawCircle(Offset(x, size.height - u * 0.55), u * 0.18, soft);
        }
      case 6: // Skutky: plaménky
        for (final c in corners) {
          final p = Path()
            ..moveTo(c.dx, c.dy - u * 1.2)
            ..quadraticBezierTo(c.dx + u * 1.0, c.dy, c.dx, c.dy + u * 0.8)
            ..quadraticBezierTo(c.dx - u * 1.0, c.dy, c.dx, c.dy - u * 1.2)
            ..close();
          canvas.drawPath(p, fill);
        }
      case 7 || 8: // listy: svitky
        for (final c in corners) {
          canvas.drawArc(
            Rect.fromCircle(center: c, radius: u * 0.9),
            0,
            math.pi * 1.6,
            false,
            line,
          );
          canvas.drawCircle(c, u * 0.3, fill);
        }
      default: // Zjevení: hvězdy
        for (final c in corners) {
          final p = Path();
          for (var i = 0; i < 10; i++) {
            final a = i * math.pi / 5 - math.pi / 2;
            final rad = i.isEven ? u * 1.1 : u * 0.45;
            final o = c + Offset(math.cos(a), math.sin(a)) * rad;
            i == 0 ? p.moveTo(o.dx, o.dy) : p.lineTo(o.dx, o.dy);
          }
          canvas.drawPath(p..close(), fill);
        }
    }
  }

  static void _leaf(Canvas canvas, Offset c, double u, double dx, Paint p) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(dx * 0.6);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: u * 1.2, height: u * 0.6),
      p,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(IlluminatedCapPainter old) =>
      old.variant != variant || old.accent != accent || old.gold != gold;
}
