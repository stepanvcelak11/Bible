import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/morphology_cs.dart';
import '../../../domain/services/versification.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/study_entities.dart';
import '../../../domain/services/citation.dart';
import '../../maps/presentation/maps_screen.dart';
import '../../reader/application/reader_state.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../application/study_providers.dart';
import 'study_pack_screen.dart';
import '../../translations/presentation/library_screen.dart';

/// Otevře studium verše: originál slovo po slově, souvislosti, místa.
Future<void> showVerseStudy(BuildContext context, VerseRef verse) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, controller) =>
          _VerseStudySheet(verse: verse, controller: controller),
    ),
  );
}

class _VerseStudySheet extends ConsumerWidget {
  const _VerseStudySheet({required this.verse, required this.controller});

  final VerseRef verse;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookByIdProvider(verse.bookId));
    final translation = ref.watch(primaryTranslationProvider);
    final text = ref.watch(verseTextProvider((translation.id, verse))).value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final places =
        ref
            .watch(mapDataProvider)
            .value
            ?.places
            .where((p) => p.verses.contains(verse))
            .toList() ??
        const [];

    return DefaultTabController(
      length: places.isEmpty ? 3 : 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${Citation.single(book.name, verse)} · ${translation.abbreviation}',
                  style: theme.textTheme.titleLarge,
                ),
                if (text != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    text.text.replaceAll('\n', ' '),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: appFontFamily,
                      fontSize: 16,
                      height: 1.45,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ],
            ),
          ),
          TabBar(
            labelColor: theme.colorScheme.primary,
            indicatorColor: palette.gold,
            tabs: [
              const Tab(text: S.original),
              const Tab(text: S.crossRefs),
              const Tab(text: S.tabTranslations),
              if (places.isNotEmpty) const Tab(text: S.tabMaps),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _OriginalTab(verse: verse, controller: controller),
                _CrossRefsTab(verse: verse),
                _TranslationsTab(verse: verse),
                if (places.isNotEmpty)
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (final p in places)
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.place, color: palette.gold),
                            title: Text(p.place.name),
                            subtitle: Text(S.mentions(p.place.verseCount)),
                            trailing: const Icon(Icons.map_outlined),
                            onTap: () => openPlaceOnMap(context, p.place.id),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OriginalTab extends ConsumerWidget {
  const _OriginalTab({required this.verse, required this.controller});

  final VerseRef verse;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(studyRepositoryProvider);
    if (repo == null) {
      return ListView(
        controller: controller,
        padding: const EdgeInsets.all(16),
        children: const [StudyPackCard()],
      );
    }
    final translationId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final words = ref.watch(verseWordsProvider((verse, translationId)));
    final palette = AppPalette.of(context);
    return words.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) => list.isEmpty
          ? const Center(child: Text(S.noOriginal))
          : ListView.separated(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: list.length + 1,
              separatorBuilder: (_, i) => i == 0
                  ? const SizedBox(height: 4)
                  : const SizedBox(height: 8),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Text(
                    S.originalHint,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: palette.muted),
                  );
                }
                final w = list[i - 1];
                return _WordCard(word: w.word, entry: w.entry);
              },
            ),
    );
  }
}

class _WordCard extends StatelessWidget {
  const _WordCard({required this.word, required this.entry});

  final OriginalWord word;
  final LexiconEntry? entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final hebrew = word.strong.startsWith('H');
    final meaning = entry?.glossCs ?? word.english;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: word.strong.isEmpty ? null : () => showLexicon(context, word),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          child: Row(
            children: [
              SizedBox(
                width: 112,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.text,
                      textDirection: hebrew
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      style: TextStyle(
                        fontSize: hebrew ? 26 : 22,
                        height: 1.3,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      word.transliteration,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: palette.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meaning,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: entry?.glossCs != null
                            ? theme.colorScheme.onSurface
                            : palette.muted,
                      ),
                    ),
                    if (entry?.glossCs != null && word.english.isNotEmpty)
                      Text(
                        word.english,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Text(
                      describeMorphology(word.morphology, hebrew: hebrew),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: palette.gold,
                      ),
                    ),
                  ],
                ),
              ),
              if (word.strong.isNotEmpty)
                Icon(Icons.chevron_right, color: palette.muted),
            ],
          ),
        ),
      ),
    );
  }
}

/// Slovníkové heslo.
Future<void> showLexicon(BuildContext context, OriginalWord word) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, controller) =>
          _LexiconSheet(word: word, controller: controller),
    ),
  );
}

class _LexiconSheet extends ConsumerStatefulWidget {
  const _LexiconSheet({required this.word, required this.controller});

  final OriginalWord word;
  final ScrollController controller;

  @override
  ConsumerState<_LexiconSheet> createState() => _LexiconSheetState();
}

class _LexiconSheetState extends ConsumerState<_LexiconSheet> {
  bool _showOccurrences = false;

