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

/// Doplňkové barvy designu (karty, přechody, kategorie knih).
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.gold,
    required this.heroStart,
    required this.heroEnd,
    required this.onHero,
    required this.card,
    required this.cardBorder,
    required this.muted,
    required this.water,
    required this.land,
  });

  /// Akcent – teplé zlato (čísla veršů, ikony, zvýraznění).
  final Color gold;

  /// Přechod hlavní karty (verš dne).
  final Color heroStart;
  final Color heroEnd;
  final Color onHero;

  /// Plocha karet a jejich jemný okraj.
  final Color card;
  final Color cardBorder;
  final Color muted;

  /// Barvy mapy.
  final Color water;
  final Color land;

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>()!;

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(AppPalette? o, double t) {
    if (o == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      gold: l(gold, o.gold),
      heroStart: l(heroStart, o.heroStart),
      heroEnd: l(heroEnd, o.heroEnd),
      onHero: l(onHero, o.onHero),
      card: l(card, o.card),
      cardBorder: l(cardBorder, o.cardBorder),
      muted: l(muted, o.muted),
      water: l(water, o.water),
      land: l(land, o.land),
    );
  }
}

/// Písmo rozhraní (text Bible a nadpisy používají [appFontFamily]).
const uiFontFamily = 'Inter';

/// Motivy: světlý (papír), teplá sépie a tmavý (noční čtení).
abstract final class AppTheme {
  static const _ink = Color(0xFF2B2622);
  static const _gold = Color(0xFFB0813B);

  static ThemeData light() => _build(
    ColorScheme.fromSeed(
      seedColor: _gold,
      primary: const Color(0xFF8A5A1F),
      surface: const Color(0xFFFBF8F3),
      onSurface: _ink,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: const Color(0xFFF6F1E9),
      surfaceContainer: const Color(0xFFF1EADF),
      surfaceContainerHigh: const Color(0xFFEBE3D6),
      surfaceContainerHighest: const Color(0xFFE4DACB),
    ),
    text: const Color(0xFF221E1A),
    verseNumber: const Color(0xFFB0813B),
    highlightAlpha: 0.38,
    palette: const AppPalette(
      gold: Color(0xFFB0813B),
      heroStart: Color(0xFF3A2C1E),
      heroEnd: Color(0xFF7A5428),
      onHero: Color(0xFFFFF6E6),
      card: Colors.white,
      cardBorder: Color(0xFFEDE5D8),
      muted: Color(0xFF8C8276),
      water: Color(0xFFDCE7EC),
      land: Color(0xFFF4EEE3),
    ),
  );

  static ThemeData sepia() => _build(
    ColorScheme.fromSeed(
      seedColor: _gold,
      primary: const Color(0xFF7C5320),
      surface: const Color(0xFFF4ECD8),
      onSurface: const Color(0xFF4A3B2A),
      surfaceContainerLowest: const Color(0xFFFAF4E6),
      surfaceContainerLow: const Color(0xFFEFE5CD),
      surfaceContainer: const Color(0xFFEADFC4),
      surfaceContainerHigh: const Color(0xFFE5D9BC),
      surfaceContainerHighest: const Color(0xFFDFD2B3),
    ),
    text: const Color(0xFF4A3B2A),
    verseNumber: const Color(0xFFA07E4F),
    highlightAlpha: 0.42,
    palette: const AppPalette(
      gold: Color(0xFFA0702E),
      heroStart: Color(0xFF4A3520),
      heroEnd: Color(0xFF8A6332),
      onHero: Color(0xFFFFF3DC),
      card: Color(0xFFFAF4E6),
      cardBorder: Color(0xFFE2D5B8),
      muted: Color(0xFF8A7A62),
      water: Color(0xFFD5DCD2),
      land: Color(0xFFF1E7D0),
    ),
  );

  static ThemeData dark() => _build(
    ColorScheme.fromSeed(
      seedColor: _gold,
      brightness: Brightness.dark,
      primary: const Color(0xFFE2B26A),
      surface: const Color(0xFF12110F),
      onSurface: const Color(0xFFECE5D9),
      surfaceContainerLowest: const Color(0xFF0C0B0A),
      surfaceContainerLow: const Color(0xFF1A1816),
      surfaceContainer: const Color(0xFF201E1B),
      surfaceContainerHigh: const Color(0xFF292622),
      surfaceContainerHighest: const Color(0xFF332F2A),
    ),
    text: const Color(0xFFE6DFD3),
    verseNumber: const Color(0xFFC9A46A),
    highlightAlpha: 0.30,
    palette: const AppPalette(
      gold: Color(0xFFD9AA62),
      heroStart: Color(0xFF2A2117),
      heroEnd: Color(0xFF5A3F1E),
      onHero: Color(0xFFFFF1DA),
      card: Color(0xFF1C1A17),
      cardBorder: Color(0xFF2C2925),
      muted: Color(0xFF9A9083),
      water: Color(0xFF1B2629),
      land: Color(0xFF24211D),
    ),
  );

  static ThemeData _build(
    ColorScheme scheme, {
    required Color text,
    required Color verseNumber,
    required double highlightAlpha,
    required AppPalette palette,
  }) {
    final base = ThemeData(
      colorScheme: scheme,
      fontFamily: uiFontFamily,
      scaffoldBackgroundColor: scheme.surface,
      splashFactory: InkSparkle.splashFactory,
    );
    // Nadpisy v knižním písmu, rozhraní v Inter.
    final t = base.textTheme;
    TextStyle? serif(TextStyle? s, {FontWeight? w}) =>
        s?.copyWith(fontFamily: appFontFamily, fontWeight: w);
    return base.copyWith(
      textTheme: t.copyWith(
        displayLarge: serif(t.displayLarge),
        displayMedium: serif(t.displayMedium),
        displaySmall: serif(t.displaySmall),
        headlineLarge: serif(t.headlineLarge, w: FontWeight.w600),
        headlineMedium: serif(t.headlineMedium, w: FontWeight.w600),
        headlineSmall: serif(t.headlineSmall, w: FontWeight.w600),
        titleLarge: serif(t.titleLarge, w: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: serif(
          t.titleLarge,
          w: FontWeight.w600,
        )?.copyWith(color: scheme.onSurface),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      cardTheme: CardThemeData(
        // Klepnutí/najetí myší nesmí přesahovat zaoblené rohy.
        clipBehavior: Clip.antiAlias,
        color: palette.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: palette.cardBorder),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: palette.cardBorder),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.5),
        space: 1,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      extensions: [
        palette,
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
