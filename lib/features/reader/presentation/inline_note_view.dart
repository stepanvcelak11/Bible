import 'package:flutter/material.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
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
