import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/application/reader_settings_controller.dart';
import '../application/reader_blocks.dart';
import '../application/reader_state.dart';
import 'note_editor_sheet.dart';
import 'verse_tile.dart' show verseTextStyle;

/// Nadpis oddílu v textu (z překladů jako B21).
class HeadingView extends ConsumerWidget {
  const HeadingView({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readerSettingsProvider);
    final colors = ReaderColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 18, 6, 6),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: appFontFamily,
          fontSize: settings.fontSize * 0.92,
          fontWeight: FontWeight.w700,
          height: 1.3,
          color: colors.text,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Odstavec textu: verše sázené za sebou jako v tištěné Bibli.
///
/// Každý verš je samostatný úsek textu s vlastním rozpoznávačem klepnutí
/// (výběr verše) a vlastním pozadím (zvýraznění / výběr / podbarvení po
/// skoku). Poznámky překladatelů jsou malé klikací značky za veršem.
class ParagraphView extends ConsumerStatefulWidget {
  const ParagraphView({
    super.key,
    required this.block,
    required this.bookId,
    required this.chapter,
    this.footnotes = const {},
  });

  final ParagraphBlock block;
  final int bookId;
  final int chapter;
  final Map<int, List<String>> footnotes;

  @override
  ConsumerState<ParagraphView> createState() => _ParagraphViewState();
}

class _ParagraphViewState extends ConsumerState<ParagraphView> {
  final _recognizers = <Object, TapGestureRecognizer>{};

  TapGestureRecognizer _tap(Object key, VoidCallback onTap) {
    return (_recognizers[key] ??= TapGestureRecognizer())..onTap = onTap;
  }

  @override
  void dispose() {
    for (final r in _recognizers.values) {
      r.dispose();
    }
    super.dispose();
  }

  void _toggle(int verse) {
    HapticFeedback.selectionClick();
    ref
        .read(verseSelectionProvider.notifier)
        .toggle(widget.bookId, widget.chapter, verse);
  }

  void _showFootnotes(int verse, List<String> notes) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _FootnoteSheet(
        title: '${S.footnote} · ${S.verse.toLowerCase()} $verse',
        notes: notes,
      ),
    );
  }

  void _openNote(int verse) {
    final notes = ref
        .read(chapterAnnotationsProvider((widget.bookId, widget.chapter)))
        .notes[verse];
    if (notes != null && notes.isNotEmpty) {
      showNoteEditor(context, existing: notes.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(readerSettingsProvider);
    final colors = ReaderColors.of(context);
    final palette = AppPalette.of(context);
    final id = (widget.bookId, widget.chapter);
    final annotations = ref.watch(chapterAnnotationsProvider(id));
    final selection = ref.watch(verseSelectionProvider);
    final flash = ref.watch(flashVerseProvider);
    final base = verseTextStyle(context, settings);
    final markerSize = settings.fontSize * 0.75;

    final spans = <InlineSpan>[];
    for (final (index, verse) in widget.block.verses.indexed) {
      final n = verse.number;
      final selected = selection.contains(widget.bookId, widget.chapter, n);
      final flashing = flash == verse.ref;
      final highlight = annotations.highlights[n];
      final background = selected
          ? colors.selection
          : flashing
          ? colors.flash
          : highlight == null
          ? null
          : colors.highlights[highlight];
      final rec = _tap(n, () => _toggle(n));
      final style = TextStyle(
        backgroundColor: background,
        decoration: selected ? TextDecoration.underline : null,
        decorationColor: colors.verseNumber,
        decorationStyle: TextDecorationStyle.dotted,
      );

      if (index > 0) spans.add(const TextSpan(text: ' '));
      if (settings.showVerseNumbers) {
        spans.add(
          TextSpan(
            text: '$n ',
            recognizer: rec,
            style: TextStyle(
              fontFamily: uiFontFamily,
              fontSize: settings.fontSize * 0.55,
              fontWeight: FontWeight.w600,
              color: colors.verseNumber,
              fontFeatures: const [FontFeature.superscripts()],
            ),
          ),
        );
      }
      for (final part in _textParts(verse.text, colors.verseNumber)) {
        spans.add(
          TextSpan(
            text: part.$1,
            recognizer: rec,
            style: part.$2 == null ? style : style.merge(part.$2),
          ),
        );
      }
      if (widget.footnotes[n] case final notes?) {
        spans.add(
          TextSpan(
            text: ' ✱',
            recognizer: _tap('fn$n', () => _showFootnotes(n, notes)),
            style: TextStyle(
              fontSize: settings.fontSize * 0.6,
              color: palette.gold,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }
      if (annotations.bookmarks.contains(n)) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(
                Icons.bookmark,
                size: markerSize,
                color: palette.gold,
              ),
            ),
          ),
        );
      }
      if (annotations.notes.containsKey(n)) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () => _openNote(n),
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.sticky_note_2,
                  size: markerSize,
                  color: palette.gold,
                ),
              ),
            ),
          ),
        );
      }
    }

    final poetry = widget.block.poetry;
    // Klepnutí mimo text (konec řádku, okraj) vybere poslední verš bloku.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _toggle(widget.block.verses.last.number),
      child: Padding(
        padding: EdgeInsets.fromLTRB(poetry ? 22 : 6, 4, 6, poetry ? 6 : 10),
        child: Text.rich(TextSpan(children: spans), style: base),
      ),
    );
  }

  /// Text verše; alternativní čtení v BKR `{…}` tlumeně kurzívou.
  static List<(String, TextStyle?)> _textParts(String text, Color muted) {
    if (!text.contains('{')) return [(text, null)];
    final out = <(String, TextStyle?)>[];
    var last = 0;
    for (final m in RegExp(r'\{([^}]*)\}').allMatches(text)) {
      if (m.start > last) out.add((text.substring(last, m.start), null));
      out.add((
        '(${m.group(1)})',
        TextStyle(fontStyle: FontStyle.italic, color: muted),
      ));
      last = m.end;
    }
    if (last < text.length) out.add((text.substring(last), null));
    return out;
  }
}

class _FootnoteSheet extends StatelessWidget {
  const _FootnoteSheet({required this.title, required this.notes});

  final String title;
  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final n in notes)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(n, style: theme.textTheme.bodyLarge),
              ),
          ],
        ),
      ),
    );
  }
}
