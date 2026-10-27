import 'package:flutter/foundation.dart';

/// Barevný motiv aplikace.
enum AppThemeMode { system, light, sepia, dark }

/// Typografické nastavení čtečky.
@immutable
class ReaderSettings {
  const ReaderSettings({
    this.themeMode = AppThemeMode.system,
    this.fontSize = 19,
    this.lineHeight = 1.6,
    this.horizontalMargin = 22,
    this.showVerseNumbers = true,
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

  ReaderSettings copyWith({
    AppThemeMode? themeMode,
    double? fontSize,
    double? lineHeight,
    double? horizontalMargin,
    bool? showVerseNumbers,
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
  );

  Map<String, Object> toJson() => {
    'themeMode': themeMode.name,
    'fontSize': fontSize,
    'lineHeight': lineHeight,
    'horizontalMargin': horizontalMargin,
    'showVerseNumbers': showVerseNumbers,
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
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ReaderSettings &&
      other.themeMode == themeMode &&
      other.fontSize == fontSize &&
      other.lineHeight == lineHeight &&
      other.horizontalMargin == horizontalMargin &&
      other.showVerseNumbers == showVerseNumbers;

  @override
  int get hashCode => Object.hash(
    themeMode,
    fontSize,
    lineHeight,
    horizontalMargin,
    showVerseNumbers,
  );
}
