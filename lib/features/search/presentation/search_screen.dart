import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/readable_width.dart';
import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/services/versification.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/services/citation.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../../study/presentation/study_hub_screen.dart';
import '../application/reference_parser.dart';
import '../application/thought_search.dart';
import 'thought_results.dart';

const _pageSize = 100;

typedef SearchQuery = ({
  String text,
  Testament? testament,
  int? bookId,
  int limit,
  String translations, // seřazená id oddělená čárkou (hodnotová rovnost)
});

/// Výsledky hledání (cache podle dotazu → návrat k dotazu je okamžitý).
final searchResultsProvider = FutureProvider.autoDispose
    .family<List<SearchHit>, SearchQuery>((ref, q) {
      return ref
          .watch(bibleRepositoryProvider)
          .search(
            q.text,
            translationIds: q.translations.split(',').toSet(),
            testament: q.testament,
            bookId: q.bookId,
            limit: q.limit,
          );
    });

/// Počty výsledků podle knih (pro filtr).
final searchCountsProvider = FutureProvider.autoDispose
    .family<Map<int, int>, SearchQuery>((ref, q) {
      return ref
          .watch(bibleRepositoryProvider)
          .searchCounts(
            q.text,
            translationIds: q.translations.split(',').toSet(),
            testament: q.testament,
          );
    });

