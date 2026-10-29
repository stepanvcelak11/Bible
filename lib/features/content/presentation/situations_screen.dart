import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/content_entities.dart';
import '../application/content_providers.dart';
import 'passage_card.dart';

/// Ikony situací (podle klíče v datech).
const situationIcons = <String, IconData>{
  'sun': Icons.wb_sunny_outlined,
  'shield': Icons.shield_outlined,
  'cloud': Icons.cloud_outlined,
  'rain': Icons.water_drop_outlined,
  'person': Icons.person_outline,
  'flame': Icons.local_fire_department_outlined,
  'refresh': Icons.replay,
  'heart': Icons.favorite_border,
  'battery': Icons.battery_2_bar,
  'help': Icons.help_outline,
  'signpost': Icons.signpost_outlined,
  'mountain': Icons.landscape_outlined,
  'medical': Icons.healing_outlined,
  'candle': Icons.local_florist_outlined,
  'handshake': Icons.handshake_outlined,
  'scale': Icons.balance,
  'wallet': Icons.account_balance_wallet_outlined,
  'work': Icons.work_outline,
  'favorite': Icons.favorite_outline,
  'family': Icons.family_restroom,
  'warning': Icons.do_not_disturb_on_outlined,
  'hourglass': Icons.hourglass_empty,
  'moon': Icons.bedtime_outlined,
  'trophy': Icons.emoji_events_outlined,
  'spa': Icons.spa_outlined,
  'sunrise': Icons.wb_twilight,
  'thanks': Icons.volunteer_activism_outlined,
  'pray': Icons.self_improvement,
  'sprout': Icons.eco_outlined,
  'explore': Icons.explore_outlined,
  'compass': Icons.navigation_outlined,
};

const _groupColors = {
  'feelings': Color(0xFFB0603A),
  'life': Color(0xFF3F7CAC),
  'faith': Color(0xFF8C6BA8),
};

Color situationColor(Situation s) =>
    _groupColors[s.group] ?? const Color(0xFFB0813B);

Future<void> openSituation(BuildContext context, Situation s) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => SituationScreen(situation: s)));

/// Přehled všech situací po skupinách.
class SituationsScreen extends ConsumerWidget {
  const SituationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(situationsProvider).value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.situations)),
        body: data == null
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
                    S.situationsIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  for (final g in data.$1) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 22, 4, 10),
                      child: Text(
                        g.name.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w700,
                          color: _groupColors[g.id] ?? palette.muted,
                        ),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, c) => GridView.count(
                        crossAxisCount: (c.maxWidth / 180).floor().clamp(2, 4),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.9,
                        children: [
                          for (final s in data.$2)
                            if (s.group == g.id) SituationTile(situation: s),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class SituationTile extends StatelessWidget {
  const SituationTile({super.key, required this.situation});

  final Situation situation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = situationColor(situation);
    return Card(
      child: InkWell(
        onTap: () => openSituation(context, situation),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                situationIcons[situation.icon] ?? Icons.menu_book_outlined,
                color: color,
              ),
              const Spacer(),
              Text(
                situation.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Verše k jedné situaci.
class SituationScreen extends StatelessWidget {
  const SituationScreen({super.key, required this.situation});

  final Situation situation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = situationColor(situation);
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: Text(situation.title)),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            4,
            16,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Icon(
                    situationIcons[situation.icon] ?? Icons.menu_book_outlined,
                    color: color,
                    size: 30,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      situation.intro,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            if (situation.thoughts.isNotEmpty) ...[
              _Heading(S.situationThoughts, color: color),
              for (final t in situation.thoughts)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    t,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ),
              const SizedBox(height: 8),
              _Heading(S.situationVerses, color: color),
            ],
            for (final p in situation.passages)
              PassageCard(passage: p, accent: color),
            if (situation.steps.isNotEmpty) ...[
              const SizedBox(height: 12),
              _Heading(S.situationSteps, color: color),
              for (final (i, step) in situation.steps.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: color.withValues(alpha: 0.18),
                        child: Text(
                          '${i + 1}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(step, style: theme.textTheme.bodyLarge),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            if (situation.prayer case final prayer?) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.volunteer_activism_outlined, color: color),
                        const SizedBox(width: 8),
                        Text(
                          S.situationPrayer,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prayer,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
