import 'package:flutter/material.dart';

import '../../../core/widgets/app_sheet.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../application/glossary.dart';
import '../application/inline_notes.dart';

extension InlineNoteKindUi on InlineNoteKind {
  String get label => switch (this) {
    InlineNoteKind.context => S.noteContext,
    InlineNoteKind.curio => S.noteCurio,
    InlineNoteKind.life => S.noteLife,
    InlineNoteKind.meaning => S.noteMeaning,
  };

  IconData get icon => switch (this) {
    InlineNoteKind.context => Icons.history_edu_outlined,
    InlineNoteKind.curio => Icons.lightbulb_outline,
    InlineNoteKind.life => Icons.spa_outlined,
    InlineNoteKind.meaning => Icons.menu_book_outlined,
  };

  Color color(bool dark) => switch (this) {
    InlineNoteKind.context =>
      dark ? const Color(0xFF8DB4D9) : const Color(0xFF3F6E9A),
    InlineNoteKind.curio =>
      dark ? const Color(0xFFE0B865) : const Color(0xFFA67C1E),
    InlineNoteKind.life =>
      dark ? const Color(0xFF9CC79A) : const Color(0xFF4E7D4B),
    InlineNoteKind.meaning =>
      dark ? const Color(0xFFC6A3D1) : const Color(0xFF7D5289),
  };
}

/// Krátká poznámka mezi odstavci: sbalená ukazuje druh a nadpis,
/// klepnutím se rozbalí text.
class InlineNoteView extends StatefulWidget {
  const InlineNoteView({
    super.key,
    required this.note,
    required this.reference,
    required this.fontSize,
  });

  final InlineNote note;
  final String reference;
  final double fontSize;

  @override
  State<InlineNoteView> createState() => _InlineNoteViewState();
}

class _InlineNoteViewState extends State<InlineNoteView> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = ReaderColors.of(context);
    final dark = theme.brightness == Brightness.dark;
    final note = widget.note;
    final accent = note.kind.color(dark);
    final base = (widget.fontSize * 0.78).clamp(13.0, 22.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: accent.withValues(alpha: dark ? 0.10 : 0.07),
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: accent.withValues(alpha: 0.7),
                  width: 3,
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(note.kind.icon, size: base * 1.15, color: accent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${note.kind.label.toUpperCase()}  ',
                                style: TextStyle(
                                  fontSize: base * 0.72,
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.w700,
                                  color: accent,
                                ),
                              ),
                              TextSpan(
                                text: note.title,
                                style: TextStyle(
                                  fontSize: base,
                                  fontWeight: FontWeight.w600,
                                  color: colors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _open ? 0.5 : 0,
                        duration: const Duration(milliseconds: 220),
                        child: Icon(
                          Icons.expand_more,
                          size: base * 1.3,
                          color: colors.verseNumber,
                        ),
                      ),
                    ],
                  ),
                  if (_open) ...[
                    const SizedBox(height: 6),
                    Padding(
                      padding: EdgeInsets.only(left: base * 1.15 + 8, right: 6),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: note.text),
                            TextSpan(
                              text: '  (${widget.reference})',
                              style: TextStyle(
                                color: colors.verseNumber,
                                fontSize: base * 0.82,
                              ),
                            ),
                          ],
                        ),
                        style: TextStyle(
                          fontSize: base,
                          height: 1.5,
                          color: colors.text.withValues(alpha: 0.88),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Poznámky a hesla slovníčku k jednotlivým veršům kapitoly
/// (číslo verše ve zvoleném překladu → doplňky).
class VerseExtras {
  const VerseExtras(this.notes, this.glossary);

  final List<InlineNote> notes;
  final List<GlossaryEntry> glossary;

  bool get isEmpty => notes.isEmpty && glossary.isEmpty;
}

/// Zpřístupní doplňky veršů odstavcům a verším kapitoly.
class VerseExtrasScope extends InheritedWidget {
  const VerseExtrasScope({
    super.key,
    required this.extras,
    required this.bookId,
    required this.chapter,
    required this.bookName,
    required super.child,
  });

  final Map<int, VerseExtras> extras;
  final int bookId;
  final int chapter;
  final String bookName;

  static VerseExtrasScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VerseExtrasScope>();

  @override
  bool updateShouldNotify(VerseExtrasScope old) =>
      old.extras != extras || old.bookId != bookId || old.chapter != chapter;
}

/// Doplňky kapitoly: poznámky (v číslování překladu) a hesla slovníčku
/// rozpoznaná v textu – každé heslo jen u prvního výskytu v kapitole.
Map<int, VerseExtras> buildVerseExtras(
  Map<int, List<InlineNote>> notes,
  Iterable<(int, String)> verses,
  int bookId,
) {
  final seen = <GlossaryEntry>{};
  final out = <int, VerseExtras>{};
  for (final (n, text) in verses) {
    final g = [
      for (final e in glossaryFor(text, bookId: bookId))
        if (seen.add(e)) e,
    ];
    final ns = notes[n] ?? const <InlineNote>[];
    if (g.isNotEmpty || ns.isNotEmpty) out[n] = VerseExtras(ns, g);
  }
  return out;
}

/// Malá značka za veršem: barevné tečky podle druhu a šipka. Klepnutí
/// otevře panel s poznámkami.
InlineSpan? verseExtrasSpan(BuildContext context, int verse, double fontSize) {
  final scope = VerseExtrasScope.of(context);
  final extras = scope?.extras[verse];
  if (scope == null || extras == null || extras.isEmpty) return null;
  final dark = Theme.of(context).brightness == Brightness.dark;
  final kinds = <Color>[
    for (final k in {
      for (final n in extras.notes) n.kind,
      if (extras.glossary.isNotEmpty) InlineNoteKind.context,
    })
      k.color(dark),
  ];
  final main = kinds.first;
  final size = (fontSize * 0.78).clamp(13.0, 22.0);
  return WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: Semantics(
      button: true,
      label: S.verseNotesFor(verse),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => showVerseExtras(context, scope, verse, extras),
        child: Padding(
          // Větší plocha pro prst, než je vidět.
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: size * 0.35, vertical: 1),
            decoration: BoxDecoration(
              color: main.withValues(alpha: dark ? 0.18 : 0.12),
              borderRadius: BorderRadius.circular(size),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final c in kinds.take(3))
                  Container(
                    width: size * 0.42,
                    height: size * 0.42,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                  ),
                Icon(Icons.chevron_right, size: size, color: main),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// Panel s poznámkami a vysvětlením pojmů k verši.
Future<void> showVerseExtras(
  BuildContext context,
  VerseExtrasScope scope,
  int verse,
  VerseExtras extras,
) => showAppSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final dark = theme.brightness == Brightness.dark;
    Widget entry(
      Color color,
      IconData icon,
      String label,
      String title,
      String text,
    ) => Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: dark ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(text, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
        ],
      ),
    );
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
          Text(
            '${scope.bookName} ${scope.chapter},$verse',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            S.verseNotesIntro,
            style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
          const SizedBox(height: 14),
          for (final n in extras.notes)
            entry(
              n.kind.color(dark),
              n.kind.icon,
              n.kind.label,
              n.title,
              n.text,
            ),
          for (final g in extras.glossary)
            entry(
              InlineNoteKind.context.color(dark),
              Icons.menu_book_outlined,
              S.glossaryLabel,
              g.title,
              g.text,
            ),
        ],
      ),
    );
  },
);
