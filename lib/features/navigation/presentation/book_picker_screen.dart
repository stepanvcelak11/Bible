import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../reader/application/reading_position_controller.dart';
import '../../translations/application/translation_controller.dart';

/// Výběr knihy a kapitoly: dvě sekce (Starý / Nový zákon), klepnutí na
/// knihu rozbalí mřížku kapitol, klepnutí na kapitolu otevře čtení.
class BookPickerScreen extends ConsumerStatefulWidget {
  const BookPickerScreen({super.key});

  @override
  ConsumerState<BookPickerScreen> createState() => _BookPickerScreenState();
}

class _BookPickerScreenState extends ConsumerState<BookPickerScreen> {
  late int? _expanded = ref.read(readingPositionProvider).bookId;
  final _currentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Posunout seznam na aktuální knihu.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _currentKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(ctx, alignment: 0.15);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(booksProvider);
    final primaryId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final counts =
        ref.watch(chapterCountsProvider(primaryId)).value ?? const {};
    final position = ref.watch(readingPositionProvider);
    final available = books.where((b) => (counts[b.id] ?? 0) > 0);

    Iterable<Widget> section(String title, Testament testament) sync* {
      yield _SectionHeader(title);
      for (final book in available.where((b) => b.testament == testament)) {
        yield _BookRow(
          key: book.id == position.bookId ? _currentKey : null,
          book: book,
          chapterCount: counts[book.id]!,
          expanded: _expanded == book.id,
          currentChapter: book.id == position.bookId ? position.chapter : null,
          onToggle: () =>
              setState(() => _expanded = _expanded == book.id ? null : book.id),
          onChapter: (chapter) {
            ref
                .read(readingPositionProvider.notifier)
                .jumpTo(VerseRef(book.id, chapter));
            Navigator.of(context).pop();
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text(S.chooseBook)),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 24,
        ),
        children: [
          ...section(S.oldTestament, Testament.oldTestament),
          ...section(S.newTestament, Testament.newTestament),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(
          letterSpacing: 2,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _BookRow extends StatelessWidget {
  const _BookRow({
    super.key,
    required this.book,
    required this.chapterCount,
    required this.expanded,
    required this.currentChapter,
    required this.onToggle,
    required this.onChapter,
  });

  final Book book;
  final int chapterCount;
  final bool expanded;
  final int? currentChapter;
  final VoidCallback onToggle;
  final ValueChanged<int> onChapter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isCurrent = currentChapter != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            child: Row(
              children: [
                SizedBox(
                  width: 46,
                  child: Text(
                    book.abbreviation,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    book.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isCurrent ? scheme.primary : null,
                      fontWeight: isCurrent ? FontWeight.w600 : null,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.expand_more,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: !expanded
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 60,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: chapterCount,
                    itemBuilder: (context, i) {
                      final chapter = i + 1;
                      final selected = chapter == currentChapter;
                      return Material(
                        color: selected
                            ? scheme.primary
                            : scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => onChapter(chapter),
                          child: Center(
                            child: Text(
                              '$chapter',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: selected ? scheme.onPrimary : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
