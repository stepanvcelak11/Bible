import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/services/plan_info.dart';
import '../../../domain/services/versification.dart';
import '../../content/application/content_providers.dart';
import '../../shell/home_shell.dart';
import '../../study/presentation/study_blocks.dart';
import '../../translations/application/translation_controller.dart';
import '../application/today_providers.dart';

Future<void> openPlanDetail(BuildContext context, ReadingPlan plan) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PlanDetailScreen(plan: plan)),
    );

/// Popis úseků jednoho dne: „Matouš 1–3“, „Žalmy 1–5 · Přísloví 1“.
String planDayLabel(List<VerseRef> day, List<Book> books) {
  final parts = <String>[];
  var i = 0;
  while (i < day.length) {
    final b = day[i].bookId;
    var j = i;
    while (j + 1 < day.length &&
        day[j + 1].bookId == b &&
        day[j + 1].chapter == day[j].chapter + 1) {
      j++;
    }
    final name = books[b - 1].name;
    parts.add(
      i == j
          ? '$name ${day[i].chapter}'
          : '$name ${day[i].chapter}–${day[j].chapter}',
    );
    i = j + 1;
  }
  return parts.join(' · ');
}

/// Shrnutí dne ze shrnutí kapitol (kanonické číslování).
List<String> planDaySummary(
  List<VerseRef> day,
  Map<int, List<ChapterReflection>> reflections,
  VerseScheme scheme,
) => [
  for (final r in day)
    if (Versification.convert(
          VerseRef(r.bookId, r.chapter, 1),
          scheme,
          VerseScheme.hebrew,
        )
        case final c when (reflections[c.bookId]?.length ?? 0) >= c.chapter)
      reflections[c.bookId]![c.chapter - 1].focus,
];

/// Co se kdy čte: pro každou knihu první a poslední den plánu, kdy se
/// čte („Matouš – dny 1–13“). `null`, když by řádků bylo moc (plány
/// s výběrem jednotlivých kapitol z celé Bible).
List<(int, int, String)>? planStages(
  List<List<VerseRef>> schedule,
  List<Book> books,
) {
  final first = <int, int>{};
  final last = <int, int>{};
  for (var d = 0; d < schedule.length; d++) {
    for (final r in schedule[d]) {
      first.putIfAbsent(r.bookId, () => d);
      last[r.bookId] = d;
    }
  }
  // Plán se v knihách vrací (výběr kapitol): přehled by nedával smysl.
  var spans = 0;
  for (final b in first.keys) {
    spans += last[b]! - first[b]! + 1;
  }
  if (first.length > 70 || spans > schedule.length * 2.5) return null;
  final order = first.keys.toList()
    ..sort((a, b) => first[a]!.compareTo(first[b]!));
  return [for (final b in order) (first[b]!, last[b]!, books[b - 1].name)];
}

/// Plán čtení: o čem je, jak probíhá, co se kdy čte a den po dni se
/// shrnutím.
class PlanDetailScreen extends ConsumerStatefulWidget {
  const PlanDetailScreen({super.key, required this.plan});

  final ReadingPlan plan;

