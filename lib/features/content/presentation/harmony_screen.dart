import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/content_entities.dart';
import '../application/content_providers.dart';
import 'passage_card.dart';

const _gospels = ['Mt', 'Mk', 'L', 'J'];
const _gospelColors = [
  Color(0xFFB0813B),
  Color(0xFF3F7CAC),
  Color(0xFF2E8B57),
  Color(0xFF8C4A6B),
];

/// Harmonie evangelií – Ježíšův život v časovém pořadí.
class HarmonyScreen extends ConsumerWidget {
  const HarmonyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(harmonyProvider).value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    var number = 0;
    return ReadableWidth(
      maxWidth: 860,
      child: Scaffold(
        appBar: AppBar(title: const Text(S.harmony)),
        body: periods == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  MediaQuery.paddingOf(context).bottom + 32,
                ),
                children: [
                  Text(
                    S.harmonyIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  for (final period in periods) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 22, 4, 8),
                      child: Text(
                        period.name.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: palette.gold,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    for (final e in period.events)
                      _EventCard(number: ++number, event: e),
                  ],
                ],
              ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.number, required this.event});

  final int number;
  final HarmonyEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    '$number',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(event.title, style: theme.textTheme.titleSmall),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const SizedBox(width: 30),
                for (final (i, p) in event.refs.indexed)
                  Expanded(
                    child: p == null
                        ? Center(
                            child: Text(
                              '—',
                              style: TextStyle(
                                color: palette.muted.withValues(alpha: 0.5),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: _RefChip(
                              gospel: _gospels[i],
                              color: _gospelColors[i],
                              passage: p,
                            ),
                          ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RefChip extends StatelessWidget {
  const _RefChip({
    required this.gospel,
    required this.color,
    required this.passage,
  });

  final String gospel;
  final Color color;
  final Passage passage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => showPassageSheet(context, passage),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Column(
            children: [
              Text(
                gospel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  passage.shortLabel,
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
