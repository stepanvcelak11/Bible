import 'package:flutter/foundation.dart';

/// Barevný motiv aplikace.
enum AppThemeMode { system, light, sepia, dark }

/// Pozadí obrazovek: jednobarevné, papír (jemné zrno), záře (teplé světelné
/// skvrny) a obloha (svítání, v tmavém motivu hvězdná noc).
enum AppBackgroundStyle { plain, paper, glow, sky }

/// Barevný akcent rozhraní (tlačítka, čísla veršů, hlavní karty).
enum AppAccent { gold, olive, ocean, plum, terracotta }

/// Typografické nastavení čtečky.
@immutable
class ReaderSettings {
  const ReaderSettings({
    this.themeMode = AppThemeMode.system,
    this.fontSize = 19,
    this.lineHeight = 1.6,
    this.horizontalMargin = 22,
    this.showVerseNumbers = true,
    this.paragraphMode = true,
    this.background = AppBackgroundStyle.glow,
    this.accent = AppAccent.gold,
    this.dropCap = true,
    this.illustrations = true,
  });

  static const minFontSize = 14.0;
  static const maxFontSize = 32.0;
  static const minLineHeight = 1.2;
  static const maxLineHeight = 2.2;
  static const minMargin = 8.0;
  static const maxMargin = 48.0;

  final AppThemeMode themeMode;
  final double fontSize;
  final double lineHeight;
  final double horizontalMargin;
  final bool showVerseNumbers;

  /// Text v odstavcích jako v tištěné Bibli (u překladů s členěním);
  /// jinak každý verš na samostatném řádku.
  final bool paragraphMode;

  final AppBackgroundStyle background;
  final AppAccent accent;

  /// Ozdobná iniciála na začátku kapitoly.
  final bool dropCap;

  /// Kreslené ilustrace k příběhům v textu.
  final bool illustrations;

  ReaderSettings copyWith({
    AppThemeMode? themeMode,
    double? fontSize,
    double? lineHeight,
    double? horizontalMargin,
    bool? showVerseNumbers,
    bool? paragraphMode,
    AppBackgroundStyle? background,
    AppAccent? accent,
    bool? dropCap,
    bool? illustrations,
  }) => ReaderSettings(
    themeMode: themeMode ?? this.themeMode,
    fontSize: (fontSize ?? this.fontSize).clamp(minFontSize, maxFontSize),
    lineHeight: (lineHeight ?? this.lineHeight).clamp(
      minLineHeight,
      maxLineHeight,
    ),
    horizontalMargin: (horizontalMargin ?? this.horizontalMargin).clamp(
      minMargin,
      maxMargin,
    ),
    showVerseNumbers: showVerseNumbers ?? this.showVerseNumbers,
    paragraphMode: paragraphMode ?? this.paragraphMode,
    background: background ?? this.background,
    accent: accent ?? this.accent,
    dropCap: dropCap ?? this.dropCap,
    illustrations: illustrations ?? this.illustrations,
  );

  Map<String, Object> toJson() => {
    'themeMode': themeMode.name,
    'fontSize': fontSize,
    'lineHeight': lineHeight,
    'horizontalMargin': horizontalMargin,
    'showVerseNumbers': showVerseNumbers,
    'paragraphMode': paragraphMode,
    'background': background.name,
    'accent': accent.name,
    'dropCap': dropCap,
    'illustrations': illustrations,
  };

  /// Tolerantní načtení – neznámé nebo poškozené hodnoty se nahradí výchozími.
  factory ReaderSettings.fromJson(Map<String, Object?> json) {
    const d = ReaderSettings();
    double numOr(String key, double fallback) =>
        (json[key] as num?)?.toDouble() ?? fallback;
    return d.copyWith(
      themeMode: AppThemeMode.values.asNameMap()[json['themeMode']],
      fontSize: numOr('fontSize', d.fontSize),
      lineHeight: numOr('lineHeight', d.lineHeight),
      horizontalMargin: numOr('horizontalMargin', d.horizontalMargin),
      showVerseNumbers: json['showVerseNumbers'] as bool?,
      paragraphMode: json['paragraphMode'] as bool?,
      background: AppBackgroundStyle.values.asNameMap()[json['background']],
      accent: AppAccent.values.asNameMap()[json['accent']],
      dropCap: json['dropCap'] as bool?,
      illustrations: json['illustrations'] as bool?,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ReaderSettings &&
      other.themeMode == themeMode &&
      other.fontSize == fontSize &&
      other.lineHeight == lineHeight &&
      other.horizontalMargin == horizontalMargin &&
      other.showVerseNumbers == showVerseNumbers &&
      other.paragraphMode == paragraphMode &&
      other.background == background &&
      other.accent == accent &&
      other.dropCap == dropCap &&
      other.illustrations == illustrations;

  @override
  int get hashCode => Object.hash(
    themeMode,
    fontSize,
    lineHeight,
    horizontalMargin,
    showVerseNumbers,
    paragraphMode,
    background,
    accent,
    dropCap,
    illustrations,
  );
}
