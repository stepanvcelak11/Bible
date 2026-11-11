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
import '../application/reference_parser.dart';
import '../application/scene_search.dart';
import '../application/thought_search.dart';
import '../application/bible_answer.dart';
import 'app_search_results.dart';
import 'bible_answer_card.dart';
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
    // Podle myšlenky jen tehdy, když v dotazu rozpoznáme téma – jinak
    // (např. „Ježíš“) běžné hledání slov a obsahu aplikace.
    final lexicon = ref.watch(conceptLexiconProvider).value;
    final scenes = ref.watch(sceneIndexProvider).value;
    final questions = ref.watch(questionIndexProvider).value;
    final thoughtFallback =
        _thought &&
        _text.length >= 2 &&
        lexicon != null &&
        scenes != null &&
        questions != null &&
        lexicon.detect(_text).isEmpty &&
        scenes.search(_text).isEmpty &&
        pickQuestion(questions, _text) == null;
    final thought = _thought && !thoughtFallback;
    final results = _text.isEmpty || thought
        ? null
        : ref.watch(searchResultsProvider(_query));
    final counts = _text.isEmpty || thought
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
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: palette.gold.withValues(alpha: 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focus,
                      onChanged: _setText,
                      onSubmitted: (v) {
                        _setText(v, immediate: true);
                        _remember();
                      },
                      textInputAction: TextInputAction.search,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: _thought ? S.prepThoughtHint : S.searchHint,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Icon(
                            _thought
                                ? Icons.psychology_alt_outlined
                                : Icons.search,
                            color: palette.gold,
                          ),
                        ),
                        suffixIcon: _controller.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _controller.clear();
                                  _setText('', immediate: true);
                                },
                              ),
                        filled: true,
                        fillColor: palette.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: palette.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: palette.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: palette.gold,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ModeSwitch(thought: _thought, onChanged: _setThought),
                ],
              ),
            ),
          ),
          if (!thought && _text.isNotEmpty)
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
          if (thoughtFallback)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 2),
                child: Text(
                  S.thoughtFallback,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.muted,
                  ),
                ),
              ),
            ),
          if (thought)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, insets.bottom + 110),
                child: _text.length < 2
                    ? const SizedBox.shrink()
                    : ThoughtResults(text: _text),
              ),
            )
          else if (_text.isEmpty)
            const SliverToBoxAdapter(child: SizedBox.shrink())
          else ...[
            if (_text.split(' ').where((w) => w.length > 1).length >= 3)
              SliverToBoxAdapter(
                child: _ThoughtSuggestion(
                  text: _text,
                  onTap: () => _setThought(true),
                ),
              ),
            // Chytré hledání v celé aplikaci: funkce, mapy, témata,
            // kurzy, plány, zamyšlení, poznámky…
            if (_text.trim().length >= 2 && reference == null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BibleAnswerCard(query: _text, onOpen: _remember),
                ),
              ),
            if (_text.trim().length >= 2 && reference == null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppSearchResults(query: _text, onOpen: _remember),
                ),
              ),
            if (counts != null && counts.isNotEmpty && reference == null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  child: Text(
                    S.versesInBible.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: palette.muted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
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
                  when value.isEmpty &&
                      reference == null &&
                      ref.watch(appHitsProvider(_text)).isNotEmpty =>
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      16,
                      20,
                      insets.bottom + 110,
                    ),
                    child: Text(
                      S.noVersesWithWords,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: palette.muted,
                      ),
                    ),
                  ),
                ),
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

/// Přepínač režimu hledání: dvě poloviny s posuvným podkladem.
class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.thought, required this.onChanged});

  final bool thought;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    Widget half(bool value, IconData icon, String label) {
      final on = thought == value;
      final color = on ? theme.colorScheme.onSurface : palette.muted;
      return Expanded(
        child: Semantics(
          button: true,
          selected: on,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onChanged(value),
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18, color: on ? palette.gold : color),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: thought ? Alignment.centerRight : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.card,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              half(false, Icons.text_fields, S.searchWordsMode),
              half(true, Icons.psychology_alt_outlined, S.prepThoughtMode),
            ],
          ),
        ],
      ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Material(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: palette.cardBorder),
            ),
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
