import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/bible_entities.dart';

/// Typovaný obal nad SharedPreferences pro drobná nastavení.
///
/// Instance se načte jednou při startu (`main`) a pak se čte synchronně,
/// takže aplikace naběhne rovnou na posledním místě čtení bez probliknutí.
/// Větší uživatelská data patří do `user.db`, ne sem.
class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _primaryTranslation = 'translation.primary';
  static const _secondaryTranslation = 'translation.secondary';
  static const _lastSecondaryTranslation = 'translation.lastSecondary';
  static const _readingPosition = 'reader.position';

  String? get primaryTranslationId => _prefs.getString(_primaryTranslation);
  Future<void> setPrimaryTranslationId(String id) =>
      _prefs.setString(_primaryTranslation, id);

  /// Druhý překlad pro porovnání; `null` = porovnání vypnuto.
  String? get secondaryTranslationId => _prefs.getString(_secondaryTranslation);
  Future<void> setSecondaryTranslationId(String? id) => id == null
      ? _prefs.remove(_secondaryTranslation)
      : _prefs.setString(_secondaryTranslation, id);

  /// Naposledy použitý druhý překlad – po opětovném zapnutí porovnání se
  /// nabídne znovu.
  String? get lastSecondaryTranslationId =>
      _prefs.getString(_lastSecondaryTranslation);
  Future<void> setLastSecondaryTranslationId(String id) =>
      _prefs.setString(_lastSecondaryTranslation, id);

  VerseRef? get readingPosition =>
      VerseRef.tryDecode(_prefs.getString(_readingPosition));
  Future<void> setReadingPosition(VerseRef ref) =>
      _prefs.setString(_readingPosition, ref.encode());
}
