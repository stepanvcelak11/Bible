import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/citation.dart';
import '../../reader/application/reading_position_controller.dart';
import '../../translations/application/translation_controller.dart';

const _limit = 200;

typedef SearchQuery = ({
  String text,
  Testament? testament,
  String translations, // seřazená id oddělená čárkou (hodnotová rovnost)
});

/// Výsledky hledání – cache podle dotazu, takže návrat k předchozímu
/// dotazu je okamžitý.
final searchResultsProvider = FutureProvider.autoDispose
    .family<List<SearchHit>, SearchQuery>((ref, q) {
      return ref
          .watch(bibleRepositoryProvider)
          .search(
            q.text,
            translationIds: q.translations.split(',').toSet(),
            testament: q.testament,
            limit: _limit,
          );
    });

/// Offline fulltextové hledání (SQLite FTS5, bez diakritiky).
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _text = '';
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
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 280), () {
      if (mounted) setState(() => _text = value.trim());
    });
  }

  void _setTestament(Testament? t) {
    setState(() => _testament = t);
    ref.read(appPreferencesProvider).setSearchTestament(t?.code);
  }

  @override
  Widget build(BuildContext context) {
    final translations = ref.watch(translationsProvider);
    final query = (
      text: _text,
      testament: _testament,
      translations: (_translations.toList()..sort()).join(','),
    );
    final results = _text.isEmpty
        ? null
        : ref.watch(searchResultsProvider(query));

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          onSubmitted: (v) => setState(() => _text = v.trim()),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: S.searchHint,
            border: InputBorder.none,
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _text = '');
                    },
                  ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filtry: zákon + překlady.
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  const VerticalDivider(width: 16),
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
                        }),
                      ),
                    ),
                ],
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: switch (results) {
              null => const _Hint(
                icon: Icons.search,
                title: S.searchEmptyTitle,
                body: S.searchEmptyBody,
              ),
              AsyncValue(:final value?) when value.isEmpty => const _Hint(
                icon: Icons.search_off,
                title: S.searchNoResults,
                body: S.searchEmptyBody,
              ),
              AsyncValue(:final value?) => _Results(
                hits: value,
                showTranslation: _translations.length > 1,
              ),
              AsyncValue(:final error?) => Center(child: Text('$error')),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.hits, required this.showTranslation});

  final List<SearchHit> hits;
  final bool showTranslation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final translations = {
      for (final t in ref.watch(translationsProvider)) t.id: t,
    };
    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom + 16,
      ),
      itemCount: hits.length + 1,
      separatorBuilder: (_, i) =>
          i == 0 ? const SizedBox.shrink() : const Divider(indent: 20),
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text(
              S.searchResultCount(hits.length, limited: hits.length >= _limit),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        final hit = hits[i - 1];
        final book = ref.watch(bookByIdProvider(hit.verse.ref.bookId));
        final abbr = translations[hit.verse.translationId]?.abbreviation;
        return InkWell(
          onTap: () {
            final position = ref.read(readingPositionProvider.notifier);
            final controller = ref.read(translationControllerProvider.notifier);
            controller.selectPrimary(hit.verse.translationId);
            position.jumpTo(hit.verse.ref);
            Navigator.of(context).pop();
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
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  _snippet(context, hit.snippet),
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
                ),
              ],
            ),
          ),
        );
      },
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
