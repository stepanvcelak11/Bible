import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../translations/application/translation_controller.dart';
import '../../translations/presentation/translation_selector_sheet.dart';
import '../application/chapter_content_provider.dart';
import '../application/reading_position_controller.dart';

/// Čtečka – ZÁKLADNÍ verze z kroku 1.
///
/// Slouží k ověření datové vrstvy a přepínání překladů. Plnohodnotná
/// čtečka (Focus Mode, gesta, typografie, motivy) přijde v kroku 2.
class ReaderScreen extends ConsumerWidget {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(readingPositionProvider);
    final book = ref.watch(bookByIdProvider(position.bookId));
    final primary = ref.watch(primaryTranslationProvider);
    final secondary = ref.watch(secondaryTranslationProvider);
    final content = ref.watch(chapterContentProvider);
    final positionCtl = ref.read(readingPositionProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.chapterTitle(book.name, position.chapter)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              tooltip: S.selectTranslation,
              avatar: Icon(
                secondary == null
                    ? Icons.translate
                    : Icons.view_column_outlined,
                size: 18,
              ),
              label: Text(
                secondary == null
                    ? primary.abbreviation
                    : '${primary.abbreviation} · ${secondary.abbreviation}',
              ),
              onPressed: () => showTranslationSelector(context),
            ),
          ),
        ],
      ),
      body: switch (content) {
        // Data jsou k dispozici (i během načítání další kapitoly).
        AsyncValue(:final value?) => _ChapterBody(
          content: value,
          primary: primary,
          secondary: secondary,
        ),
        AsyncValue(:final error?) => _ErrorView(
          onRetry: () => ref.invalidate(chapterContentProvider),
          error: error,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              tooltip: S.previousChapter,
              icon: const Icon(Icons.chevron_left),
              onPressed: positionCtl.previousChapter,
            ),
            IconButton(
              tooltip: S.nextChapter,
              icon: const Icon(Icons.chevron_right),
              onPressed: positionCtl.nextChapter,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChapterBody extends StatelessWidget {
  const _ChapterBody({
    required this.content,
    required this.primary,
    required this.secondary,
  });

  final ChapterContent content;
  final Translation primary;
  final Translation? secondary;

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(S.chapterMissing, textAlign: TextAlign.center),
        ),
      );
    }
    // Klíč podle kapitoly zajistí návrat na začátek při změně kapitoly,
    // ale ne při přepnutí překladu.
    final key = PageStorageKey('${content.bookId}:${content.chapter}');
    return switch (content) {
      SingleChapter(:final verses) => ListView.builder(
        key: key,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        itemCount: verses.length,
        itemBuilder: (context, i) => _VerseText(verse: verses[i]),
      ),
      ParallelChapter(:final rows) => ListView.builder(
        key: key,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
        itemCount: rows.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return _ParallelHeader(left: primary, right: secondary!);
          }
          final row = rows[i - 1];
          // Bez IntrinsicHeight – ten by každý řádek měřil dvakrát.
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _VerseText(verse: row.primary, number: row.number),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _VerseText(verse: row.secondary, number: row.number),
              ),
            ],
          );
        },
      ),
    };
  }
}

class _ParallelHeader extends StatelessWidget {
  const _ParallelHeader({required this.left, required this.right});

  final Translation left;
  final Translation right;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(left.name, style: style)),
          const SizedBox(width: 16),
          Expanded(child: Text(right.name, style: style)),
        ],
      ),
    );
  }
}

class _VerseText extends StatelessWidget {
  const _VerseText({required this.verse, this.number});

  final Verse? verse;
  final int? number;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = verse;
    if (v == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${number ?? v.number} ',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontFeatures: const [FontFeature.superscripts()],
              ),
            ),
            TextSpan(text: v.text),
          ],
        ),
        style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry, required this.error});

  final VoidCallback onRetry;
  final Object error;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(S.errorLoadChapter),
        const SizedBox(height: 12),
        FilledButton(onPressed: onRetry, child: const Text(S.retry)),
      ],
    ),
  );
}
