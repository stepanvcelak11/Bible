import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/services/versification.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/user_entities.dart';
import '../../../domain/services/citation.dart';
import '../../reader/application/reader_state.dart';
import '../../shell/home_shell.dart';
import '../../reader/presentation/note_editor_sheet.dart';
import '../../prayer/application/prayer_controller.dart';
import '../../prayer/presentation/prayers_view.dart';
import '../../translations/application/translation_controller.dart';

final _bookmarksProvider = StreamProvider.autoDispose<List<Bookmark>>(
  (ref) => ref.watch(userDataRepositoryProvider).watchAllBookmarks(),
);
final _notesProvider = StreamProvider.autoDispose<List<Note>>(
  (ref) => ref.watch(userDataRepositoryProvider).watchAllNotes(),
);
final _highlightsProvider = StreamProvider.autoDispose<List<Highlight>>(
  (ref) => ref.watch(userDataRepositoryProvider).watchAllHighlights(),
);

/// Hledaný text v deníku (prázdný = vše).
class _JournalQuery extends Notifier<String> {
  @override
  String build() => '';

  void set(String q) => state = q;
}

final _queryProvider = NotifierProvider.autoDispose<_JournalQuery, String>(
  _JournalQuery.new,
);

const _fold = {
  'á': 'a', 'č': 'c', 'ď': 'd', 'é': 'e', 'ě': 'e', 'í': 'i', 'ň': 'n', //
  'ó': 'o', 'ř': 'r', 'š': 's', 'ť': 't', 'ú': 'u', 'ů': 'u', 'ý': 'y',
  'ž': 'z',
};

/// Malá písmena bez diakritiky – „Žalm“ najde i „zalm“.
String foldCs(String s) =>
    s.toLowerCase().split('').map((c) => _fold[c] ?? c).join();

/// Odpovídá položka deníku hledání? Porovnává název i zkratku knihy,
/// „kapitola,verš“ a text poznámky.
bool journalMatches(String query, Book book, VerseRef ref, {String? note}) {
  final q = foldCs(query.trim());
  if (q.isEmpty) return true;
  final hay = foldCs(
    '${book.name} ${book.abbreviation} ${ref.chapter},${ref.verse} '
    '${book.abbreviation}${ref.chapter} ${note ?? ''}',
  );
  return q.split(RegExp(r'\s+')).every(hay.contains);
}