  @override
  Widget build(BuildContext context) {
    final entry = ref.watch(lexiconEntryProvider(widget.word.strong)).value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final hebrew = widget.word.strong.startsWith('H');
    final books = ref.watch(booksProvider);

    return ListView(
      controller: widget.controller,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        Center(
          child: Text(
            entry?.lemma ?? widget.word.text,
            textDirection: hebrew ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(
              fontSize: 44,
              height: 1.3,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        Center(
          child: Text(
            '${entry?.transliteration ?? widget.word.transliteration} · '
            '${widget.word.strong}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: palette.muted,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _Section(
          title: entry?.glossCs != null
              ? S.czechMeaning
              : '${S.czechMeaning} (anglicky)',
          child: Text(
            entry?.glossCs ?? entry?.glossEn ?? widget.word.english,
            style: theme.textTheme.titleLarge,
          ),
        ),
        _Section(
          title: '${S.grammar} v tomto verši',
          child: Text(
            '${describeMorphology(widget.word.morphology, hebrew: hebrew)}\n'
            '„${widget.word.english}“',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        if (entry != null) ...[
          _Section(
            title: S.englishMeaning,
            child: Text(
              entry.definition,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
            ),
          ),
          _Section(
            title: S.occurrencesCount(entry.occurrences),
            child: _showOccurrences
                ? Consumer(
                    builder: (context, ref, _) {
                      final refs =
                          ref
                              .watch(occurrencesProvider(widget.word.strong))
                              .value ??
                          const [];
                      return Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final r in refs.take(300))
                            ActionChip(
                              visualDensity: VisualDensity.compact,
                              label: Text(
                                '${books[r.bookId - 1].abbreviation} '
                                '${r.chapter},${r.verse}',
                              ),
                              onPressed: () => openReaderAt(context, ref, r),
                            ),
                        ],
                      );
                    },
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _showOccurrences = true),
                      icon: const Icon(Icons.list),
                      label: const Text(S.showOccurrences),
                    ),
                  ),
          ),
        ],
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppPalette.of(context).gold,
              letterSpacing: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

/// Verš ve všech dostupných překladech (s převodem číslování).
class _TranslationsTab extends ConsumerWidget {
  const _TranslationsTab({required this.verse});

  final VerseRef verse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final primary = ref.watch(primaryTranslationProvider);
    final book = ref.watch(bookByIdProvider(verse.bookId));
    final all = ref.watch(translationsProvider);
    final ordered = [
      primary,
      for (final t in all)
        if (t.id != primary.id) t,
    ];
    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.paddingOf(context).bottom + 16,
      ),
      children: [
        for (final t in ordered)
          Builder(
            builder: (context) {
              final target = Versification.between(verse, primary.id, t.id);
              final v = ref.watch(verseTextProvider((t.id, target))).value;
              final text = v?.text.replaceAll('\n', ' ');
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onLongPress: text == null
                      ? null
                      : () {
                          Clipboard.setData(
                            ClipboardData(
                              text:
                                  '„$text“ (${Citation.single(book.name, target)}, ${t.abbreviation})',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(S.copied)),
                          );
                        },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              t.abbreviation,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: palette.gold,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                t.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: palette.muted,
                                ),
                              ),
                            ),
                            if (target != verse)
                              Text(
                                Citation.single(book.abbreviation, target),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: palette.muted,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          text ?? '—',
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
              );
            },
          ),
        if (ordered.length < 2)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  S.translationsCompareHint,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.muted,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LibraryScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.download_outlined),
                  label: const Text(S.moreTranslations),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CrossRefsTab extends ConsumerWidget {
  const _CrossRefsTab({required this.verse});

  final VerseRef verse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(studyRepositoryProvider);
    if (repo == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [StudyPackCard()],
      );
    }
    final translationId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final refs = ref.watch(crossReferencesProvider((verse, translationId)));
    return refs.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) => list.isEmpty
          ? const Center(child: Text(S.noCrossRefs))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(indent: 16),
              itemBuilder: (context, i) =>
                  _CrossRefTile(xref: list[i], translationId: translationId),
            ),
    );
  }
}

class _CrossRefTile extends ConsumerWidget {
  const _CrossRefTile({required this.xref, required this.translationId});

  final CrossReference xref;
  final String translationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookByIdProvider(xref.target.bookId));
    final text = ref
        .watch(verseTextProvider((translationId, xref.target)))
        .value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final verses = [for (var v = xref.target.verse; v <= xref.endVerse; v++) v];
    return ListTile(
      title: Text(
        Citation.range(book.name, xref.target.chapter, verses),
        style: theme.textTheme.labelLarge?.copyWith(color: palette.gold),
      ),
      subtitle: Text(
        (text?.text.replaceAll('\n', ' ') ?? '…') +
            (xref.endVerse > xref.target.verse ? ' …' : ''),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: appFontFamily,
          fontSize: 15,
          height: 1.4,
          color: theme.colorScheme.onSurface,
        ),
      ),
      onTap: () => openReaderAt(
        context,
        ref,
        xref.target,
        from: schemeOf(translationId),
      ),
    );
  }
}
