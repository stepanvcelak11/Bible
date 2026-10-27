import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/bible_entities.dart';
import '../../domain/entities/reader_settings.dart';

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
  static const _readerSettings = 'reader.settings';
  static const _searchTestament = 'search.testament';

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

  ReaderSettings get readerSettings {
    final raw = _prefs.getString(_readerSettings);
    if (raw == null) return const ReaderSettings();
    try {
      return ReaderSettings.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on FormatException {
      return const ReaderSettings();
    } on TypeError {
      return const ReaderSettings();
    }
  }

  Future<void> setReaderSettings(ReaderSettings settings) =>
      _prefs.setString(_readerSettings, jsonEncode(settings.toJson()));

  /// Poslední filtr hledání: `null` = celá Bible, jinak 'OT' / 'NT'.
  String? get searchTestament => _prefs.getString(_searchTestament);
  Future<void> setSearchTestament(String? code) => code == null
      ? _prefs.remove(_searchTestament)
      : _prefs.setString(_searchTestament, code);

  // --- Studijní balíček --------------------------------------------------------
  static const _studyVersion = 'study.version';

  /// Verze nainstalovaného studijního balíčku (`null` = nenainstalován).
  String? get studyVersion => _prefs.getString(_studyVersion);
  Future<void> setStudyVersion(String? v) => v == null
      ? _prefs.remove(_studyVersion)
      : _prefs.setString(_studyVersion, v);

  // --- Plán čtení --------------------------------------------------------------
  static const _planId = 'plan.id';
  static const _planStart = 'plan.start';
  static const _planDone = 'plan.done';

  String? get planId => _prefs.getString(_planId);
  DateTime? get planStart =>
      DateTime.tryParse(_prefs.getString(_planStart) ?? '');
  Set<int> get planDone => {
    for (final s in _prefs.getStringList(_planDone) ?? const <String>[])
      ?int.tryParse(s),
  };

  Future<void> setPlan(String? id, {DateTime? start}) async {
    if (id == null) {
      await _prefs.remove(_planId);
      await _prefs.remove(_planStart);
    } else {
      await _prefs.setString(_planId, id);
      await _prefs.setString(
        _planStart,
        (start ?? DateTime.now()).toIso8601String(),
      );
    }
    await _prefs.remove(_planDone);
  }

  Future<void> setPlanDone(Set<int> days) => _prefs.setStringList(_planDone, [
    for (final d in days.toList()..sort()) '$d',
  ]);

  // --- Hledání -----------------------------------------------------------------
  static const _recentSearches = 'search.recent';

  List<String> get recentSearches =>
      _prefs.getStringList(_recentSearches) ?? const [];

  Future<void> addRecentSearch(String query) {
    final list = [query, ...recentSearches.where((q) => q != query)];
    return _prefs.setStringList(_recentSearches, list.take(8).toList());
  }

  Future<void> clearRecentSearches() => _prefs.remove(_recentSearches);

  // --- Čtečka ------------------------------------------------------------------
  static const _onboardingDone = 'app.onboardingDone';

  bool get onboardingDone => _prefs.getBool(_onboardingDone) ?? false;
  Future<void> setOnboardingDone() => _prefs.setBool(_onboardingDone, true);
}