/// Offline hledání (SQLite FTS5, bez diakritiky) + skok na biblický odkaz.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;
  String _text = '';
  int? _bookId;
  int _limit = _pageSize;

  /// Hledání podle myšlenky místo přesných slov.
  late bool _thought = ref.read(appPreferencesProvider).searchByThought;
  late Testament? _testament = switch (ref
      .read(appPreferencesProvider)
      .searchTestament) {
    'OT' => Testament.oldTestament,
    'NT' => Testament.newTestament,
    _ => null,
  };
  late Set<String> _translations = {
    ref.read(translationControllerProvider).primaryId,
  };

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _setText(String value, {bool immediate = false}) {
    _debounce?.cancel();
    void apply() {
      if (!mounted) return;
      setState(() {
        _text = value.trim();
        _bookId = null;
        _limit = _pageSize;
      });
    }

    immediate
        ? apply()
        : _debounce = Timer(const Duration(milliseconds: 280), apply);
  }

  void _remember() {
    if (_text.length >= 2) {
      ref.read(appPreferencesProvider).addRecentSearch(_text);
    }
  }

  void _setThought(bool on) {
    setState(() => _thought = on);
    ref.read(appPreferencesProvider).setSearchByThought(on);
  }

  void _setTestament(Testament? t) {
    setState(() {
      _testament = t;
      _bookId = null;
      _limit = _pageSize;
    });
    ref.read(appPreferencesProvider).setSearchTestament(t?.code);
  }

  SearchQuery get _query => (
    text: _text,
    testament: _testament,
    bookId: _bookId,
    limit: _limit,
    translations: (_translations.toList()..sort()).join(','),
  );

  @override
  Widget build(BuildContext context) {
    final translations = ref.watch(translationsProvider);
    final books = ref.watch(booksProvider);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final insets = MediaQuery.paddingOf(context);
    final reference = _text.isEmpty ? null : parseReference(_text, books);
    final results = _text.isEmpty || _thought
        ? null
        : ref.watch(searchResultsProvider(_query));
    final counts = _text.isEmpty || _thought
        ? null
        : ref
              .watch(
                searchCountsProvider((
                  text: _text,
                  testament: _testament,
                  bookId: null,
                  limit: 0,
                  translations: _query.translations,
                )),
              )
              .value;
    final total = counts?.values.fold<int>(0, (a, b) => a + b) ?? 0;

    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                insets.top + (isCompactHeight(context) ? 8 : 14),
                16,
                6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isCompactHeight(context)) ...[
                    Text(S.search, style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 12),
                  ],
                  TextField(
                    controller: _controller,
                    focusNode: _focus,
                    onChanged: _setText,
                    onSubmitted: (v) {
                      _setText(v, immediate: true);
                      _remember();
                    },
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: _thought ? S.prepThoughtHint : S.searchHint,
                      prefixIcon: Icon(
                        _thought ? Icons.psychology_alt_outlined : Icons.search,
                      ),
                      suffixIcon: _controller.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                _setText('', immediate: true);
                              },
                            ),
                      filled: true,
                      fillColor: palette.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: palette.cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: palette.cardBorder),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<bool>(
                      showSelectedIcon: false,
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.compact,
                      ),
                      segments: const [
                        ButtonSegment(
                          value: false,
                          icon: Icon(Icons.text_fields, size: 18),
                          label: Text(S.searchWordsMode),
                        ),
                        ButtonSegment(
                          value: true,
                          icon: Icon(Icons.psychology_alt_outlined, size: 18),
                          label: Text(S.prepThoughtMode),
                        ),
                      ],
                      selected: {_thought},
                      onSelectionChanged: (v) => _setThought(v.single),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!_thought)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  children: [
                    for (final (label, t) in [
                      (S.searchAll, null),
                      (S.oldTestament, Testament.oldTestament),
                      (S.newTestament, Testament.newTestament),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: _testament == t,
                          onSelected: (_) => _setTestament(t),
                        ),
                      ),
                    if (translations.length > 1) ...[
                      const VerticalDivider(width: 16, indent: 8, endIndent: 8),
                      for (final t in translations)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(t.abbreviation),
                            selected: _translations.contains(t.id),
                            onSelected: (on) => setState(() {
                              final next = {..._translations};
                              on ? next.add(t.id) : next.remove(t.id);
                              if (next.isNotEmpty) _translations = next;
                              _limit = _pageSize;
                            }),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          if (reference != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: palette.gold.withValues(alpha: 0.15),
                      child: Icon(Icons.arrow_forward, color: palette.gold),
                    ),
                    title: Text(
                      '${S.goToReference} '
                      '${Citation.single(books[reference.bookId - 1].name, reference)}',
                    ),
                    onTap: () {
                      _remember();
                      openReaderAt(
                        context,
                        ref,
                        reference,
                        from: schemeOf(
                          ref.read(translationControllerProvider).primaryId,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          if (_thought)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, insets.bottom + 110),
                child: _text.length < 2
                    ? _ThoughtIntro(
                        onPick: (q) {
                          _controller.text = q;
                          _setText(q, immediate: true);
                        },
                      )
                    : ThoughtResults(text: _text),
              ),
            )
          else if (_text.isEmpty)
            SliverToBoxAdapter(
              child: _EmptyState(
                onPick: (q) {
                  _controller.text = q;
                  _setText(q, immediate: true);
                },
              ),
            )
          else ...[
            // Postavy, situace, tabulky… se stejným slovem.
            if (_text.trim().length >= 3)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StudySearchResults(
                    query: foldCzech(_text.trim()),
                    compact: true,
                  ),
                ),
              ),
            if (_text.split(' ').where((w) => w.length > 1).length >= 3)
              SliverToBoxAdapter(
                child: _ThoughtSuggestion(
                  text: _text,
                  onTap: () => _setThought(true),
                ),
              ),
            if (counts != null && counts.isNotEmpty)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                      child: Text(
                        S.inBooks(total, counts.length),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: const Text(S.allBooks),
                              selected: _bookId == null,
                              onSelected: (_) => setState(() {
                                _bookId = null;
                                _limit = _pageSize;
                              }),
                            ),
                          ),
                          for (final e
                              in (counts.entries.toList()
                                ..sort((a, b) => a.key.compareTo(b.key))))
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: ChoiceChip(
                                avatar: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: Color(
                                    categoryOf(e.key).color,
                                  ),
                                ),
                                label: Text(
                                  '${books[e.key - 1].abbreviation} ${e.value}',
                                ),
                                selected: _bookId == e.key,
                                onSelected: (_) => setState(() {
                                  _bookId = e.key;
                                  _limit = _pageSize;
                                }),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            switch (results) {
              AsyncValue(:final value?)
                  when value.isEmpty && reference == null =>
                const SliverToBoxAdapter(
                  child: _Hint(
                    icon: Icons.search_off,
                    title: S.searchNoResults,
                    body: S.searchEmptyBody,
                  ),
                ),
              AsyncValue(:final value?) => SliverList.builder(
                itemCount: value.length + 1,
                itemBuilder: (context, i) {
                  if (i == value.length) {
                    final more = value.length >= _limit;
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        insets.bottom + 110,
                      ),
                      child: more
                          ? OutlinedButton(
                              onPressed: () =>
                                  setState(() => _limit += _pageSize),
                              child: const Text(S.loadMore),
                            )
                          : const SizedBox.shrink(),
                    );
                  }
                  return _ResultTile(
                    hit: value[i],
                    showTranslation: _translations.length > 1,
                    onOpen: _remember,
                  );
                },
              ),
              AsyncValue(:final error?) => SliverToBoxAdapter(
                child: Center(child: Text('$error')),
              ),
              _ => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            },
          ],
        ],
      ),
    );
  }
}

