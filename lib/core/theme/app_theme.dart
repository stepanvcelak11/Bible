import 'package:flutter/material.dart';

import '../../domain/entities/reader_settings.dart';
import '../../domain/entities/user_entities.dart';

/// Přibalené písmo – funguje offline i na webu.
const appFontFamily = 'Literata';

/// Barvy specifické pro čtení (doplněk k ColorScheme), dostupné přes
/// `Theme.of(context).extension<ReaderColors>()`.
@immutable
class ReaderColors extends ThemeExtension<ReaderColors> {
  const ReaderColors({
    required this.text,
    required this.verseNumber,
    required this.selection,
    required this.flash,
    required this.highlights,
  });

  final Color text;
  final Color verseNumber;
  final Color selection;

  /// Krátké zvýraznění verše po skoku z hledání / záložky.
  final Color flash;
  final Map<HighlightColor, Color> highlights;

  static ReaderColors of(BuildContext context) =>
      Theme.of(context).extension<ReaderColors>()!;

  @override
  ReaderColors copyWith() => this;

  @override
  ReaderColors lerp(ReaderColors? other, double t) {
    if (other == null) return this;
    return ReaderColors(
      text: Color.lerp(text, other.text, t)!,
      verseNumber: Color.lerp(verseNumber, other.verseNumber, t)!,
      selection: Color.lerp(selection, other.selection, t)!,
      flash: Color.lerp(flash, other.flash, t)!,
      highlights: {
        for (final c in HighlightColor.values)
          c: Color.lerp(highlights[c], other.highlights[c], t)!,
      },
    );
  }
}

/// Plné (syté) barvy zvýraznění pro výběr barvy v panelu.
const highlightSwatches = {
  HighlightColor.yellow: Color(0xFFF2C94C),
  HighlightColor.green: Color(0xFF7BC47F),
  HighlightColor.blue: Color(0xFF6FA8DC),
  HighlightColor.pink: Color(0xFFE88BA6),
  HighlightColor.purple: Color(0xFFB39DDB),
};

/// Tři motivy čtečky: světlý, teplá sépie a tmavý.
abstract final class AppTheme {
  static const _accent = Color(0xFF6B5B45);

  static ThemeData light() => _build(
    ColorScheme.fromSeed(seedColor: _accent, surface: const Color(0xFFFFFDF9)),
    text: const Color(0xFF1F1B16),
    verseNumber: const Color(0xFF9C7F55),
    highlightAlpha: 0.38,
  );

  static ThemeData sepia() => _build(
    ColorScheme.fromSeed(
      seedColor: _accent,
      surface: const Color(0xFFF4ECD8),
      onSurface: const Color(0xFF4A3B2A),
      surfaceContainerLow: const Color(0xFFEFE5CD),
      surfaceContainer: const Color(0xFFEADFC4),
      surfaceContainerHigh: const Color(0xFFE5D9BC),
      surfaceContainerHighest: const Color(0xFFDFD2B3),
    ),
    text: const Color(0xFF4A3B2A),
    verseNumber: const Color(0xFFA07E4F),
    highlightAlpha: 0.42,
  );

  static ThemeData dark() => _build(
    ColorScheme.fromSeed(
      seedColor: _accent,
      brightness: Brightness.dark,
      surface: const Color(0xFF151412),
    ),
    text: const Color(0xFFE6DFD3),
    verseNumber: const Color(0xFFB59B74),
    highlightAlpha: 0.30,
  );

  static ThemeData _build(
    ColorScheme scheme, {
    required Color text,
    required Color verseNumber,
    required double highlightAlpha,
  }) {
    final base = ThemeData(
      colorScheme: scheme,
      fontFamily: appFontFamily,
      scaffoldBackgroundColor: scheme.surface,
      splashFactory: InkSparkle.splashFactory,
    );
    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.5),
        space: 1,
      ),
      extensions: [
        ReaderColors(
          text: text,
          verseNumber: verseNumber,
          selection: scheme.primary.withValues(alpha: 0.14),
          flash: scheme.tertiary.withValues(alpha: 0.22),
          highlights: {
            for (final e in highlightSwatches.entries)
              e.key: e.value.withValues(alpha: highlightAlpha),
          },
        ),
      ],
    );
  }

  /// Motiv podle volby uživatele; `system` řeší MaterialApp přes
  /// `themeMode` (světlý/tmavý podle telefonu).
  static ThemeData forMode(AppThemeMode mode) => switch (mode) {
    AppThemeMode.sepia => sepia(),
    AppThemeMode.dark => dark(),
    _ => light(),
  };
}
