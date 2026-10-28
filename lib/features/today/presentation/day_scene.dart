import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Denní doba pro obrázek v záhlaví.
enum DayTime { dawn, day, dusk, night }

DayTime dayTimeOf(DateTime t) => switch (t.hour) {
  >= 5 && < 10 => DayTime.dawn,
  >= 10 && < 17 => DayTime.day,
  >= 17 && < 21 => DayTime.dusk,
  _ => DayTime.night,
};

/// Malovaná krajina podle denní doby: obloha, slunce nebo měsíc, hvězdy
/// a vrstvy kopců (judské pahorky).
class DayScene extends StatelessWidget {
  const DayScene({super.key, required this.time, required this.dark});

  final DayTime time;
  final bool dark;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _ScenePainter(time, dark), size: Size.infinite);
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.time, this.dark);

  final DayTime time;
  final bool dark;

  // (obloha nahoře, obloha dole, slunce/měsíc, kopce vzadu → vpředu)
  (Color, Color, Color, List<Color>) get _colors => switch (time) {
    DayTime.dawn => (
      const Color(0xFFF6C99A),
      const Color(0xFFFBE9D3),
      const Color(0xFFFFF4DC),
      const [Color(0xFFE9B98C), Color(0xFFD7996A), Color(0xFFBF7D52)],
    ),
    DayTime.day => (
      const Color(0xFFBFD9EA),
      const Color(0xFFF4ECDD),
      const Color(0xFFFFF8E6),
      const [Color(0xFFCFC3A2), Color(0xFFB7A57D), Color(0xFF9C8A5F)],
    ),
    DayTime.dusk => (
      const Color(0xFF8A5C7E),
      const Color(0xFFF0A86C),
      const Color(0xFFFFD9A0),
      const [Color(0xFFB0705E), Color(0xFF7E4C52), Color(0xFF55354A)],
    ),
    DayTime.night => (
      const Color(0xFF141A33),
      const Color(0xFF3A3558),
      const Color(0xFFF3EBD3),
      const [Color(0xFF2E2B47), Color(0xFF221F38), Color(0xFF17152A)],
    ),
  };

  Color _dim(Color c) =>
      dark ? Color.lerp(c, const Color(0xFF14110E), 0.45)! : c;

  @override
  void paint(Canvas canvas, Size size) {
    final (top, bottom, orb, hills) = _colors;
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_dim(top), _dim(bottom)],
        ).createShader(rect),
    );

    // Hvězdy v noci a za soumraku (pevně rozmístěné, ne náhodné při
    // každém překreslení).
    if (time == DayTime.night || time == DayTime.dusk) {
      final rnd = math.Random(7);
      final star = Paint()..color = Colors.white;
      for (var i = 0; i < 46; i++) {
        final p = Offset(
          rnd.nextDouble() * size.width,
          rnd.nextDouble() * size.height * 0.55,
        );
        star.color = Colors.white.withValues(
          alpha: (time == DayTime.night ? 0.5 : 0.25) + rnd.nextDouble() * 0.4,
        );
        canvas.drawCircle(p, 0.6 + rnd.nextDouble() * 1.1, star);
      }
    }

    // Slunce / měsíc se září.
    final center = Offset(
      size.width * (time == DayTime.dawn ? 0.22 : 0.78),
      size.height * (time == DayTime.day ? 0.28 : 0.42),
    );
    final radius = size.height * 0.11;
    canvas.drawCircle(
      center,
      radius * 3.2,
      Paint()
        ..shader = RadialGradient(
          colors: [orb.withValues(alpha: 0.55), orb.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 3.2)),
    );
    canvas.drawCircle(center, radius, Paint()..color = orb);
    if (time == DayTime.night) {
      // Srpek: zakryjeme část měsíce barvou oblohy.
      canvas.drawCircle(
        center + Offset(radius * 0.45, -radius * 0.2),
        radius * 0.9,
        Paint()..color = _dim(top),
      );
    }

    // Tři vrstvy pahorků.
    for (final (i, c) in hills.indexed) {
      final base = size.height * (0.62 + i * 0.12);
      final amp = size.height * (0.09 - i * 0.015);
      final path = Path()..moveTo(0, size.height);
      for (var x = 0.0; x <= size.width; x += 6) {
        final t = x / size.width;
        final y =
            base -
            amp * math.sin(t * math.pi * (1.4 + i * 0.6) + i * 1.7) -
            amp * 0.4 * math.sin(t * math.pi * 5 + i);
        path.lineTo(x, y);
      }
      path
        ..lineTo(size.width, size.height)
        ..close();
      canvas.drawPath(path, Paint()..color = _dim(c));
    }
  }

  @override
  bool shouldRepaint(_ScenePainter old) => old.time != time || old.dark != dark;
}
