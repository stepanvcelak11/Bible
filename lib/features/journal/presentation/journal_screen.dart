import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../prep/presentation/prep_screen.dart';
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
import '../../reader/presentation/reflection_sheet.dart';
import '../../prayer/application/prayer_controller.dart';
import '../../prayer/presentation/prayers_view.dart';
import '../../memory/presentation/memory_screen.dart';
import '../../progress/presentation/progress_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../today/presentation/plans_sheet.dart';
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
    final compact = isCompactHeight(context);
    final counts = [
      ref.watch(_bookmarksProvider).value?.length,
      ref.watch(_notesProvider).value?.length,
      ref.watch(_highlightsProvider).value?.length,
      ref.watch(prayerProvider).where((p) => !p.isAnswered).length,
    ];
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: ReadableWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  top + (compact ? 4 : 14),
                  12,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.journal,
                        style: compact
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.headlineMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: S.journalSearch,
                      onPressed: _toggleSearch,
                      icon: Icon(_searching ? Icons.close : Icons.search),
                    ),
                    IconButton(
                      tooltip: S.settings,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.tune),
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: _searching
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
                        child: TextField(
                          controller: _search,
                          autofocus: true,
                          onChanged: ref.read(_queryProvider.notifier).set,
                          decoration: InputDecoration(
                            hintText: S.journalSearchHint,
                            prefixIcon: Icon(Icons.search, color: palette.gold),
                            isDense: true,
                            filled: true,
                            fillColor: palette.card,
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
                      )
                    : compact
                    ? const SizedBox(width: double.infinity)
                    : const Padding(
                        padding: EdgeInsets.fromLTRB(16, 6, 16, 0),
                        child: _ToolsRow(),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: _SectionTabs(counts: counts),
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

/// Rychlé nástroje deníku: čtyři stejně široká tlačítka s ikonou.
class _ToolsRow extends StatelessWidget {
  const _ToolsRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final tools = [
      (
        S.prepsShort,
        Icons.edit_note,
        const Color(0xFFB0603A),
        () => openPreps(context),
      ),
      (
        S.journalQuickProgress,
        Icons.insights,
        const Color(0xFF3E8E5E),
        () => openProgress(context),
      ),
      (
        S.memory,
        Icons.psychology_outlined,
        const Color(0xFF7A55A8),
        () => openMemory(context),
      ),
      (
        S.journalQuickPlan,
        Icons.event_note_outlined,
        const Color(0xFF3F7CAC),
        () => showPlansSheet(context),
      ),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (label, icon, color, onTap) in tools)
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 2,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.13),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(icon, size: 21, color: color),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelSmall?.copyWith(
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Přepínač částí deníku: čtyři dlaždice s počtem (spojené s TabBarView,
/// takže funguje i přejetí prstem mezi částmi).
class _SectionTabs extends StatelessWidget {
  const _SectionTabs({required this.counts});

  final List<int?> counts;

  static const _sections = [
    (S.bookmarks, Icons.bookmark_outline, Icons.bookmark, Color(0xFFB0813B)),
    (
      S.notes,
      Icons.sticky_note_2_outlined,
      Icons.sticky_note_2,
      Color(0xFF3F7CAC),
    ),
    (
      S.highlights,
      Icons.format_color_fill_outlined,
      Icons.format_color_fill,
      Color(0xFF5B8A3A),
    ),
    (
      S.prayers,
      Icons.volunteer_activism_outlined,
      Icons.volunteer_activism,
      Color(0xFF8C4A6B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = DefaultTabController.of(context);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Row(
        children: [
          for (final (i, (label, icon, iconOn, color)) in _sections.indexed)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Semantics(
                  key: ValueKey('journal-section-$i'),
                  button: true,
                  selected: controller.index == i,
                  label: '$label ${counts[i] ?? 0}',
                  excludeSemantics: true,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: controller.index == i
                          ? Color.alphaBlend(
                              color.withValues(alpha: 0.16),
                              palette.card,
                            )
                          : palette.card,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: controller.index == i
                            ? color.withValues(alpha: 0.55)
                            : palette.cardBorder,
                        width: controller.index == i ? 1.4 : 1,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => controller.animateTo(i),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 10, 8, 9),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  controller.index == i ? iconOn : icon,
                                  size: 18,
                                  color: color,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${counts[i] ?? 0}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: controller.index == i
                                        ? color
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: controller.index == i
                                    ? theme.colorScheme.onSurface
                                    : palette.muted,
                                fontWeight: controller.index == i
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
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

enum _NoteKind { all, reflections, notes }

const _monthNames = [
  'Leden', 'Únor', 'Březen', 'Duben', 'Květen', 'Červen', //
  'Červenec', 'Srpen', 'Září', 'Říjen', 'Listopad', 'Prosinec',
];

/// Poznámky a zamyšlení: krátké řádky (odkaz + začátek textu), filtr
/// podle druhu a dvě řazení – nejnovější po měsících, nebo podle knih
/// Bible (sbalené, aby i stovky kapitol zůstaly přehledné).
class _NotesTab extends ConsumerStatefulWidget {
  const _NotesTab();

  @override
  ConsumerState<_NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends ConsumerState<_NotesTab> {
  var _kind = _NoteKind.all;
  var _byBook = false;
  final _open = <int>{};

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(_queryProvider);
    final books = ref.watch(booksProvider);
    final all = ref.watch(_notesProvider).value;
    final reflections = all?.where((n) => isReflectionNote(n.body)).length;
    final items = all
        ?.where(
          (n) =>
              switch (_kind) {
                _NoteKind.all => true,
                _NoteKind.reflections => isReflectionNote(n.body),
                _NoteKind.notes => !isReflectionNote(n.body),
              } &&
              journalMatches(
                query,
                books[n.ref.bookId - 1],
                n.ref,
                note: n.body,
              ),
        )
        .toList();
    if (items == null) return const Center(child: CircularProgressIndicator());
    if (all!.isEmpty) {
      return _List(
        icon: Icons.sticky_note_2_outlined,
        empty: query.isEmpty ? S.journalEmptyNotes : S.journalNoMatch,
        length: 0,
        itemBuilder: (_, _) => const SizedBox(),
      );
    }

    // Řádky seznamu: nadpis skupiny (měsíc / kniha) nebo poznámka.
    final rows = <Widget>[];
    if (_byBook) {
      items.sort(
        (a, b) => a.ref.bookId != b.ref.bookId
            ? a.ref.bookId - b.ref.bookId
            : a.ref.chapter != b.ref.chapter
            ? a.ref.chapter - b.ref.chapter
            : a.ref.verse - b.ref.verse,
      );
      // Při hledání vše rozbalené.
      final expandAll = query.trim().isNotEmpty;
      for (var i = 0; i < items.length;) {
        final bookId = items[i].ref.bookId;
        var j = i;
        while (j < items.length && items[j].ref.bookId == bookId) {
          j++;
        }
        final open = expandAll || _open.contains(bookId);
        rows.add(
          _GroupHeader(
            title: books[bookId - 1].name,
            count: j - i,
            expanded: open,
            onTap: expandAll
                ? null
                : () => setState(
                    () => open ? _open.remove(bookId) : _open.add(bookId),
                  ),
          ),
        );
        if (open) {
          for (final n in items.sublist(i, j)) {
            rows.add(_noteRow(n));
          }
        }
        i = j;
      }
    } else {
      (int, int)? month;
      for (final n in items) {
        final d = n.updatedAt;
        if (month != (d.year, d.month)) {
          month = (d.year, d.month);
          rows.add(
            _GroupHeader(
              title: d.year == DateTime.now().year
                  ? _monthNames[d.month - 1]
                  : '${_monthNames[d.month - 1]} ${d.year}',
            ),
          );
        }
        rows.add(_noteRow(n));
      }
    }

    final theme = Theme.of(context);
    String label(String name, int n) => '$name ($n)';
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
                  children: [
                    for (final (k, name, n) in [
                      (_NoteKind.all, S.journalAll, all.length),
                      (
                        _NoteKind.reflections,
                        S.journalReflections,
                        reflections!,
                      ),
                      (
                        _NoteKind.notes,
                        S.journalPlainNotes,
                        all.length - reflections,
                      ),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(label(name, n)),
                          selected: _kind == k,
                          onSelected: (_) => setState(() => _kind = k),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            PopupMenuButton<bool>(
              tooltip: S.journalSort,
              icon: Icon(_byBook ? Icons.menu_book_outlined : Icons.sort),
              initialValue: _byBook,
              onSelected: (v) => setState(() => _byBook = v),
              itemBuilder: (_) => [
                for (final (v, name) in [
                  (false, S.journalRecent),
                  (true, S.journalByBook),
                ])
                  CheckedPopupMenuItem(
                    value: v,
                    checked: _byBook == v,
                    child: Text(name),
                  ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
        Expanded(
          child: rows.isEmpty
              ? Center(
                  child: Text(
                    S.journalNoMatch,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(
                    top: 4,
                    bottom: MediaQuery.paddingOf(context).bottom + 110,
                  ),
                  itemCount: rows.length,
                  itemBuilder: (_, i) => rows[i],
                ),
        ),
      ],
    );
  }

  Widget _noteRow(Note n) {
    final repo = ref.read(userDataRepositoryProvider);
    return _Dismissible(
      key: ValueKey('n${n.id}'),
      onDismissed: () async {
        await repo.deleteNote(n.id);
        if (mounted) {
          _showUndo(
            context,
            () => repo
                .saveNote(ref: n.ref, verseEnd: n.verseEnd, body: n.body)
                .then((_) {}),
          );
        }
      },
      child: _NoteRow(note: n),
    );
  }
}

/// Nadpis skupiny v deníku; s [onTap] rozbalovací.
class _GroupHeader extends StatelessWidget {
  const _GroupHeader({
    required this.title,
    this.count,
    this.expanded = true,
    this.onTap,
  });

  final String title;
  final int? count;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 16, 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: palette.gold,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (count case final c?)
              Text(
                '$c',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: palette.muted,
                ),
              ),
            if (onTap != null)
              Icon(
                expanded ? Icons.expand_less : Icons.expand_more,
                size: 20,
                color: palette.muted,
              ),
          ],
        ),
      ),
    );
  }
}

/// Krátký řádek poznámky: odkaz, první řádek textu, datum. Zamyšlení se
/// otevře k pročtení, poznámka v editoru.
class _NoteRow extends ConsumerWidget {
  const _NoteRow({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final book = ref.watch(bookByIdProvider(note.ref.bookId));
    final reflection = isReflectionNote(note.body);
    final title = reflection
        ? '${book.name} ${note.ref.chapter}'
        : Citation.range(book.name, note.ref.chapter, [
            for (var v = note.ref.verse; v <= note.verseEnd; v++) v,
          ]);
    final preview = reflection
        ? parseReflection(note.body).map((qa) => qa.$2).join(' · ')
        : note.body;
    final d = note.updatedAt;
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(12, 2, 14, 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: (reflection ? palette.gold : const Color(0xFF3F7CAC))
              .withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          reflection ? Icons.self_improvement : Icons.sticky_note_2_outlined,
          size: 20,
          color: reflection ? palette.gold : const Color(0xFF3F7CAC),
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        preview.replaceAll('\n', ' '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        '${d.day}. ${d.month}.',
        style: theme.textTheme.labelSmall?.copyWith(color: palette.muted),
      ),
      onTap: () {
        if (!reflection) {
          showNoteEditor(context, existing: note);
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (route) => ReflectionNoteScreen(
              note: note,
              title: title,
              onEdit: () {
                Navigator.of(route).pop();
                showNoteEditor(context, existing: note);
              },
              onOpenChapter: () {
                Navigator.of(route).pop();
                _open(context, ref, note.ref);
              },
            ),
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
      // Posouvatelné – v nízkém panelu by se jinak nevešlo.
      return Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            40,
            isCompactHeight(context) ? 12 : 40,
            40,
            isCompactHeight(context) ? 12 : 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      palette.gold.withValues(alpha: 0.22),
                      palette.gold.withValues(alpha: 0.06),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 38, color: palette.gold),
              ),
              const SizedBox(height: 16),
              Text(
                empty,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (empty != S.journalNoMatch) ...[
                const SizedBox(height: 18),
                Consumer(
                  builder: (context, ref, _) => FilledButton.tonalIcon(
                    onPressed: () => ref
                        .read(shellTabProvider.notifier)
                        .select(AppTab.bible),
                    icon: const Icon(Icons.menu_book_outlined, size: 18),
                    label: const Text(S.journalOpenBible),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(
        top: 6,
        // Pod plovoucí navigací.
        bottom: MediaQuery.paddingOf(context).bottom + 110,
      ),
      itemCount: n + 1,
      itemBuilder: (context, i) =>
          i == n ? const _SwipeHint() : itemBuilder(context, i),
    );
  }
}

/// Drobná nápověda pod seznamem (jak položku smazat).
class _SwipeHint extends StatelessWidget {
  const _SwipeHint();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
    child: Text(
      S.journalSwipeHint,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.labelSmall
          ?.copyWith(color: AppPalette.of(context).muted),
    ),
  );
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
    final palette = AppPalette.of(context);
    final radius = BorderRadius.circular(16);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: ClipRRect(
        borderRadius: radius,
        child: Dismissible(
          key: key!,
          direction: DismissDirection.endToStart,
          onDismissed: (_) => onDismissed(),
          background: Container(
            color: scheme.errorContainer,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: Icon(Icons.delete_outline, color: scheme.onErrorContainer),
          ),
          child: Material(
            color: palette.card,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: palette.cardBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Položka deníku: odkaz + text verše (v hlavním překladu) + poznámka.
class _VerseItem extends ConsumerWidget {
  const _VerseItem({
    required this.verseRef,
    required this.leading,
    required this.onTap,
    this.highlight,
  });

  final VerseRef verseRef;
  final Widget leading;
  final Color? highlight;
  final VoidCallback onTap;

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
    final citation = Citation.range(book.name, verseRef.chapter, [
      verseRef.verse,
    ]);

    final palette = AppPalette.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 16, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTheme.merge(
              data: IconThemeData(color: palette.gold, size: 20),
              child: leading,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    citation,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: palette.gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (verse != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      verse.text,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: appFontFamily,
                        fontSize: 16,
                        height: 1.45,
                        color: theme.colorScheme.onSurface,
                        backgroundColor: highlight,
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
