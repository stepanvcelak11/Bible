import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/services/citation.dart';
import '../../../domain/services/timeline.dart';
import '../../shell/home_shell.dart';

/// Časová osa biblických dějin s odkazy do textu.
class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    TimelineEra? lastEra;
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.timeline)),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            4,
            16,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          children: [
            Text(
              S.timelineIntro,
              style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
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
            for (final (i, e) in timelineEvents.indexed) ...[
              if (e.era != lastEra) ...[
                Padding(
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
              ],
              _EventTile(
                event: e,
                isLast:
                    i == timelineEvents.length - 1 ||
                    timelineEvents[i + 1].era != e.era,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EventTile extends ConsumerWidget {
  const _EventTile({required this.event, required this.isLast});

  final TimelineEvent event;
  final bool isLast;

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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    if (event.refs.isNotEmpty) const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final r in event.refs)
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