  @override
  ConsumerState<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends ConsumerState<PlanDetailScreen> {
  int? _open;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final plan = widget.plan;
    final info = planInfoFor(plan.id);
    final translationId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final scheme = schemeOf(translationId);
    final counts = ref.watch(chapterCountsProvider(translationId)).value;
    final books = ref.watch(booksProvider);
    final reflections = ref.watch(reflectionsProvider).value ?? const {};
    final active = ref.watch(planProvider).value;
    final isActive = active?.plan.id == plan.id;
    final read = ref.watch(readChaptersProvider).value ?? const {};

    if (counts == null || books.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(plan.name)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final schedule = isActive ? active!.schedule : plan.schedule(counts);
    final chapters = schedule.fold<int>(0, (s, d) => s + d.length);
    final perDay = schedule.isEmpty ? 0.0 : chapters / schedule.length;
    final minutes = (perDay * 4).round().clamp(3, 60);
    final stages = planStages(schedule, books);
    final today = isActive ? active!.nextDay : null;
    final color = palette.gold;

    Widget stat(IconData icon, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: palette.onHero.withValues(alpha: 0.85)),
        const SizedBox(width: 6),
        Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(color: palette.onHero),
        ),
      ],
    );

    Widget dayTile(int d) {
      final day = schedule[d];
      final done = isActive && active!.done.contains(d);
      final isToday = d == today;
      final open = _open == d || isToday && _open == null;
      final summary = planDaySummary(day, reflections, scheme);
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        color: isToday ? color.withValues(alpha: 0.1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isToday ? color.withValues(alpha: 0.6) : palette.cardBorder,
          ),
        ),
        child: InkWell(
          onTap: () => setState(() => _open = open ? -1 : d),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: done
                          ? color
                          : color.withValues(alpha: 0.14),
                      foregroundColor: done ? Colors.white : color,
                      child: done
                          ? const Icon(Icons.check, size: 18)
                          : Text(
                              '${d + 1}',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isToday
                                ? '${S.planDayShort(d + 1)} · ${S.planToday}'
                                : S.planDayShort(d + 1),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isToday ? color : palette.muted,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            planDayLabel(day, books),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (summary.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              summary.join(' '),
                              maxLines: open ? null : 2,
                              overflow: open ? null : TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: palette.muted,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      open ? Icons.expand_less : Icons.expand_more,
                      color: palette.muted,
                    ),
                  ],
                ),
                if (open) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final r in day)
                        ActionChip(
                          avatar: read[r.bookId]?.contains(r.chapter) ?? false
                              ? Icon(Icons.check_circle, size: 18, color: color)
                              : const Icon(Icons.menu_book_outlined, size: 18),
                          label: Text(
                            '${books[r.bookId - 1].abbreviation} ${r.chapter}',
                          ),
                          onPressed: () =>
                              openReaderAt(context, ref, r, from: scheme),
                        ),
                    ],
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: done
                          ? TextButton.icon(
                              onPressed: () =>
                                  ref.read(planProvider.notifier).toggleDay(d),
                              icon: const Icon(Icons.undo),
                              label: const Text(S.planUndo),
                            )
                          : FilledButton.icon(
                              onPressed: () =>
                                  ref.read(planProvider.notifier).toggleDay(d),
                              icon: const Icon(Icons.check),
                              label: const Text(S.markDone),
                            ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      );
    }

    final header = <Widget>[
      Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [palette.heroStart, palette.heroEnd],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: palette.onHero,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                stat(
                  Icons.calendar_month_outlined,
                  S.daysCount(schedule.length),
                ),
                stat(Icons.menu_book_outlined, S.chaptersCount(chapters)),
                stat(Icons.schedule, S.minutesPerDay(minutes)),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: active!.progress,
                  minHeight: 6,
                  color: palette.onHero,
                  backgroundColor: palette.onHero.withValues(alpha: 0.25),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                S.planDaysDone(active.done.length, schedule.length),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: palette.onHero.withValues(alpha: 0.9),
                ),
              ),
            ] else ...[
              const SizedBox(height: 14),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: palette.onHero,
                  foregroundColor: palette.heroStart,
                ),
                onPressed: () async {
                  await ref.read(planProvider.notifier).start(plan.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(S.planStarted(plan.name))),
                    );
                  }
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text(S.startPlan),
              ),
            ],
          ],
        ),
      ),
      StudyHeading(S.planAbout, color: color, icon: Icons.info_outline),
      StudyParagraphs(info.about),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.person_outline, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                info.forWhom,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
              ),
            ),
          ],
        ),
      ),
      StudyHeading(
        S.planTips,
        color: color,
        icon: Icons.tips_and_updates_outlined,
      ),
      for (final t in info.tips)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7, right: 10),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  t,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                ),
              ),
            ],
          ),
        ),
      if (stages != null && stages.length > 1) ...[
        StudyHeading(S.planWhatWhen, color: color, icon: Icons.route_outlined),
        Card(
          child: Column(
            children: [
              for (final (i, (from, to, label)) in stages.indexed) ...[
                if (i > 0) const Divider(height: 1, indent: 16),
                ListTile(
                  dense: true,
                  title: Text(label),
                  trailing: Text(
                    from == to
                        ? S.planDayShort(from + 1)
                        : S.planDaysRange(from + 1, to + 1),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
      StudyHeading(
        S.planDayByDay,
        color: color,
        icon: Icons.view_agenda_outlined,
      ),
    ];

    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(
          title: Text(plan.name),
          actions: [
            if (isActive)
              PopupMenuButton<void>(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    onTap: () => ref.read(planProvider.notifier).stop(),
                    child: const Text(S.stopPlan),
                  ),
                ],
              ),
          ],
        ),
        body: ListView.builder(
          padding: EdgeInsets.fromLTRB(
            16,
            4,
            16,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          itemCount: header.length + schedule.length,
          itemBuilder: (context, i) =>
              i < header.length ? header[i] : dayTile(i - header.length),
        ),
      ),
    );
  }
}
