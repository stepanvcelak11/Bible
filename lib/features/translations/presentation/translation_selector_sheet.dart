import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../application/translation_controller.dart';
import 'library_screen.dart';

/// Otevře spodní panel „Vybrat překlad“.
Future<void> showTranslationSelector(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => const TranslationSelectorSheet(),
  );
}

/// Výběr hlavního překladu + volitelné porovnání s druhým překladem.
///
/// Změny se projeví okamžitě (panel zůstává otevřený), takže uživatel vidí
/// text v novém překladu hned za panelem a na stejném místě.
class TranslationSelectorSheet extends ConsumerWidget {
  const TranslationSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = ref.watch(translationsProvider);
    final selection = ref.watch(translationControllerProvider);
    final controller = ref.read(translationControllerProvider.notifier);
    final theme = Theme.of(context);
    final canCompare = translations.length > 1;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _Header(S.selectTranslation, theme: theme),
          for (final t in translations)
            _TranslationTile(
              translation: t,
              selected: t.id == selection.primaryId,
              onTap: () => controller.selectPrimary(t.id),
            ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            leading: const Icon(Icons.download_for_offline_outlined),
            title: const Text(S.manageTranslations),
            subtitle: const Text('B21, ČEP, ČSP'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const LibraryScreen()),
              );
            },
          ),
          const Divider(height: 32),
          SwitchListTile(
            title: const Text(S.compareTranslations),
            subtitle: canCompare ? null : const Text(S.noOtherTranslation),
            secondary: const Icon(Icons.view_column_outlined),
            value: selection.isComparing,
            onChanged: canCompare ? (_) => controller.toggleCompare() : null,
          ),
          // Animované rozbalení sekce s druhým překladem.
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: !selection.isComparing
                ? const SizedBox(width: double.infinity)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(S.compareWith, theme: theme),
                      for (final t in translations)
                        if (t.id != selection.primaryId)
                          _TranslationTile(
                            translation: t,
                            selected: t.id == selection.secondaryId,
                            onTap: () => controller.selectSecondary(t.id),
                          ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: controller.swap,
                            icon: const Icon(Icons.swap_horiz),
                            label: const Text(S.swapTranslations),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text, {required this.theme});

  final String text;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
    child: Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    ),
  );
}

class _TranslationTile extends StatelessWidget {
  const _TranslationTile({
    required this.translation,
    required this.selected,
    required this.onTap,
  });

  final Translation translation;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final year = translation.year;
    return ListTile(
      onTap: onTap,
      selected: selected,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: selected
            ? scheme.primary
            : scheme.surfaceContainerHighest,
        foregroundColor: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
        child: Text(
          translation.abbreviation,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(translation.name),
      subtitle: year == null ? null : Text('$year'),
      trailing: AnimatedOpacity(
        opacity: selected ? 1 : 0,
        duration: const Duration(milliseconds: 150),
        child: Icon(Icons.check, color: scheme.primary),
      ),
    );
  }
}
