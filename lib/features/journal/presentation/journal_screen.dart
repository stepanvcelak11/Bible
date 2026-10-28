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

/// Osobní deník: Záložky, Poznámky, Zvýraznění (nejnovější nahoře).
class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final top = MediaQuery.paddingOf(context).top;
    String label(String name, int? n) =>
        n == null || n == 0 ? name : '$name ($n)';
    return DefaultTabController(
      length: 3,
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
                    Text(S.journal, style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Text(
                      S.journalIntro,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: palette.muted,
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
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [_BookmarksTab(), _NotesTab(), _HighlightsTab()],
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
    final items = ref.watch(_bookmarksProvider).value;
    final repo = ref.read(userDataRepositoryProvider);
    return _List(
      icon: Icons.bookmark_outline,
      empty: S.journalEmptyBookmarks,
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
    final items = ref.watch(_notesProvider).value;
    final repo = ref.read(userDataRepositoryProvider);
    return _List(
      icon: Icons.sticky_note_2_outlined,
      empty: S.journalEmptyNotes,
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

class _HighlightsTab extends ConsumerWidget {
  const _HighlightsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(_highlightsProvider).value;
    final repo = ref.read(userDataRepositoryProvider);
    return _List(
      icon: Icons.format_color_fill,
      empty: S.journalEmptyHighlights,
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
  });

  final IconData icon;
  final String empty;
  final int? length;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final n = length;
    if (n == null) return const Center(child: CircularProgressIndicator());
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
