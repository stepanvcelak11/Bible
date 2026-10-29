import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/services/versification.dart';
import '../../search/application/reference_parser.dart';
import '../../translations/application/translation_controller.dart';
import 'prep_screen.dart' show parsePassageInput;

/// Vybere biblické místo přímo z Bible: kniha → kapitola → verše (klepnutím
/// na první a poslední verš). Zápis odkazu („J 3,16“) jde i rovnou.
/// Vrací místo v kanonickém číslování.
Future<Passage?> pickPassage(BuildContext context, {String? title}) =>
    Navigator.of(context).push<Passage>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PassagePickerScreen(title: title ?? S.prepPickTitle),
      ),
    );

final _chapterProvider = FutureProvider.autoDispose
    .family<List<Verse>, (String, int, int)>(
      (ref, k) =>
          ref.watch(bibleRepositoryProvider).getChapter(k.$1, k.$2, k.$3),
    );

class PassagePickerScreen extends ConsumerStatefulWidget {
  const PassagePickerScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<PassagePickerScreen> createState() =>
      _PassagePickerScreenState();
}

class _PassagePickerScreenState extends ConsumerState<PassagePickerScreen> {
  Book? _book;
  int? _chapter;
  int? _from;
  int? _to;
  String _query = '';
  Testament _testament = Testament.newTestament;

  void _back() => setState(() {
    if (_chapter != null) {
      _chapter = _from = _to = null;
    } else {
      _book = null;
    }
  });

  @override
  Widget build(BuildContext context) {
    final tid = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final counts =
        ref.watch(chapterCountsProvider(tid)).value ?? const <int, int>{};
    final book = _book;
    final chapter = _chapter;
    return PopScope(
      canPop: book == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: ReadableWidth(
        child: Scaffold(
          appBar: AppBar(
            leading: book == null
                ? const CloseButton()
                : BackButton(onPressed: _back),
            title: Text(
              book == null
                  ? widget.title
                  : chapter == null
                  ? book.name
                  : '${book.name} $chapter',
            ),
          ),
          body: book == null
              ? _books(counts)
              : chapter == null
              ? _chapters(book, counts[book.id] ?? 0)
              : _verses(book, chapter, tid),
          bottomNavigationBar: book != null && chapter != null
              ? _bottom(book, chapter, tid)
              : null,
        ),
      ),
    );
  }

  Widget _books(Map<int, int> counts) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final books = ref.watch(booksProvider);
    final typed = parsePassageInput(_query, books);
    final q = foldCzech(_query.trim());
    Widget tile(Book b) {
      final color = Color(categoryOf(b.id).color);
      return Material(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() {
            _book = b;
            _query = '';
          }),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  b.abbreviation,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  b.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget grid(List<Book> list) => GridView.count(
      crossAxisCount: (MediaQuery.sizeOf(context).width / 96).floor().clamp(
        4,
        8,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      childAspectRatio: 1.3,
      children: [for (final b in list) tile(b)],
    );

    return ListView(
      padding: EdgeInsets.fromLTRB(
        14,
        4,
        14,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      children: [
        TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: S.prepPickSearch,
            isDense: true,
            filled: true,
            fillColor: palette.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: palette.cardBorder),
            ),
          ),
        ),
        if (typed != null)
          Card(
            margin: const EdgeInsets.only(top: 10),
            child: ListTile(
              leading: Icon(Icons.add_circle, color: palette.gold),
              title: Text(
                '${S.add} ${typed.label(books[typed.bookId - 1].name)}',
              ),
              onTap: () => Navigator.of(context).pop(typed),
            ),
          ),
        const SizedBox(height: 10),
        if (q.isNotEmpty)
          grid([
            for (final b in books)
              if ((counts[b.id] ?? 0) > 0 && bookMatches(b, q)) b,
          ])
        else ...[
          SegmentedButton<Testament>(
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
            onSelectionChanged: (s) => setState(() => _testament = s.single),
          ),
          for (final cat in bookCategories)
            if (cat.testament == _testament) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 12, 2, 6),
                child: Text(
                  cat.name.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.muted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              grid([
                for (var id = cat.first; id <= cat.last; id++)
                  if ((counts[id] ?? 0) > 0) books[id - 1],
              ]),
            ],
        ],
      ],
    );
  }

  Widget _chapters(Book book, int count) {
    final palette = AppPalette.of(context);
    return GridView.count(
      padding: const EdgeInsets.all(14),
      crossAxisCount: (MediaQuery.sizeOf(context).width / 64).floor().clamp(
        5,
        12,
      ),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        for (var c = 1; c <= count; c++)
          Material(
            color: palette.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: palette.cardBorder),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _chapter = c),
              child: Center(
                child: Text(
                  '$c',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _verses(Book book, int chapter, String tid) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final verses = ref.watch(_chapterProvider((tid, book.id, chapter)));
    return verses.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) => ListView(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: Text(
              S.prepPickVersesHint,
              style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
            ),
          ),
          for (final v in list)
            Builder(
              builder: (context) {
                final n = v.ref.verse;
                final selected =
                    _from != null && n >= _from! && n <= (_to ?? _from!);
                return Material(
                  color: selected
                      ? palette.gold.withValues(alpha: 0.18)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() {
                      if (_from == null || _to != null || n < _from!) {
                        _from = n;
                        _to = null;
                      } else if (n == _from) {
                        _from = null;
                      } else {
                        _to = n;
                      }
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$n  ',
                              style: TextStyle(
                                color: palette.gold,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(text: v.text.replaceAll('\n', ' ')),
                          ],
                        ),
                        style: TextStyle(
                          fontFamily: appFontFamily,
                          fontSize: 17,
                          height: 1.45,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _bottom(Book book, int chapter, String tid) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    Passage canonical() {
      if (_from == null) return Passage(book.id, chapter, 0, 0);
      final a = Versification.toCanonical(
        VerseRef(book.id, chapter, _from!),
        tid,
      );
      final b = Versification.toCanonical(
        VerseRef(book.id, chapter, _to ?? _from!),
        tid,
      );
      return Passage(
        a.bookId,
        a.chapter,
        a.verse,
        b.chapter == a.chapter ? b.verse : a.verse,
      );
    }

    final label = _from == null
        ? S.prepWholeChapter
        : '${book.abbreviation} $chapter,$_from'
              '${_to != null ? '–$_to' : ''}';
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: palette.cardBorder)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.add),
              label: Text('${S.add}: $label'),
              onPressed: () => Navigator.of(context).pop(canonical()),
            ),
          ),
        ),
      ),
    );
  }
}
