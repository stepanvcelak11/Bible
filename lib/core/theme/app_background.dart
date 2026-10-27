import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/reader_settings.dart';
import '../../features/settings/application/reader_settings_controller.dart';
import 'app_theme.dart';

/// Úprava motivu pro vykreslování pozadí pod obrazovkami: scaffoldy jsou
/// průhledné a každá stránka (route) dostane pod sebe [AppBackground].
/// Lišty jsou průhledné, dokud pod ně neodroluje obsah.
ThemeData withAppBackground(ThemeData theme) {
  final surface = theme.colorScheme.surface;
  final builder = _BackgroundTransitionsBuilder(
    theme.platform == TargetPlatform.iOS ||
            theme.platform == TargetPlatform.macOS
        ? const CupertinoPageTransitionsBuilder()
        : const FadeForwardsPageTransitionsBuilder(),
  );
  return theme.copyWith(
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: theme.appBarTheme.copyWith(
      backgroundColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.scrolledUnder)
            ? surface.withValues(alpha: 0.94)
            : surface.withValues(alpha: 0),
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {for (final p in TargetPlatform.values) p: builder},
    ),
  );
}

class _BackgroundTransitionsBuilder extends PageTransitionsBuilder {
  const _BackgroundTransitionsBuilder(this.inner);

  final PageTransitionsBuilder inner;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => inner.buildTransitions(
    route,
    context,
    animation,
    secondaryAnimation,
    AppBackground(child: child),
  );
}

/// Neprůhledné pozadí stránky podle nastavení (viz [AppBackgroundStyle]).
/// Je pevně za obsahem – neroluje s ním.
class AppBackground extends ConsumerWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = ref.watch(readerSettingsProvider.select((s) => s.background));
    final theme = Theme.of(context);
    return CustomPaint(
      painter: BackdropPainter(
        style: style,
        surface: theme.colorScheme.surface,
        palette: AppPalette.of(context),
        dark: theme.brightness == Brightness.dark,
      ),
      child: child,
    );
  }
}

/// Malíř pozadí; použitý i pro náhledy v nastavení.
class BackdropPainter extends CustomPainter {
  BackdropPainter({
    required this.style,
    required this.surface,
    required this.palette,
    required this.dark,
  });

