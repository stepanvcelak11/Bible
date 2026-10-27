import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../shell/home_shell.dart';
import '../application/study_providers.dart';

/// Otevře úvod ke knize jako spodní panel.
Future<void> showBookIntro(BuildContext context, int bookId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, controller) =>
          BookIntroView(bookId: bookId, scrollController: controller),
    ),
  );
}

/// Úvod ke knize: autor, doba vzniku, téma, shrnutí, osnova, klíčové verše.
class BookIntroView extends ConsumerWidget {
  const BookIntroView({super.key, required this.bookId, this.scrollController});

  final int bookId;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookByIdProvider(bookId));
    final intro = ref.watch(bookIntrosProvider).value?[bookId];
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final category = categoryOf(bookId);
    final accent = Color(category.color);

    if (intro == null) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget fact(IconData icon, String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.muted,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Text(
          category.name.toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            color: accent,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(book.name, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 16),
        Text(
          intro.summary,
          style: TextStyle(
            fontFamily: appFontFamily,
            fontSize: 17,
            height: 1.55,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 22),
        fact(Icons.person_outline, S.author, intro.author),
        fact(Icons.schedule, S.written, intro.date),
        fact(Icons.lightbulb_outline, S.theme2, intro.theme),
        const SizedBox(height: 8),
        Text(S.outline, style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        for (final item in intro.outline)
          _OutlineRow(item: item, bookId: bookId, accent: accent),
        const SizedBox(height: 18),
        Text(S.keyVerses, style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final kv in intro.keyVerses)
              ActionChip(
                label: Text(
                  '${book.abbreviation} ${kv.replaceFirst(':', ',')}',
                ),
                onPressed: () {
                  final ref0 = _parse(bookId, kv);
                  if (ref0 != null) openReaderAt(context, ref, ref0);
                },
              ),
          ],
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => openReaderAt(context, ref, VerseRef(bookId, 1)),
          icon: const Icon(Icons.menu_book),
          label: const Text(S.readBook),
        ),
      ],
    );
  }

  static VerseRef? _parse(int bookId, String kv) {
    final m = RegExp(r'^(\d+):(\d+)').firstMatch(kv);
    if (m == null) return null;
    return VerseRef(bookId, int.parse(m[1]!), int.parse(m[2]!));
  }
}

class _OutlineRow extends ConsumerWidget {
  const _OutlineRow({
    required this.item,
    required this.bookId,
    required this.accent,
  });

  final String item;
  final int bookId;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // „12–25 Abraham“ → rozsah kapitol + popis.
    final m = RegExp(r'^([\d:–-]+)\s+(.*)$').firstMatch(item);
    final range = m?[1] ?? '';
    final label = m?[2] ?? item;
    final firstChapter = int.tryParse(RegExp(r'^\d+').stringMatch(range) ?? '');
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: firstChapter == null
          ? null
          : () => openReaderAt(context, ref, VerseRef(bookId, firstChapter)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            SizedBox(
              width: 64,
              child: Text(
                range,
                style: theme.textTheme.labelLarge?.copyWith(color: accent),
              ),
            ),
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }
}