/// Osobní deník: Záložky, Poznámky, Zvýraznění (nejnovější nahoře)
/// a modlitební seznam.
class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  bool _searching = false;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() => _searching = !_searching);
    if (!_searching) {
      _search.clear();
      ref.read(_queryProvider.notifier).set('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final top = MediaQuery.paddingOf(context).top;
    String label(String name, int? n) =>
        n == null || n == 0 ? name : '$name ($n)';
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: ReadableWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, top + 14, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            S.journal,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                        IconButton(
                          tooltip: S.journalSearch,
                          onPressed: _toggleSearch,
                          icon: Icon(_searching ? Icons.close : Icons.search),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _searching
                          ? TextField(
                              key: const ValueKey('search'),
                              controller: _search,
                              autofocus: true,
                              onChanged: ref.read(_queryProvider.notifier).set,
                              decoration: InputDecoration(
                                hintText: S.journalSearchHint,
                                prefixIcon: const Icon(Icons.search),
                                isDense: true,
                                filled: true,
                                fillColor: palette.gold.withValues(alpha: 0.08),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            )
                          : Text(
                              S.journalIntro,
                              key: const ValueKey('intro'),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: palette.muted,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                dividerColor: palette.cardBorder,
                tabs: [
                  Tab(
                    text: label(
                      S.bookmarks,
                      ref.watch(_bookmarksProvider).value?.length,
                    ),
                  ),
                  Tab(
                    text: label(
                      S.notes,
                      ref.watch(_notesProvider).value?.length,
                    ),
                  ),
                  Tab(
                    text: label(
                      S.highlights,
                      ref.watch(_highlightsProvider).value?.length,
                    ),
                  ),
                  Tab(
                    text: label(
                      S.prayers,
                      ref
                          .watch(prayerProvider)
                          .where((p) => !p.isAnswered)
                          .length,
                    ),
                  ),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    _BookmarksTab(),
                    _NotesTab(),
                    _HighlightsTab(),
                    PrayersView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _open(BuildContext context, WidgetRef ref, VerseRef target) =>
    openReaderAt(context, ref, target);

void _showUndo(BuildContext context, Future<void> Function() undo) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: const Text(S.deleted),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: S.undo, onPressed: undo),
      ),
    );
}

class _BookmarksTab extends ConsumerWidget {
  const _BookmarksTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(_queryProvider);
    final books = ref.watch(booksProvider);
    final items = ref
        .watch(_bookmarksProvider)
        .value
        ?.where((b) => journalMatches(query, books[b.ref.bookId - 1], b.ref))
        .toList();
    final repo = ref.read(userDataRepositoryProvider);
    return _List(
      icon: Icons.bookmark_outline,
      empty: query.isEmpty ? S.journalEmptyBookmarks : S.journalNoMatch,
      length: items?.length,
      itemBuilder: (context, i) {
        final b = items![i];
        return _Dismissible(
          key: ValueKey('b${b.id}'),
          onDismissed: () async {
            await repo.toggleBookmark(b.ref);
            if (context.mounted) {
              _showUndo(
                context,
                () =>
                    repo.toggleBookmark(b.ref, translationId: b.translationId),
              );
            }
          },
          child: _VerseItem(
            verseRef: b.ref,
            leading: const Icon(Icons.bookmark_outline),
            onTap: () => _open(context, ref, b.ref),
          ),
        );
      },
    );
  }
}

class _NotesTab extends ConsumerWidget {
  const _NotesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(_queryProvider);
    final books = ref.watch(booksProvider);
    final items = ref
        .watch(_notesProvider)
        .value
        ?.where(
          (n) => journalMatches(
            query,
            books[n.ref.bookId - 1],
            n.ref,
            note: n.body,
          ),
        )
        .toList();
    final repo = ref.read(userDataRepositoryProvider);
    return _List(
      icon: Icons.sticky_note_2_outlined,
      empty: query.isEmpty ? S.journalEmptyNotes : S.journalNoMatch,
      length: items?.length,
      itemBuilder: (context, i) {
        final n = items![i];
        return _Dismissible(
          key: ValueKey('n${n.id}'),
          onDismissed: () async {
            await repo.deleteNote(n.id);
            if (context.mounted) {
              _showUndo(
                context,
                () => repo
                    .saveNote(ref: n.ref, verseEnd: n.verseEnd, body: n.body)
                    .then((_) {}),
              );
            }
          },
          child: _VerseItem(
            verseRef: n.ref,
            verseEnd: n.verseEnd,
            leading: const Icon(Icons.sticky_note_2_outlined),
            note: n.body,
            onTap: () => showNoteEditor(context, existing: n),
            onOpenVerse: () => _open(context, ref, n.ref),
          ),
        );
      },
    );
  }
}

class _HighlightsTab extends ConsumerStatefulWidget {
  const _HighlightsTab();

  @override
  ConsumerState<_HighlightsTab> createState() => _HighlightsTabState();
}

