import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/content_entities.dart';
import '../../prep/presentation/prep_screen.dart';
import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/user_entities.dart';
import '../../../domain/services/citation.dart';
import '../../../domain/services/versification.dart';
import '../../translations/application/translation_controller.dart';
import '../application/chapter_content_provider.dart';
import '../application/reader_state.dart';
import '../../memory/application/memory_controller.dart';
import '../../memory/presentation/memory_screen.dart';
import '../../study/presentation/verse_study_sheet.dart';
import 'note_editor_sheet.dart';
import 'verse_image_sheet.dart';

/// Panel akcí s vybranými verši: Zvýraznit, Přidat záložku, Přidat
/// poznámku, Kopírovat, Sdílet.
class VerseActionPanel extends ConsumerWidget {
  const VerseActionPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(verseSelectionProvider);
    if (selection.isEmpty) return const SizedBox.shrink();

    final book = ref.watch(bookByIdProvider(selection.bookId));
    final annotations = ref.watch(
      chapterAnnotationsProvider((selection.bookId, selection.chapter)),
    );
    final allBookmarked = selection.verses.every(
      annotations.bookmarks.contains,
    );
    final anyHighlighted = selection.verses.any(
      annotations.highlights.containsKey,
    );
    final theme = Theme.of(context);
    final actions = _Actions(ref, context, selection);