  final AppBackgroundStyle style;
  final Color surface;
  final AppPalette palette;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = surface);
    switch (style) {
      case AppBackgroundStyle.plain:
        break;
      case AppBackgroundStyle.paper:
        _paper(canvas, rect);
      case AppBackgroundStyle.glow:
        _glow(canvas, rect);
      case AppBackgroundStyle.sky:
        _sky(canvas, rect);
    }
  }

  /// Měkká radiální skvrna světla.
  void _spot(Canvas canvas, Rect rect, Alignment at, double radius, Color c) {
    final center = at.withinRect(rect);
    final r = radius * math.max(rect.width, rect.height);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.radial(
          center,
          r,
          [c, c.withValues(alpha: c.a * 0.45), c.withValues(alpha: 0)],
          const [0, 0.45, 1],
        ),
    );
  }

  void _glow(Canvas canvas, Rect rect) {
    final k = dark ? 0.85 : 1.0;
    _spot(
      canvas,
      rect,
      const Alignment(-1.1, -1.05),
      0.75,
      palette.gold.withValues(alpha: 0.30 * k),
    );
    _spot(
      canvas,
      rect,
      const Alignment(1.15, -0.35),
      0.55,
      (dark ? const Color(0xFFB0605A) : const Color(0xFFE8A99A)).withValues(
        alpha: 0.22 * k,
      ),
    );
    _spot(
      canvas,
      rect,
      const Alignment(-0.4, 1.2),
      0.7,
      (dark ? const Color(0xFF4F6A86) : const Color(0xFF9DBAD3)).withValues(
        alpha: 0.24 * k,
      ),
    );
  }

  void _sky(Canvas canvas, Rect rect) {
    if (dark) {
      // Hvězdná noc: hluboká modř nahoře, pár tlumených hvězd.
      canvas.drawRect(
        rect,
        Paint()
          ..shader = ui.Gradient.linear(
            rect.topCenter,
            rect.bottomCenter,
            [const Color(0xFF16203A), const Color(0xFF141621), surface],
            const [0, 0.45, 0.85],
          ),
      );
      final rnd = math.Random(7);
      final star = Paint();
      final count = (rect.width * rect.height / 9000).clamp(40, 260).round();
      for (var i = 0; i < count; i++) {
        final y = math.pow(rnd.nextDouble(), 1.6) * rect.height * 0.75;
        final x = rnd.nextDouble() * rect.width;
        final fade = 1 - y / (rect.height * 0.75);
        star.color = Colors.white.withValues(
          alpha: (0.15 + rnd.nextDouble() * 0.45) * fade,
        );
        canvas.drawCircle(
          Offset(x, y),
          rnd.nextDouble() < 0.08 ? 1.3 : 0.7,
          star,
        );
      }
      _spot(
        canvas,
        rect,
        const Alignment(0.7, -0.75),
        0.3,
        palette.gold.withValues(alpha: 0.10),
      );
    } else {
      // Svítání: broskvová obloha nahoře přecházející do papíru.
      canvas.drawRect(
        rect,
        Paint()
          ..shader = ui.Gradient.linear(
            rect.topCenter,
            rect.bottomCenter,
            [
              const Color(0xFFC9DCEB).withValues(alpha: 0.75),
              const Color(0xFFF6D9BC).withValues(alpha: 0.8),
              surface,
            ],
            const [0, 0.22, 0.55],
          ),
      );
      _spot(
        canvas,
        rect,
        const Alignment(0.55, -0.62),
        0.42,
        const Color(0xFFFFE2A8).withValues(alpha: 0.55),
      );
    }
  }

  void _paper(Canvas canvas, Rect rect) {
    final grain = _Grain.image(dark);
    if (grain != null) {
      canvas.drawRect(
        rect,
        Paint()
          ..shader = ImageShader(
            grain,
            TileMode.repeated,
            TileMode.repeated,
            Matrix4.identity().storage,
          ),
      );
    }
    // Lehce ztmavlé okraje jako u starého listu.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.radial(
          rect.center,
          rect.longestSide * 0.75,
          [
            Colors.transparent,
            (dark ? Colors.black : const Color(0xFF8A6A3A)).withValues(
              alpha: dark ? 0.35 : 0.10,
            ),
          ],
          const [0.55, 1],
        ),
    );
  }

  @override
  bool shouldRepaint(BackdropPainter old) =>
      old.style != style ||
      old.surface != surface ||
      old.dark != dark ||
      old.palette != palette;
}

/// Dlaždice papírového zrna – vygenerovaná jednou, pak opakovaná.
abstract final class _Grain {
  static final _cache = <bool, ui.Image>{};

  static ui.Image? image(bool dark) {
    final cached = _cache[dark];
    if (cached != null) return cached;
    try {
      const size = 192.0;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final rnd = math.Random(42);
      final light = Paint();
      final shade = Paint();
      for (var i = 0; i < 2600; i++) {
        final p = Offset(rnd.nextDouble() * size, rnd.nextDouble() * size);
        final a = rnd.nextDouble();
        if (rnd.nextBool()) {
          shade.color = (dark ? Colors.black : const Color(0xFF6B5030))
              .withValues(alpha: (dark ? 0.22 : 0.07) * a);
          canvas.drawRect(
            Rect.fromCenter(center: p, width: 1, height: 1),
            shade,
          );
        } else {
          light.color = Colors.white.withValues(
            alpha: (dark ? 0.035 : 0.5) * a,
          );
          canvas.drawRect(
            Rect.fromCenter(center: p, width: 1, height: 1),
            light,
          );
        }
      }
      // Pár delších „vláken“.
      final fiber = Paint()
        ..strokeWidth = 0.6
        ..color = (dark ? Colors.white : const Color(0xFF7A5A30)).withValues(
          alpha: dark ? 0.025 : 0.05,
        );
      for (var i = 0; i < 26; i++) {
        final p = Offset(rnd.nextDouble() * size, rnd.nextDouble() * size);
        final angle = rnd.nextDouble() * math.pi;
        final len = 4 + rnd.nextDouble() * 10;
        canvas.drawLine(
          p,
          p + Offset(math.cos(angle), math.sin(angle)) * len,
          fiber,
        );
      }
      final image = recorder.endRecording().toImageSync(
        size.toInt(),
        size.toInt(),
      );
      return _cache[dark] = image;
    } catch (_) {
      // Bez zrna (např. v testech bez GPU) zůstane čistý papír.
      return null;
    }
  }
}
