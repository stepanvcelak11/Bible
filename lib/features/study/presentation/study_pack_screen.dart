import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/translations/translation_installer.dart';
import '../application/study_providers.dart';

/// Obrazovka studijního balíčku (stažení / odstranění).
class StudyPackScreen extends StatelessWidget {
  const StudyPackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.studyPackTitle)),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [StudyPackCard(showCredits: true)],
        ),
      ),
    );
  }
}

/// Karta se stavem studijního balíčku – použitelná i uvnitř panelů.
class StudyPackCard extends ConsumerWidget {
  const StudyPackCard({super.key, this.showCredits = false});

  final bool showCredits;

  static String _mb(int bytes) =>
      '${(bytes / 1048576).toStringAsFixed(1).replaceAll('.', ',')} MB';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyPackProvider).value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final ctl = ref.read(studyPackProvider.notifier);

    Widget body;
    switch (state) {
      case null:
        body = const Center(child: CircularProgressIndicator());
      case StudyUnavailable():
        body = const Text(
          'Studijní balíček není v tomto sestavení k dispozici.',
        );
      case StudyNotInstalled(:final manifest, :final error):
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.studyPackBody, style: theme.textTheme.bodyMedium),
            if (error != null) ...[
              const SizedBox(height: 10),
              Text(
                '${S.downloadFailed}: $error',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: ctl.install,
              icon: const Icon(Icons.download),
              label: Text(S.studyPackDownload(_mb(manifest.downloadSize))),
            ),
          ],
        );
      case StudyInstalling(:final progress):
        final (label, value) = switch (progress) {
          Downloading(:final fraction) => (S.downloading, fraction),
          Processing() => (S.processing, null),
          Saving() => (S.saving, null),
          null => (S.downloading, null),
        };
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: value,
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      case StudyReady(:final manifest):
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: palette.gold),
                const SizedBox(width: 8),
                const Expanded(child: Text(S.studyPackInstalled)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _mb(manifest.size),
              style: theme.textTheme.labelSmall?.copyWith(color: palette.muted),
            ),
            if (showCredits) ...[
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: ctl.remove,
                icon: const Icon(Icons.delete_outline),
                label: const Text(S.studyPackRemove),
              ),
            ],
          ],
        );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8C6BA8).withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.history_edu,
                    color: Color(0xFF8C6BA8),
                  ),
                ),
                const SizedBox(width: 12),
                Text(S.studyPackTitle, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 14),
            body,
            if (showCredits) ...[
              const SizedBox(height: 18),
              Text(
                S.studyPackCredits,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
