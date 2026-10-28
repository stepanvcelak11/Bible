import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../guide/presentation/guide_screen.dart';

import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_background.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/reader_settings.dart';
import '../../../domain/entities/user_entities.dart';
import '../../reader/presentation/verse_tile.dart';
import '../../study/presentation/study_pack_screen.dart';
import '../../translations/presentation/library_screen.dart';
import '../application/reader_settings_controller.dart';

/// Nastavení: vzhled čtení (s živým náhledem), záloha dat, o aplikaci.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readerSettingsProvider);
    final ctl = ref.read(readerSettingsProvider.notifier);
    final theme = Theme.of(context);

    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.settings)),
        body: ListView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom + 24,
          ),
          children: [
            const _Header(S.appearance),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedButton<AppThemeMode>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: AppThemeMode.system,
                    label: Text(S.themeSystem),
                  ),
                  ButtonSegment(
                    value: AppThemeMode.light,
                    label: Text(S.themeLight),
                  ),
                  ButtonSegment(
                    value: AppThemeMode.sepia,
                    label: Text(S.themeSepia),
                  ),
                  ButtonSegment(
                    value: AppThemeMode.dark,
                    label: Text(S.themeDark),
                  ),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (s) => ctl.setThemeMode(s.single),
              ),
            ),
            const _Header(S.background),
            const _BackgroundPicker(),
            // Živý náhled textu.
            Container(
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              padding: EdgeInsets.symmetric(
                horizontal: settings.horizontalMargin,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    if (settings.showVerseNumbers)
                      verseNumberSpan(context, 1, settings),
                    const TextSpan(text: S.previewText),
                  ],
                ),
                style: verseTextStyle(context, settings),
              ),
            ),
            _SliderTile(
              icon: Icons.format_size,
              label: S.fontSize,
              value: settings.fontSize,
              min: ReaderSettings.minFontSize,
              max: ReaderSettings.maxFontSize,
              divisions: 18,
              display: settings.fontSize.round().toString(),
              onChanged: ctl.setFontSize,
            ),
            _SliderTile(
              icon: Icons.format_line_spacing,
              label: S.lineHeight,
              value: settings.lineHeight,
              min: ReaderSettings.minLineHeight,
              max: ReaderSettings.maxLineHeight,
              divisions: 10,
              display: settings.lineHeight
                  .toStringAsFixed(1)
                  .replaceAll('.', ','),
              onChanged: ctl.setLineHeight,
            ),
            _SliderTile(
              icon: Icons.format_indent_increase,
              label: S.margins,
              value: settings.horizontalMargin,
              min: ReaderSettings.minMargin,
              max: ReaderSettings.maxMargin,
              divisions: 10,
              display: settings.horizontalMargin.round().toString(),
              onChanged: ctl.setMargin,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.format_list_numbered),
              title: const Text(S.showVerseNumbers),
              value: settings.showVerseNumbers,
              onChanged: ctl.setShowVerseNumbers,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.notes),
              title: const Text(S.paragraphMode),
              subtitle: const Text(S.paragraphModeHint),
              value: settings.paragraphMode,
              onChanged: ctl.setParagraphMode,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  onPressed: ctl.reset,
                  child: const Text(S.resetAppearance),
                ),
              ),
            ),
            const _Header(S.translations),
            ListTile(
              leading: const Icon(Icons.translate),
              title: const Text(S.manageTranslations),
              subtitle: const Text('B21, ČEP, ČSP, vlastní soubor'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const LibraryScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history_edu),
              title: const Text(S.studyPackTitle),
              subtitle: const Text('Původní text, slovník, souvislosti'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const StudyPackScreen(),
                ),
              ),
            ),
            const _Header(S.backup),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                S.backupInfo,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text(S.exportBackup),
              onTap: () => _export(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text(S.importBackup),
              onTap: () => _import(context, ref),
            ),
            const _Header(S.about),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text(S.guide),
              subtitle: const Text(S.guideHint),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => openGuide(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(S.aboutBody, style: theme.textTheme.bodyMedium),
            ),
            const _Header('Licence'),
            for (final t in ref.watch(translationsProvider))
              ListTile(
                leading: CircleAvatar(
                  radius: 18,
                  child: Text(
                    t.abbreviation,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(t.name),
                subtitle: Text(
                  [if (t.year != null) '${t.year}', ?t.license].join(' · '),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                'Písma Literata a Inter – SIL Open Font License. '
                '${S.studyPackCredits}',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final box = context.findRenderObject() as RenderBox?;
    final data = await ref.read(userDataRepositoryProvider).exportBackup();
    final bytes = utf8.encode(const JsonEncoder.withIndent('  ').convert(data));
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final name = 'bible-zaloha-$date.json';
    // iPhone: nabídka sdílení → „Uložit do Souborů“; na webu bez podpory
    // sdílení souborů se soubor stáhne.
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            Uint8List.fromList(bytes),
            name: name,
            mimeType: 'application/json',
          ),
        ],
        fileNameOverrides: [name],
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    void say(String text) => messenger.showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );

    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (file == null) return;
    try {
      final json = jsonDecode(utf8.decode(await file.readAsBytes()));
      if (json is! Map<String, Object?>) {
        throw const InvalidBackupException('Kořen není objekt.');
      }
      final result = await ref
          .read(userDataRepositoryProvider)
          .importBackup(json);
      say(S.backupImported(result.total));
    } on InvalidBackupException {
      say(S.backupInvalid);
    } on FormatException {
      say(S.backupInvalid);
    }
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(
          letterSpacing: 2,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.display,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String display;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 20, 0),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          SizedBox(
            width: 118,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              display,
              textAlign: TextAlign.end,
              style: theme.textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}

/// Výběr pozadí – malé živé náhledy.
class _BackgroundPicker extends ConsumerWidget {
  const _BackgroundPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      readerSettingsProvider.select((s) => s.background),
    );
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    const labels = {
      AppBackgroundStyle.plain: S.backgroundPlain,
      AppBackgroundStyle.paper: S.backgroundPaper,
      AppBackgroundStyle.glow: S.backgroundGlow,
      AppBackgroundStyle.sky: S.backgroundSky,
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: [
          for (final style in AppBackgroundStyle.values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Semantics(
                  button: true,
                  selected: style == selected,
                  label: labels[style],
                  child: GestureDetector(
                    onTap: () => ref
                        .read(readerSettingsProvider.notifier)
                        .setBackground(style),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: 74,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: style == selected
                                  ? palette.gold
                                  : palette.cardBorder,
                              width: style == selected ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CustomPaint(
                              size: Size.infinite,
                              painter: BackdropPainter(
                                style: style,
                                surface: theme.colorScheme.surface,
                                palette: palette,
                                dark: theme.brightness == Brightness.dark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        ExcludeSemantics(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              labels[style]!,
                              maxLines: 1,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: style == selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
