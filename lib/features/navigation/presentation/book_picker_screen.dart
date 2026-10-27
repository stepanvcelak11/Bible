import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../reader/application/reading_position_controller.dart';
import '../../search/application/reference_parser.dart';
import '../../shell/home_shell.dart';
import '../../study/application/study_providers.dart';
import '../../study/presentation/book_intro_sheet.dart';
import '../../today/application/today_providers.dart';
import '../../translations/application/translation_controller.dart';

/// Výběr knihy: Starý / Nový zákon, barevné skupiny knih v kompaktní
/// mřížce, hledání podle názvu i zkratky („1kor“, „zalmy“) a přímý odkaz
/// („J 3,16“). Klepnutí na knihu otevře výběr kapitoly.
class BookPickerScreen extends ConsumerStatefulWidget {
  const BookPickerScreen({super.key});

  @override
  ConsumerState<BookPickerScreen> createState() => _BookPickerScreenState();
}

class _BookPickerScreenState extends ConsumerState<BookPickerScreen> {
  late Testament _testament = ref.read(readingPositionProvider).bookId >= 40
      ? Testament.newTestament
      : Testament.oldTestament;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(booksProvider);
    final primaryId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final counts =
        ref.watch(chapterCountsProvider(primaryId)).value ?? const <int, int>{};
    final read = ref.watch(readChaptersProvider).value ?? const {};
    final current = ref.watch(readingPositionProvider);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    final q = foldCzech(_query.trim());
    final reference = q.isEmpty ? null : parseReference(_query, books);
    final filtered = q.isEmpty
        ? null
        : [
            for (final b in books)
              if ((counts[b.id] ?? 0) > 0 && bookMatches(b, q)) b,
          ];

    Widget tile(Book book) => _BookTile(
      book: book,
      chapters: counts[book.id] ?? 0,
      read: read[book.id]?.length ?? 0,
      current: book.id == current.bookId,
      onTap: () => _openChapters(book, counts[book.id] ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(S.chooseBook),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: S.findBook,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: palette.card,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: palette.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: palette.cardBorder),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<Testament>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: Testament.oldTestament,
                        label: Text(S.oldTestament),
                      ),
                      ButtonSegment(
                        value: Testament.newTestament,
                        label: Text(S.newTestament),
                      ),
                    ],
                    selected: {_testament},
                    onSelectionChanged: (s) =>
                        setState(() => _testament = s.single),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          14,
          8,
          14,
          MediaQuery.paddingOf(context).bottom + 24,
        ),
        children: [
          if (reference != null)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(Icons.arrow_forward, color: palette.gold),
                title: Text(
                  '${S.goToReference} ${books[reference.bookId - 1].name} '
                  '${reference.chapter}'
                  '${reference.verse > 1 ? ',${reference.verse}' : ''}',
                ),
                onTap: () => openReaderAt(context, ref, reference),
              ),
            ),
          if (filtered != null)
            _Grid(children: [for (final b in filtered) tile(b)])
          else
            for (final category in bookCategories)
              if (category.testament == _testament) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(category.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category.name.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w700,
                          color: palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                _Grid(
                  children: [
                    for (var id = category.first; id <= category.last; id++)
                      if ((counts[id] ?? 0) > 0) tile(books[id - 1]),
                  ],
                ),
              ],
        ],
      ),
    );
  }

  void _openChapters(Book book, int count) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: count > 40 ? 0.85 : 0.6,
        maxChildSize: 0.95,
        builder: (context, controller) =>
            _ChapterSheet(book: book, count: count, controller: controller),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final columns = (c.maxWidth / 120).floor().clamp(3, 6);
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.25,
          children: children,
        );
      },
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile({
    required this.book,
    required this.chapters,
    required this.read,
    required this.current,
    required this.onTap,
  });

  final Book book;
  final int chapters;
  final int read;
  final bool current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final color = Color(categoryOf(book.id).color);
    return Material(
      color: current ? color.withValues(alpha: 0.14) : palette.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: current ? color : palette.cardBorder,
          width: current ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.abbreviation,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const Spacer(),
              // Dlouhé názvy („Deuteronomium“) se zmenší, nezalomí uprostřed.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  book.name,
                  maxLines: 1,
                  style: theme.textTheme.labelMedium?.copyWith(height: 1.15),
                ),
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: chapters == 0 ? 0 : read / chapters,
                  minHeight: 3,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterSheet extends ConsumerWidget {
  const _ChapterSheet({
    required this.book,
    required this.count,
    required this.controller,
  });

  final Book book;
  final int count;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final read = ref.watch(readChaptersProvider).value?[book.id] ?? const {};
    final current = ref.watch(readingPositionProvider);
    final intro = ref.watch(bookIntrosProvider).value?[book.id];
    final color = Color(categoryOf(book.id).color);

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.name, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 2),
                  Text(
                    S.chaptersRead(read.length, count),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => showBookIntro(context, book.id),
              icon: const Icon(Icons.auto_stories, size: 18),
              label: const Text(S.bookIntro),
            ),
          ],
        ),
        if (intro != null) ...[
          const SizedBox(height: 8),
          Text(
            intro.theme,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: palette.muted,
            ),
          ),
        ],
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 58,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: count,
          itemBuilder: (context, i) {
            final chapter = i + 1;
            final isCurrent =
                current.bookId == book.id && current.chapter == chapter;
            final isRead = read.contains(chapter);
            return Material(
              color: isCurrent
                  ? color
                  : isRead
                  ? color.withValues(alpha: 0.16)
                  : theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () =>
                    openReaderAt(context, ref, VerseRef(book.id, chapter)),
                child: Center(
                  child: Text(
                    '$chapter',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isCurrent ? Colors.white : null,
                      fontWeight: isRead || isCurrent
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
