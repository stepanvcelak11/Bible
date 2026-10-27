import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';

/// Vzhled obrázku s veršem.
enum VerseCardStyle { night, paper, dawn }

/// Náhled verše jako obrázku (karta 4 : 5, vhodná do zpráv i sociálních
/// sítí) se sdílením obrázku nebo textu.
Future<void> showVerseImageSheet(
  BuildContext context, {
  required String text,
  required String citation,
  required String translation,
  required String plainShareText,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _VerseImageSheet(
    text: text,
    citation: citation,
    translation: translation,
    plainShareText: plainShareText,
  ),
);

class _VerseImageSheet extends StatefulWidget {
  const _VerseImageSheet({
    required this.text,
    required this.citation,
    required this.translation,
    required this.plainShareText,
  });

  final String text;
  final String citation;
  final String translation;
  final String plainShareText;

  @override
  State<_VerseImageSheet> createState() => _VerseImageSheetState();
}

class _VerseImageSheetState extends State<_VerseImageSheet> {
  final _boundary = GlobalKey();
  var _style = VerseCardStyle.night;
  var _busy = false;

  Future<void> _shareImage() async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    setState(() => _busy = true);
    try {
      final boundary =
          _boundary.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      // Karta 360 × 450 → obrázek 1080 × 1350 px.
      final image = await boundary.toImage(
        pixelRatio: 1080 / boundary.size.width,
      );
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              data.buffer.asUint8List(),
              mimeType: 'image/png',
              name: 'vers.png',
            ),
          ],
          fileNameOverrides: ['vers.png'],
          sharePositionOrigin: origin,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _shareText() async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    await SharePlus.instance.share(
      ShareParams(text: widget.plainShareText, sharePositionOrigin: origin),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.paddingOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(S.shareVerse, style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: FittedBox(
                child: RepaintBoundary(
                  key: _boundary,
                  child: VerseCard(
                    style: _style,
                    text: widget.text,
                    citation: widget.citation,
                    translation: widget.translation,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<VerseCardStyle>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: VerseCardStyle.night,
                label: Text(S.cardNight),
              ),
              ButtonSegment(
                value: VerseCardStyle.paper,
                label: Text(S.cardPaper),
              ),
              ButtonSegment(
                value: VerseCardStyle.dawn,
                label: Text(S.cardDawn),
              ),
            ],
            selected: {_style},
            onSelectionChanged: (s) => setState(() => _style = s.single),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _shareText,
                  icon: const Icon(Icons.notes),
                  label: const Text(S.shareAsText),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _busy ? null : _shareImage,
                  icon: const Icon(Icons.image_outlined),
                  label: const Text(S.shareAsImage),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Karta s veršem (360 × 450 logických bodů).
class VerseCard extends StatelessWidget {
  const VerseCard({
    super.key,
    required this.style,
    required this.text,
    required this.citation,
    required this.translation,
  });

  final VerseCardStyle style;
  final String text;
  final String citation;
  final String translation;

  @override
  Widget build(BuildContext context) {
    final (colors, ink, accent) = switch (style) {
      VerseCardStyle.night => (
        const [Color(0xFF1E2238), Color(0xFF3A2C1E), Color(0xFF7A5428)],
        const Color(0xFFFFF6E6),
        const Color(0xFFE2B26A),
      ),
      VerseCardStyle.paper => (
        const [Color(0xFFFBF6EC), Color(0xFFF3E8D2), Color(0xFFE9D9B8)],
        const Color(0xFF2B2622),
        const Color(0xFF9A6A2A),
      ),
      VerseCardStyle.dawn => (
        const [Color(0xFFBFD6EA), Color(0xFFF6D9BC), Color(0xFFF9EBDD)],
        const Color(0xFF2E2A33),
        const Color(0xFFB0603A),
      ),
    };
    // Délka textu určí velikost písma (krátký verš velký, dlouhý menší).
    final len = text.length;
    final size = len < 90
        ? 24.0
        : len < 160
        ? 21.0
        : len < 260
        ? 18.0
        : len < 380
        ? 15.5
        : 13.5;

    return SizedBox(
      width: 360,
      height: 450,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accent.withValues(alpha: 0.35),
                      accent.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 36, 32, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '„',
                    style: TextStyle(
                      fontFamily: appFontFamily,
                      fontSize: 64,
                      height: 0.6,
                      color: accent.withValues(alpha: 0.8),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        text,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontFamily: appFontFamily,
                          fontSize: size,
                          height: 1.45,
                          color: ink,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(width: 36, height: 2, color: accent),
                  const SizedBox(height: 10),
                  Text(
                    citation,
                    style: TextStyle(
                      fontFamily: uiFontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: ink,
                    ),
                  ),
                  Text(
                    translation,
                    style: TextStyle(
                      fontFamily: uiFontFamily,
                      fontSize: 11.5,
                      letterSpacing: 0.4,
                      color: ink.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
