import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/citation.dart';
import '../../../domain/services/timeline.dart';
import '../../shell/home_shell.dart';

/// Otevře časovou osu, případně na události [focus] (index
/// v [timelineEvents]) – „tady čtete“.
void openTimeline(BuildContext context, {int? focus, String? note}) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TimelineScreen(focus: focus, focusNote: note),
      ),
    );

/// Časová osa biblických dějin s odkazy do textu.
class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key, this.focus, this.focusNote});

  /// Index události, na kterou se má osa posunout a zvýraznit ji.
  final int? focus;

  /// Upřesnění k právě čtené kapitole (např. kdy vznikl list).
  final String? focusNote;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final _keys = <TimelineEra, GlobalKey>{
    for (final e in TimelineEra.values) e: GlobalKey(),
  };
  final _focusKey = GlobalKey();

  /// Jen biblické události (bez světových dějin).
  bool _biblicalOnly = false;

  @override
  void initState() {
    super.initState();
    if (widget.focus != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _focusKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            alignment: 0.25,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  void _jump(TimelineEra era) {
    final ctx = _keys[era]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    TimelineEra? lastEra;
    final events = [
      for (final (i, e) in timelineEvents.indexed)
        if (!_biblicalOnly || !e.world || i == widget.focus) (i, e),
    ];
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(S.timeline),
          actions: [
            IconButton(
              tooltip: S.timelineWorld,
              isSelected: !_biblicalOnly,
              icon: const Icon(Icons.public_off_outlined),
              selectedIcon: const Icon(Icons.public),
              onPressed: () => setState(() => _biblicalOnly = !_biblicalOnly),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(44),
            child: _EraBar(onTap: _jump, focus: widget.focus),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                S.timelineIntro,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: palette.muted,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in [
                    DatingCertainty.documented,
                    DatingCertainty.approximate,
                    DatingCertainty.traditional,
                  ])
                    _CertaintyChip(c),
                ],
              ),
              const SizedBox(height: 8),
              for (final (k, (i, e)) in events.indexed) ...[
                if (e.era != lastEra)
                  Padding(
                    key: _keys[e.era],
                    padding: const EdgeInsets.fromLTRB(0, 22, 0, 6),
                    child: Text(
                      (lastEra = e.era).label.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Color(e.era.color),
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                _EventTile(
                  key: i == widget.focus ? _focusKey : null,
                  event: e,
                  focused: i == widget.focus,
                  focusNote: i == widget.focus ? widget.focusNote : null,
                  isLast:
                      k == events.length - 1 || events[k + 1].$2.era != e.era,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Řádek období nahoře: klepnutím skok na období.
class _EraBar extends StatelessWidget {
  const _EraBar({required this.onTap, this.focus});

  final void Function(TimelineEra) onTap;
  final int? focus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focusEra = focus == null ? null : timelineEvents[focus!].era;
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        children: [
          for (final era in TimelineEra.values)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onTap(era),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(era.color)
                        .withValues(alpha: era == focusEra ? 0.22 : 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: era == focusEra
                        ? Border.all(color: Color(era.color), width: 1.4)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(era.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        era == TimelineEra.between ? 'Mezi zákony' : era.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: era == focusEra ? FontWeight.w800 : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EventTile extends ConsumerWidget {
  const _EventTile({
    super.key,
    required this.event,
    required this.isLast,
    this.focused = false,
    this.focusNote,
  });

  final TimelineEvent event;
  final bool isLast;
  final bool focused;
  final String? focusNote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final books = ref.watch(booksProvider);
    final color = Color(event.era.color);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Čára osy s tečkou.
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 18),
                  // Světové dějiny: prázdné kolečko.
                  decoration: BoxDecoration(
                    color: event.world ? palette.card : color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: event.world ? palette.muted : palette.card,
                      width: 2,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : color.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: event.world ? palette.card.withValues(alpha: 0.55) : null,
              shape: focused
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: color, width: 2),
                    )
                  : null,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (focused) ...[
                      Row(
                        children: [
                          Icon(Icons.my_location, size: 15, color: color),
                          const SizedBox(width: 6),
                          Text(
                            S.timelineHere,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      if (focusNote != null)
                        Text(
                          focusNote!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: palette.muted,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      const SizedBox(height: 6),
                    ],
                    Row(
                      children: [
                        if (event.world) ...[
                          Icon(Icons.public, size: 16, color: palette.muted),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            event.world
                                ? '${S.worldHistory} · ${event.date}'
                                : event.date,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: event.world ? palette.muted : color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (event.certainty != DatingCertainty.undated)
                          _CertaintyDot(event.certainty),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(event.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                    if (_readable(event).isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        S.timelineRead,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final c in _readable(event))
                            ActionChip(
                              visualDensity: VisualDensity.compact,
                              avatar: Icon(
                                Icons.menu_book_outlined,
                                size: 16,
                                color: color,
                              ),
                              label: Text(
                                '${books[c.bookId - 1].abbreviation} '
                                        '${c.to == 999
                                            ? ''
                                            : c.from == c.to
                                            ? '${c.from}'
                                            : '${c.from}–${c.to}'}'
                                    .trim(),
                              ),
                              onPressed: () => openReaderAt(
                                context,
                                ref,
                                VerseRef(c.bookId, c.from),
                              ),
                            ),
                        ],
                      ),
                    ],
                    if (_keyRefs(event).isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        S.timelineKeyVerses,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final r in _keyRefs(event))
                          ActionChip(
                            visualDensity: VisualDensity.compact,
                            label: Text(
                              r.verse > 1
                                  ? Citation.single(
                                      books[r.bookId - 1].abbreviation,
                                      r,
                                    )
                                  : '${books[r.bookId - 1].abbreviation} '
                                        '${r.chapter}',
                            ),
                            onPressed: () => openReaderAt(context, ref, r),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Klíčová místa kromě celých kapitol, které už jsou v úsecích „Číst“.
List<VerseRef> _keyRefs(TimelineEvent e) => [
  for (final r in e.refs)
    if (r.verse > 1 || !e.chapters.any((c) => c.contains(r.bookId, r.chapter)))
      r,
];

/// Úseky kapitol k přečtení (bez jednotlivých žalmů – ty by zahltily
/// seznam; nejvýš šest úseků).
List<ChapterSpan> _readable(TimelineEvent e) => [
  for (final c in e.chapters)
    if (c.bookId != 19 || c.length > 3) c,
].take(6).toList();

String _certaintyLabel(DatingCertainty c) => switch (c) {
  DatingCertainty.documented => S.datingDocumented,
  DatingCertainty.approximate => S.datingApproximate,
  DatingCertainty.traditional => S.datingTraditional,
  DatingCertainty.undated => '',
};

IconData _certaintyIcon(DatingCertainty c) => switch (c) {
  DatingCertainty.documented => Icons.verified_outlined,
  DatingCertainty.approximate => Icons.schedule,
  _ => Icons.auto_stories_outlined,
};

class _CertaintyChip extends StatelessWidget {
  const _CertaintyChip(this.certainty);

  final DatingCertainty certainty;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Chip(
      visualDensity: VisualDensity.compact,
      avatar: Icon(_certaintyIcon(certainty), size: 16, color: palette.gold),
      label: Text(_certaintyLabel(certainty)),
    );
  }
}

class _CertaintyDot extends StatelessWidget {
  const _CertaintyDot(this.certainty);

  final DatingCertainty certainty;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Tooltip(
      message: _certaintyLabel(certainty),
      child: Icon(_certaintyIcon(certainty), size: 18, color: palette.muted),
    );
  }
}
