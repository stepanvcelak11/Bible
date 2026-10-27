import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/reader_settings.dart';
import '../../settings/application/reader_settings_controller.dart';
import '../application/reader_state.dart';
import 'note_editor_sheet.dart';

/// Pozadí verše podle stavu: výběr > krátké podbarvení po skoku > zvýraznění.
Color? _background(
  BuildContext context, {
  required bool selected,
  required bool flashing,
  required Color? highlight,
}) {
  final colors = ReaderColors.of(context);
  if (selected) return colors.selection;
  if (flashing) return colors.flash;
  return highlight;
}

/// Sdílená logika verše: stav z providerů + klepnutí = výběr.
mixin _VerseState on ConsumerWidget {
  VerseRef get verseRef;

  ({
    bool selected,
    bool flashing,
    Color? highlight,
    bool bookmarked,
    bool hasNote,
  })
  watchState(BuildContext context, WidgetRef ref) {
    final r = verseRef;
    final id = (r.bookId, r.chapter);
    final selected = ref.watch(
      verseSelectionProvider.select(
        (s) => s.contains(r.bookId, r.chapter, r.verse),
      ),
    );
    final flashing = ref.watch(flashVerseProvider.select((f) => f == r));
    final annotations = ref.watch(chapterAnnotationsProvider(id));
    final color = annotations.highlights[r.verse];
    return (
      selected: selected,
      flashing: flashing,
      highlight: color == null
          ? null
          : ReaderColors.of(context).highlights[color],
      bookmarked: annotations.bookmarks.contains(r.verse),
      hasNote: annotations.notes.containsKey(r.verse),
    );
  }

  void onTap(WidgetRef ref) {
    HapticFeedback.selectionClick();
    ref
        .read(verseSelectionProvider.notifier)
        .toggle(verseRef.bookId, verseRef.chapter, verseRef.verse);
  }

  void openNote(BuildContext context, WidgetRef ref) {
    final notes = ref
        .read(chapterAnnotationsProvider((verseRef.bookId, verseRef.chapter)))
        .notes[verseRef.verse];
    if (notes == null || notes.isEmpty) return;
    showNoteEditor(context, existing: notes.first);
  }
}

/// Jeden verš (režim jednoho překladu).
class VerseTile extends ConsumerWidget with _VerseState {
  const VerseTile({super.key, required this.verse});

  final Verse verse;

  @override
  VerseRef get verseRef => verse.ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readerSettingsProvider);
    final state = watchState(context, ref);
    return _VerseContainer(
      background: _background(
        context,
        selected: state.selected,
        flashing: state.flashing,
        highlight: state.highlight,
      ),
      onTap: () => onTap(ref),
      child: Text.rich(
        TextSpan(
          children: [
            if (settings.showVerseNumbers)
              verseNumberSpan(context, verse.number, settings),
            ...verseTextSpans(context, verse.text),
            ..._markers(
              context,
              bookmarked: state.bookmarked,
              hasNote: state.hasNote,
              onNote: () => openNote(context, ref),
              size: settings.fontSize * 0.8,
            ),
          ],
        ),
        style: verseTextStyle(context, settings),
      ),
    );
  }
}

/// Řádek srovnání dvou překladů.
class ParallelVerseTile extends ConsumerWidget with _VerseState {
  const ParallelVerseTile({super.key, required this.row});

  final ParallelVerse row;

  @override
  VerseRef get verseRef => (row.primary ?? row.secondary)!.ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readerSettingsProvider);
    // V úzkých sloupcích o něco menší písmo.
    final compact = settings.copyWith(fontSize: settings.fontSize * 0.86);
    final state = watchState(context, ref);
    final style = verseTextStyle(context, compact);

    Widget column(Verse? verse, {required bool markers}) => Text.rich(
      TextSpan(
        children: [
          if (verse != null) ...[
            if (settings.showVerseNumbers)
              verseNumberSpan(context, row.number, compact),
            ...verseTextSpans(context, verse.text),
          ],
          if (markers)
            ..._markers(
              context,
              bookmarked: state.bookmarked,
              hasNote: state.hasNote,
              onNote: () => openNote(context, ref),
              size: compact.fontSize * 0.8,
            ),
        ],
      ),
      style: style,
    );

    return _VerseContainer(
      background: _background(
        context,
        selected: state.selected,
        flashing: state.flashing,
        highlight: state.highlight,
      ),
      onTap: () => onTap(ref),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: column(row.primary, markers: true)),
          const SizedBox(width: 14),
          Expanded(child: column(row.secondary, markers: false)),
        ],
      ),
    );
  }
}

class _VerseContainer extends StatelessWidget {
  const _VerseContainer({
    required this.background,
    required this.onTap,
    required this.child,
  });

  final Color? background;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      onLongPress: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: background ?? Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: child,
      ),
    );
  }
}

// --- Typografie verše (sdílená i s náhledem v Nastavení) --------------------

TextStyle verseTextStyle(BuildContext context, ReaderSettings settings) =>
    TextStyle(
      fontFamily: appFontFamily,
      fontSize: settings.fontSize,
      height: settings.lineHeight,
      color: ReaderColors.of(context).text,
      letterSpacing: 0.1,
    );

InlineSpan verseNumberSpan(
  BuildContext context,
  int number,
  ReaderSettings settings,
) => TextSpan(
  children: [
    TextSpan(
      text: '$number',
      style: TextStyle(
        fontSize: settings.fontSize * 0.58,
        fontWeight: FontWeight.w600,
        color: ReaderColors.of(context).verseNumber,
        fontFeatures: const [FontFeature.liningFigures()],
      ),
    ),
    // Mezera v plné velikosti písma – číslo se nelepí na text.
    const TextSpan(text: ' '),
  ],
);

final _alternative = RegExp(r'\{([^}]*)\}');

/// Text verše; alternativní čtení v BKR ve složených závorkách `{…}` se
/// zobrazí tlumeně kurzívou.
List<InlineSpan> verseTextSpans(BuildContext context, String text) {
  if (!text.contains('{')) return [TextSpan(text: text)];
  final muted = TextStyle(
    fontStyle: FontStyle.italic,
    color: ReaderColors.of(context).verseNumber,
  );
  final spans = <InlineSpan>[];
  var last = 0;
  for (final m in _alternative.allMatches(text)) {
    if (m.start > last) {
      spans.add(TextSpan(text: text.substring(last, m.start)));
    }
    spans.add(TextSpan(text: '(${m.group(1)})', style: muted));
    last = m.end;
  }
  if (last < text.length) spans.add(TextSpan(text: text.substring(last)));
  return spans;
}

List<InlineSpan> _markers(
  BuildContext context, {
  required bool bookmarked,
  required bool hasNote,
  required VoidCallback onNote,
  required double size,
}) {
  final color = ReaderColors.of(context).verseNumber;
  return [
    if (bookmarked)
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Icon(Icons.bookmark, size: size, color: color),
        ),
      ),
    if (hasNote)
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          onTap: onNote,
          child: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Icon(Icons.sticky_note_2_outlined, size: size, color: color),
          ),
        ),
      ),
  ];
}
