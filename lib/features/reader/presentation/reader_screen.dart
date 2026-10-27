import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../journal/presentation/journal_screen.dart';
import '../../navigation/presentation/book_picker_screen.dart';
import '../../search/presentation/search_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../translations/application/translation_controller.dart';
import '../../translations/presentation/translation_selector_sheet.dart';
import '../application/chapter_content_provider.dart';
import '../application/reader_state.dart';
import '../application/reading_position_controller.dart';
import 'chapter_view.dart';
import 'verse_action_panel.dart';

/// Výška horní lišty čtečky (bez bezpečné oblasti).
const readerBarHeight = 56.0;

/// Hlavní obrazovka – čtečka.
///
/// * Kapitoly se listují vodorovným přejetím (PageView).
/// * Focus Mode: lišta se při čtení (posun dolů) schová a při posunu nahoru
///   vrátí.
/// * Klepnutí na verš ho vybere a zobrazí panel akcí (zvýraznit, záložka,
///   poznámka, kopírovat, sdílet).
class ReaderScreen extends ConsumerWidget {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(controlsVisibleProvider);
    final hasSelection = ref.watch(
      verseSelectionProvider.select((s) => !s.isEmpty),
    );

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _ChapterPager()),
          // Horní lišta – vyjíždí nahoru při čtení.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedSlide(
              offset: visible || hasSelection
                  ? Offset.zero
                  : const Offset(0, -1),
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              child: const _TopBar(),
            ),
          ),
          // Panel akcí s vybranými verši.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
              child: hasSelection
                  ? const VerseActionPanel()
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(readingPositionProvider);
    final book = ref.watch(bookByIdProvider(position.bookId));
    final primary = ref.watch(primaryTranslationProvider);
    final secondary = ref.watch(secondaryTranslationProvider);
    final scheme = Theme.of(context).colorScheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return Material(
      color: scheme.surface.withValues(alpha: 0.97),
      child: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: SizedBox(
          height: readerBarHeight,
          child: Row(
            children: [
              const SizedBox(width: 4),
              // Název knihy a kapitoly → výběr knihy.
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => openBookPicker(context),
                    style: TextButton.styleFrom(
                      foregroundColor: scheme.onSurface,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            S.chapterTitle(book.name, position.chapter),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const Icon(Icons.expand_more, size: 22),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: S.search,
                icon: const Icon(Icons.search),
                onPressed: () => openSearch(context),
              ),
              Tooltip(
                message: S.selectTranslation,
                child: TextButton(
                  onPressed: () => showTranslationSelector(context),
                  style: TextButton.styleFrom(
                    foregroundColor: scheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: const Size(48, 40),
                  ),
                  child: Text(
                    secondary == null
                        ? primary.abbreviation
                        : '${primary.abbreviation} · ${secondary.abbreviation}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
              PopupMenuButton<_MenuItem>(
                tooltip: S.menu,
                icon: const Icon(Icons.more_vert),
                onSelected: (item) => switch (item) {
                  _MenuItem.journal => openJournal(context),
                  _MenuItem.settings => openSettings(context),
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: _MenuItem.journal,
                    child: ListTile(
                      leading: Icon(Icons.bookmarks_outlined),
                      title: Text(S.journal),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: _MenuItem.settings,
                    child: ListTile(
                      leading: Icon(Icons.tune),
                      title: Text(S.settings),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _MenuItem { journal, settings }

/// Vodorovné listování kapitolami.
class _ChapterPager extends ConsumerWidget {
  const _ChapterPager();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final chapters = ref.watch(chapterListProvider).value;
    if (chapters == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // Nový překlad může mít jiný seznam kapitol → nový PageView.
    return _Pager(key: ValueKey(primaryId), chapters: chapters);
  }
}

class _Pager extends ConsumerStatefulWidget {
  const _Pager({super.key, required this.chapters});

  final List<VerseRef> chapters;

  @override
  ConsumerState<_Pager> createState() => _PagerState();
}

class _PagerState extends ConsumerState<_Pager> {
  late final PageController _controller;
  late final Map<(int, int), int> _indexOf;

  @override
  void initState() {
    super.initState();
    _indexOf = {
      for (final (i, r) in widget.chapters.indexed) (r.bookId, r.chapter): i,
    };
    _controller = PageController(
      initialPage: _pageFor(ref.read(readingPositionProvider)),
    );
  }

  int _pageFor(VerseRef ref) => _indexOf[(ref.bookId, ref.chapter)] ?? 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    final target = widget.chapters[page];
    final position = ref.read(readingPositionProvider);
    ref.read(verseSelectionProvider.notifier).clear();
    ref.read(controlsVisibleProvider.notifier).show();
    if (position.bookId != target.bookId ||
        position.chapter != target.chapter) {
      ref.read(readingPositionProvider.notifier).goTo(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Skok odjinud (výběr knihy, hledání, záložka) → přepnout stránku.
    ref.listen(readingPositionProvider, (previous, next) {
      if (!_controller.hasClients) return;
      final page = _pageFor(next);
      if (page != _controller.page?.round()) _controller.jumpToPage(page);
    });

    return PageView.builder(
      controller: _controller,
      // Předběžně vykreslí sousední kapitoly → plynulé přejetí.
      allowImplicitScrolling: true,
      itemCount: widget.chapters.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, i) {
        final chapter = widget.chapters[i];
        return ChapterView(
          key: ValueKey(chapter),
          bookId: chapter.bookId,
          chapter: chapter.chapter,
        );
      },
    );
  }
}

// --- Navigace na další obrazovky -------------------------------------------

Future<void> openBookPicker(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const BookPickerScreen()));

Future<void> openSearch(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const SearchScreen()));

Future<void> openJournal(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const JournalScreen()));

Future<void> openSettings(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
