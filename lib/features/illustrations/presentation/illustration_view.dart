import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../application/illustrations.dart';

/// Kresba vykreslená tenkou „perokresbou“ v barvě textu.
class SketchPainter extends CustomPainter {
  SketchPainter(this.illustration, this.color, {this.strokeWidth = 1.5});

  final Illustration illustration;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / illustration.width;
    canvas.scale(k);
    canvas.drawPath(
      illustration.path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = strokeWidth / k
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(SketchPainter old) =>
      old.illustration != illustration || old.color != color;
}

/// Kresba s popiskem v textu Bible (jako v tištěné ilustrované Bibli).
/// Klepnutí ji otevře zvětšenou.
class IllustrationView extends StatelessWidget {
  const IllustrationView({
    super.key,
    required this.illustration,
    required this.caption,
    required this.reference,
    this.fontSize = 19,
  });

  final Illustration illustration;

  /// Popisek – text verše v překladu, který čtenář právě čte.
  final String caption;

  /// Krátký odkaz k popisku, např. „14,46“.
  final String reference;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final colors = ReaderColors.of(context);
    final palette = AppPalette.of(context);
    return Semantics(
      image: true,
      label: caption,
      child: GestureDetector(
        onTap: () => _open(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 18, 6, 14),
          child: LayoutBuilder(
            builder: (context, c) {
              // Přirozená velikost ~ 300 px na šířku scény, ne přes sloupec.
              final natural = illustration.width * 0.62;
              final w = natural.clamp(0.0, c.maxWidth).toDouble();
              return Column(
                children: [
                  SizedBox(
                    width: w,
                    height: w * illustration.height / illustration.width,
                    child: CustomPaint(
                      painter: SketchPainter(
                        illustration,
                        colors.text.withValues(alpha: 0.82),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$caption ($reference)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: appFontFamily,
                      fontStyle: FontStyle.italic,
                      fontSize: fontSize * 0.68,
                      height: 1.3,
                      color: palette.gold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context) {
    final colors = ReaderColors.of(context);
    final palette = AppPalette.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: illustration.width / illustration.height,
                  child: CustomPaint(
                    painter: SketchPainter(
                      illustration,
                      colors.text.withValues(alpha: 0.88),
                      strokeWidth: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '$caption ($reference)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: appFontFamily,
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: palette.gold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