/// Úvod k hledání podle myšlenky s příklady.
class _ThoughtIntro extends StatelessWidget {
  const _ThoughtIntro({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.prepThoughtIntro,
          style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
        ),
        const SizedBox(height: 14),
        Text(
          S.searchThoughtExamples.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: palette.muted,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final q in S.searchThoughtSamples)
              ActionChip(
                avatar: Icon(
                  Icons.psychology_alt_outlined,
                  size: 18,
                  color: palette.gold,
                ),
                label: Text(q),
                onPressed: () => onPick(q),
              ),
          ],
        ),
      ],
    );
  }
}

/// U delšího dotazu nabídne hledání podle myšlenky (když v něm pozná téma).
class _ThoughtSuggestion extends ConsumerWidget {
  const _ThoughtSuggestion({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final concepts =
        ref.watch(conceptLexiconProvider).value?.detect(text) ?? const [];
    if (concepts.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Card(
        child: ListTile(
          leading: Icon(Icons.psychology_alt_outlined, color: palette.gold),
          title: const Text(S.searchTryThought),
          subtitle: Text(concepts.map((c) => c.label).join(' · ')),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _ResultTile extends ConsumerWidget {
  const _ResultTile({
    required this.hit,
    required this.showTranslation,
    required this.onOpen,
  });

  final SearchHit hit;
  final bool showTranslation;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final book = ref.watch(bookByIdProvider(hit.verse.ref.bookId));
    final abbr = ref
        .watch(translationsProvider)
        .where((t) => t.id == hit.verse.translationId)
        .firstOrNull
        ?.abbreviation;
    return InkWell(
      onTap: () {
        onOpen();
        final controller = ref.read(translationControllerProvider.notifier);
        controller.selectPrimary(hit.verse.translationId);
        openReaderAt(
          context,
          ref,
          hit.verse.ref,
          from: schemeOf(hit.verse.translationId),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Citation.single(book.name, hit.verse.ref) +
                  (showTranslation && abbr != null ? '  ·  $abbr' : ''),
              style: theme.textTheme.labelLarge?.copyWith(
                color: palette.gold,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text.rich(
              _snippet(context, hit.snippet.replaceAll('\n', ' ')),
              style: TextStyle(
                fontFamily: appFontFamily,
                fontSize: 16,
                height: 1.45,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Převede značky shod z FTS5 na tučné podbarvené úseky.
  static TextSpan _snippet(BuildContext context, String marked) {
    final match = TextStyle(
      fontWeight: FontWeight.w700,
      backgroundColor: ReaderColors.of(context).highlights.values.first,
    );
    final spans = <TextSpan>[];
    final parts = marked.split(SearchHit.matchStart);
    spans.add(TextSpan(text: parts.first));
    for (final part in parts.skip(1)) {
      final end = part.indexOf(SearchHit.matchEnd);
      if (end < 0) {
        spans.add(TextSpan(text: part));
        continue;
      }
      spans
        ..add(TextSpan(text: part.substring(0, end), style: match))
        ..add(TextSpan(text: part.substring(end + 1)));
    }
    return TextSpan(children: spans);
  }
}

class _EmptyState extends ConsumerStatefulWidget {
  const _EmptyState({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  ConsumerState<_EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends ConsumerState<_EmptyState> {
  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(appPreferencesProvider);
    final recent = prefs.recentSearches;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    const examples = [
      'láska',
      '„dobrý pastýř“',
      'J 3,16',
      'Ž 23',
      'David',
      'strach',
      'Velikonoce',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recent.isNotEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    S.recentSearches,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await prefs.clearRecentSearches();
                    setState(() {});
                  },
                  child: const Text(S.clear),
                ),
              ],
            ),
            for (final q in recent)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: Icon(Icons.history, color: palette.muted),
                title: Text(q),
                onTap: () => widget.onPick(q),
              ),
            const SizedBox(height: 16),
          ],
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.tips_and_updates_outlined,
                        color: palette.gold,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          S.searchEmptyTitle,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(S.searchEmptyBody, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final e in examples)
                        ActionChip(
                          label: Text(e),
                          onPressed: () => widget.onPick(e),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(icon, size: 48, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