    // Na tabletu panel jen ve středu, ne přes celou šířku.
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Material(
          color: theme.colorScheme.surfaceContainerLow,
          elevation: 12,
          shadowColor: Colors.black38,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          Citation.range(
                            book.name,
                            selection.chapter,
                            selection.verses,
                          ),
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        tooltip: S.cancelSelection,
                        icon: const Icon(Icons.close),
                        onPressed: actions.clear,
                      ),
                    ],
                  ),
                  // Barvy zvýraznění.
                  SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        for (final e in highlightSwatches.entries)
                          _ColorDot(
                            color: e.value,
                            selected: selection.verses.every(
                              (v) => annotations.highlights[v] == e.key,
                            ),
                            onTap: () => actions.highlight(e.key),
                          ),
                        if (anyHighlighted)
                          IconButton(
                            tooltip: S.removeHighlight,
                            icon: const Icon(Icons.format_color_reset_outlined),
                            onPressed: () => actions.highlight(null),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ActionButton(
                        icon: allBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        label: allBookmarked ? S.removeBookmark : S.bookmark,
                        onTap: () => actions.bookmark(remove: allBookmarked),
                      ),
                      _ActionButton(
                        icon: Icons.history_edu,
                        label: S.study,
                        tooltip: '${S.original} · ${S.crossRefs}',
                        onTap: actions.study,
                      ),
                      _ActionButton(
                        icon: Icons.sticky_note_2_outlined,
                        label: S.note,
                        tooltip: S.addNote,
                        onTap: actions.note,
                      ),
                      _ActionButton(
                        icon: Icons.psychology_outlined,
                        label: S.memoryShort,
                        tooltip: S.memory,
                        onTap: actions.memorize,
                      ),
                      _ActionButton(
                        icon: Icons.edit_note,
                        label: S.prepAction,
                        tooltip: S.prepAddTo,
                        onTap: actions.prep,
                      ),
                      _ActionButton(
                        icon: Icons.copy_rounded,
                        label: S.copy,
                        onTap: actions.copy,
                      ),
                      _ActionButton(
                        icon: Icons.ios_share,
                        label: S.share,
                        onTap: actions.share,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Provedení akcí nad aktuálním výběrem.
///
/// Každá akce si nejdřív synchronně vezme vše potřebné (repozitář, výběr,
/// navigátor…) a teprve pak výběr zruší – panel tím zmizí, takže po
/// `clear()` se už na jeho `ref`/`context` nesmí sahat.
class _Actions {
  _Actions(this.ref, this.context, this.selection);

  final WidgetRef ref;
  final BuildContext context;
  final VerseSelection selection;

  void clear() => ref.read(verseSelectionProvider.notifier).clear();

  /// Vybrané verše v kanonickém číslování (tak se ukládají).
  List<VerseRef> _canonicalRefs() {
    final translationId = ref.read(translationControllerProvider).primaryId;
    return [
      for (final r in selection.refs)
        Versification.toCanonical(r, translationId),
    ];
  }

  Future<void> highlight(HighlightColor? color) async {
    final repo = ref.read(userDataRepositoryProvider);
    final refs = _canonicalRefs();
    clear();
    HapticFeedback.lightImpact();
    for (final r in refs) {
      await repo.setHighlight(r, color);
    }
  }

  Future<void> bookmark({required bool remove}) async {
    final repo = ref.read(userDataRepositoryProvider);
    final translationId = ref.read(translationControllerProvider).primaryId;
    final existing = ref
        .read(chapterAnnotationsProvider((selection.bookId, selection.chapter)))
        .bookmarks;
    final local = selection.refs;
    final refs = _canonicalRefs();
    clear();
    HapticFeedback.lightImpact();
    for (final (i, r) in refs.indexed) {
      // Přepnout jen verše, jejichž stav se má změnit.
      if (existing.contains(local[i].verse) == remove) {
        await repo.toggleBookmark(r, translationId: translationId);
      }
    }
  }

  void study() {
    final first = selection.refs.first; // v číslování hlavního překladu
    final navigatorContext = Navigator.of(context).context;
    clear();
    showVerseStudy(navigatorContext, first);
  }

  void note() {
    final refs = _canonicalRefs();
    // Kontext obrazovky (navigátoru) – panel po clear() zmizí.
    final navigatorContext = Navigator.of(context).context;
    clear();
    showNoteEditor(
      navigatorContext,
      ref: refs.first,
      verseEnd: refs.last.chapter == refs.first.chapter
          ? refs.last.verse
          : refs.first.verse,
    );
  }

  /// Přidá výběr do přípravy kázání/programu.
  void prep() {
    final refs = _canonicalRefs();
    final navigatorContext = Navigator.of(context).context;
    final first = refs.first;
    final last = refs.lastWhere((r) => r.chapter == first.chapter);
    clear();
    addPassageToPrep(
      navigatorContext,
      ref,
      Passage(first.bookId, first.chapter, first.verse, last.verse),
    );
  }

  /// Přidá výběr k učení nazpaměť.
  void memorize() {
    final refs = _canonicalRefs();
    final messenger = ScaffoldMessenger.of(context);
    final navigatorContext = Navigator.of(context).context;
    final first = refs.first;
    final last = refs.lastWhere((r) => r.chapter == first.chapter);
    final added = ref
        .read(memoryProvider.notifier)
        .add(MemoryVerse(first, last.verse));
    clear();
    HapticFeedback.lightImpact();
    messenger.showSnackBar(
      SnackBar(
        content: Text(added ? S.memoryAdded : S.memoryAlready),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: S.open,
          onPressed: () => openMemory(navigatorContext),
        ),
      ),
    );
  }

  /// Vybrané verše hlavního překladu.
  Future<List<Verse>> _verses() async {
    final translations = ref.read(translationControllerProvider);
    final content = await ref.read(
      chapterPageProvider((
        primaryId: translations.primaryId,
        secondaryId: translations.secondaryId,
        bookId: selection.bookId,
        chapter: selection.chapter,
      )).future,
    );
    return content.primaryVerses
        .where((v) => selection.verses.contains(v.number))
        .toList();
  }

  /// Text vybraných veršů v hlavním překladu.
  Future<String?> _text() async {
    // Stejný klíč, jaký sleduje zobrazená stránka → data jsou už načtená.
    final translations = ref.read(translationControllerProvider);
    final bookName = ref.read(bookByIdProvider(selection.bookId)).name;
    final abbreviation = ref.read(primaryTranslationProvider).abbreviation;
    final content = await ref.read(
      chapterPageProvider((
        primaryId: translations.primaryId,
        secondaryId: translations.secondaryId,
        bookId: selection.bookId,
        chapter: selection.chapter,
      )).future,
    );
    final verses = content.primaryVerses
        .where((v) => selection.verses.contains(v.number))
        .toList();
    if (verses.isEmpty) return null;
    return Citation.shareText(
      bookName: bookName,
      chapter: selection.chapter,
      verses: verses,
      translationAbbreviation: abbreviation,
    );
  }

  Future<void> copy() async {
    final messenger = ScaffoldMessenger.of(context);
    final text = await _text();
    clear();
    if (text == null) return;
    await Clipboard.setData(ClipboardData(text: text));
    messenger.showSnackBar(
      const SnackBar(
        content: Text(S.copied),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Sdílení jako obrázek (karta s veršem) nebo jako text.
  Future<void> share() async {
    final navigatorContext = Navigator.of(context).context;
    final translation = ref.read(primaryTranslationProvider);
    final bookName = ref.read(bookByIdProvider(selection.bookId)).name;
    final verses = await _verses();
    final plain = await _text();
    clear();
    if (plain == null || verses.isEmpty || !navigatorContext.mounted) return;
    await showVerseImageSheet(
      navigatorContext,
      text: verses.map((v) => v.text.replaceAll('\n', ' ')).join(' '),
      citation: Citation.range(
        bookName,
        selection.chapter,
        verses.map((v) => v.number),
      ),
      translation: translation.name,
      plainShareText: plain,
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Semantics(
        button: true,
        label: S.highlight,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.onSurface
                    : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final String label;
  final String? tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: theme.textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
    return Expanded(
      child: tooltip == null
          ? button
          : Tooltip(message: tooltip, child: button),
    );
  }
}