class _HighlightsTabState extends ConsumerState<_HighlightsTab> {
  /// Zobrazená barva (null = všechny).
  HighlightColor? _color;

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(_queryProvider);
    final books = ref.watch(booksProvider);
    final all = ref.watch(_highlightsProvider).value;
    final colors = {for (final h in all ?? const <Highlight>[]) h.color};
    final color = colors.contains(_color) ? _color : null;
    final items = all
        ?.where(
          (h) =>
              (color == null || h.color == color) &&
              journalMatches(query, books[h.ref.bookId - 1], h.ref),
        )
        .toList();
    final repo = ref.read(userDataRepositoryProvider);
    return _List(
      icon: Icons.format_color_fill,
      empty: query.isEmpty ? S.journalEmptyHighlights : S.journalNoMatch,
      header: colors.length < 2
          ? null
          : SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text(S.journalAllColors),
                      selected: color == null,
                      onSelected: (_) => setState(() => _color = null),
                    ),
                  ),
                  for (final c in [
                    ...colors,
                  ]..sort((a, b) => a.index - b.index))
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        showCheckmark: false,
                        avatar: Icon(
                          Icons.circle,
                          color: highlightSwatches[c],
                          size: 18,
                        ),
                        label: Text(
                          '${all!.where((h) => h.color == c).length}',
                        ),
                        selected: color == c,
                        onSelected: (_) =>
                            setState(() => _color = color == c ? null : c),
                      ),
                    ),
                ],
              ),
            ),
      length: items?.length,
      itemBuilder: (context, i) {
        final h = items![i];
        return _Dismissible(
          key: ValueKey('h${h.id}'),
          onDismissed: () async {
            await repo.setHighlight(h.ref, null);
            if (context.mounted) {
              _showUndo(context, () => repo.setHighlight(h.ref, h.color));
            }
          },
          child: _VerseItem(
            verseRef: h.ref,
            leading: Icon(Icons.circle, color: highlightSwatches[h.color]),
            highlight: ReaderColors.of(context).highlights[h.color],
            onTap: () => _open(context, ref, h.ref),
          ),
        );
      },
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.icon,
    required this.empty,
    required this.length,
    required this.itemBuilder,
    this.header,
  });

  final Widget? header;
  final IconData icon;
  final String empty;
  final int? length;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final n = length;
    if (n == null) return const Center(child: CircularProgressIndicator());
    if (header case final h?) {
      return Column(
        children: [
          h,
          Expanded(
            child: _List(
              icon: icon,
              empty: empty,
              length: n,
              itemBuilder: itemBuilder,
            ),
          ),
        ],
      );
    }
    if (n == 0) {
      final theme = Theme.of(context);
      final palette = AppPalette.of(context);
      return Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 120),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: palette.gold.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: palette.gold),
              ),
              const SizedBox(height: 16),
              Text(
                empty,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.only(
        top: 8,
        // Pod plovoucí navigací.
        bottom: MediaQuery.paddingOf(context).bottom + 110,
      ),
      itemCount: n,
      separatorBuilder: (_, _) => const Divider(indent: 64),
      itemBuilder: itemBuilder,
    );
  }
}

class _Dismissible extends StatelessWidget {
  const _Dismissible({
    required super.key,
    required this.onDismissed,
    required this.child,
  });

  final Future<void> Function() onDismissed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: key!,
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        color: scheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Icon(Icons.delete_outline, color: scheme.onErrorContainer),
      ),
      child: child,
    );
  }
}

/// Položka deníku: odkaz + text verše (v hlavním překladu) + poznámka.
class _VerseItem extends ConsumerWidget {
  const _VerseItem({
    required this.verseRef,
    required this.leading,
    required this.onTap,
    this.verseEnd,
    this.note,
    this.highlight,
    this.onOpenVerse,
  });

  final VerseRef verseRef;
  final int? verseEnd;
  final Widget leading;
  final String? note;
  final Color? highlight;
  final VoidCallback onTap;
  final VoidCallback? onOpenVerse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final book = ref.watch(bookByIdProvider(verseRef.bookId));
    final translationId = ref.watch(primaryTranslationProvider).id;
    // Uložené odkazy jsou kanonické; text se načte v číslování překladu.
    final verse = ref
        .watch(
          verseTextProvider((
            translationId,
            Versification.fromCanonical(verseRef, translationId),
          )),
        )
        .value;
    final end = verseEnd ?? verseRef.verse;
    final citation = Citation.range(book.name, verseRef.chapter, [
      for (var v = verseRef.verse; v <= end; v++) v,
    ]);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTheme.merge(
              data: IconThemeData(color: theme.colorScheme.primary, size: 22),
              child: leading,
            ),
            const SizedBox(width: 22),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          citation,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      if (onOpenVerse != null)
                        InkWell(
                          onTap: onOpenVerse,
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.menu_book_outlined,
                              size: 20,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (note != null) ...[
                    const SizedBox(height: 4),
                    Text(note!, style: theme.textTheme.bodyLarge),
                  ],
                  if (verse != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      verse.text + (end > verseRef.verse ? ' …' : ''),
                      maxLines: note == null ? 4 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: note == null
                            ? null
                            : theme.colorScheme.onSurfaceVariant,
                        backgroundColor: highlight,
                        height: 1.45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
