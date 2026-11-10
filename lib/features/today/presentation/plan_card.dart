import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/services/versification.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../application/today_providers.dart';
import '../../today/presentation/plans_sheet.dart';
import '../../content/application/content_providers.dart';
import 'plan_detail_screen.dart';

/// Aktivní plán čtení (nebo pozvání si ho vybrat).
class PlanCard extends ConsumerWidget {
  const PlanCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(planProvider).value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    if (plan == null) {
      return Card(
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
          leading: CircleAvatar(
            backgroundColor: palette.gold.withValues(alpha: 0.15),
            child: Icon(Icons.event_note, color: palette.gold),
          ),
          title: const Text(S.choosePlan),
          subtitle: const Text(S.planIntro),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => showPlansSheet(context),
        ),
      );
    }

    final day = plan.nextDay;
    final books = ref.watch(booksProvider);
    final read = ref.watch(readChaptersProvider).value ?? const {};
    // Kolik dní mělo být podle kalendáře hotovo (včetně dneška).
    final expected = (plan.calendarDay + 1).clamp(0, plan.schedule.length);
    final diff = plan.done.length - expected;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event_note, color: palette.gold),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    plan.plan.name,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: S.choosePlan,
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () => showPlansSheet(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: plan.progress,
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
              color: palette.gold,
              backgroundColor: palette.gold.withValues(alpha: 0.14),
            ),
            const SizedBox(height: 10),
            if (day == null) ...[
              const Text(S.planDone),
              TextButton(
                onPressed: () => openPlanDetail(context, plan.plan),
                child: const Text(S.planDetail),
              ),
            ] else ...[
              Text(
                '${S.planDay(day + 1, plan.schedule.length)} · '
                '${diff < -1
                    ? S.planBehind(-diff - 1)
                    : diff > 0
                    ? S.planAhead(diff)
                    : S.planOnTrack}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: palette.muted,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                planDayLabel(plan.schedule[day], books),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (planDaySummary(
                    plan.schedule[day],
                    ref.watch(reflectionsProvider).value ?? const {},
                    schemeOf(
                      ref.watch(translationControllerProvider).primaryId,
                    ),
                  )
                  case final summary when summary.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  summary.join(' '),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.muted,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final r in plan.schedule[day])
                    ActionChip(
                      avatar: read[r.bookId]?.contains(r.chapter) ?? false
                          ? Icon(
                              Icons.check_circle,
                              size: 18,
                              color: palette.gold,
                            )
                          : null,
                      label: Text(
                        '${books[r.bookId - 1].abbreviation} ${r.chapter}',
                      ),
                      onPressed: () => openReaderAt(
                        context,
                        ref,
                        r,
                        from: schemeOf(
                          ref.read(translationControllerProvider).primaryId,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                    onPressed: () => openPlanDetail(context, plan.plan),
                    child: const Text(S.planDetail),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () =>
                        ref.read(planProvider.notifier).toggleDay(day),
                    icon: const Icon(Icons.check),
                    label: const Text(S.markDone),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
