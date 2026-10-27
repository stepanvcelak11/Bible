import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/reader_settings.dart';

/// Nastavení čtečky (motiv, písmo, řádkování, okraje). Ukládá se okamžitě.
class ReaderSettingsController extends Notifier<ReaderSettings> {
  @override
  ReaderSettings build() => ref.read(appPreferencesProvider).readerSettings;

  void update(ReaderSettings Function(ReaderSettings) change) {
    final next = change(state);
    if (next == state) return;
    state = next;
    ref.read(appPreferencesProvider).setReaderSettings(next);
  }

  void setThemeMode(AppThemeMode mode) =>
      update((s) => s.copyWith(themeMode: mode));

  void setFontSize(double value) => update((s) => s.copyWith(fontSize: value));

  void setLineHeight(double value) =>
      update((s) => s.copyWith(lineHeight: value));

  void setMargin(double value) =>
      update((s) => s.copyWith(horizontalMargin: value));

  void setShowVerseNumbers(bool value) =>
      update((s) => s.copyWith(showVerseNumbers: value));

  void setParagraphMode(bool value) =>
      update((s) => s.copyWith(paragraphMode: value));

  void setBackground(AppBackgroundStyle value) =>
      update((s) => s.copyWith(background: value));

  void reset() => update((_) => const ReaderSettings());
}

final readerSettingsProvider =
    NotifierProvider<ReaderSettingsController, ReaderSettings>(
      ReaderSettingsController.new,
    );
