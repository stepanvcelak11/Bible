import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/services/versification.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/services/citation.dart';
import '../../reader/application/reading_position_controller.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../shell/home_shell.dart';
import '../../study/presentation/book_intros_screen.dart';
import '../../study/presentation/study_pack_screen.dart';
import '../../translations/application/translation_controller.dart';
import '../../translations/presentation/library_screen.dart';
import '../application/today_providers.dart';
import 'plans_sheet.dart';
import 'timeline_screen.dart';

const _months = [
  'ledna', 'února', 'března', 'dubna', 'května', 'června', //
  'července', 'srpna', 'září', 'října', 'listopadu', 'prosince',
];
const _weekdays = [
  'pondělí',
  'úterý',
  'středa',
  'čtvrtek',
  'pátek',
  'sobota',
  'neděle',
];

/// Úvodní obrazovka „Dnes“.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final greeting = now.hour < 10
        ? S.goodMorning
        : now.hour < 18
        ? S.goodDay
        : S.goodEvening;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final insets = MediaQuery.paddingOf(context);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        20,
        insets.top + 16,
        20,
        insets.bottom + 110,
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_weekdays[now.weekday - 1]} ${now.day}. ${_months[now.month - 1]}'
                        .toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: palette.gold,
                      letterSpacing: 1.6,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(greeting, style: theme.textTheme.headlineLarge),
                ],
              ),
            ),
            IconButton.filledTonal(
              tooltip: S.settings,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              ),
              icon: const Icon(Icons.tune),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const _VerseOfDayCard(),
        const SizedBox(height: 16),
        const _ContinueCard(),
        const SizedBox(height: 16),
        const _StatsRow(),
        const SizedBox(height: 16),
        const _PlanCard(),
        const SizedBox(height: 24),
        Text(S.explore, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        const _ExploreGrid(),
        const SizedBox(height: 24),
        const _RecentList(),
      ],
    );
  }
}

class _VerseOfDayCard extends ConsumerWidget {
  const _VerseOfDayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verse = ref.watch(verseOfDayProvider).value;
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final target = verse?.ref ?? verseOfDay(DateTime.now());
    final book = ref.watch(bookByIdProvider(target.bookId));
    final abbr = ref.watch(primaryTranslationProvider).abbreviation;
    final citation = Citation.single(book.name, target);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.heroStart, palette.heroEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: palette.heroStart.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 6,
            top: -44,
            child: Text(
              '“',
              style: TextStyle(
                fontFamily: appFontFamily,
                fontSize: 150,
                color: palette.onHero.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: palette.gold),
                    const SizedBox(width: 6),
                    Text(
                      S.verseOfDay.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: palette.gold,
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    verse?.text.replaceAll('\n', ' ') ?? '…',
                    key: ValueKey(verse?.text),
                    style: TextStyle(
                      fontFamily: appFontFamily,
                      fontSize: 20,
                      height: 1.5,
                      color: palette.onHero,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$citation · $abbr',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: palette.onHero.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: S.share,
                      color: palette.onHero,
                      icon: const Icon(Icons.ios_share),
                      onPressed: verse == null
                          ? null
                          : () => SharePlus.instance.share(
                              ShareParams(
                                text: '„${verse.text}“\n— $citation ($abbr)',
                              ),
                            ),
                    ),
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        backgroundColor: palette.onHero.withValues(alpha: 0.16),
                        foregroundColor: palette.onHero,
                      ),
                      onPressed: () => openReaderAt(
                        context,
                        ref,
                        verseOfDay(DateTime.now()),
                      ),
                      child: const Text('Číst'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueCard extends ConsumerWidget {
  const _ContinueCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(readingPositionProvider);
    final book = ref.watch(bookByIdProvider(position.bookId));
    final translation = ref.watch(primaryTranslationProvider);
    final counts =
        ref.watch(chapterCountsProvider(translation.id)).value ?? const {};
    final total = counts[position.bookId] ?? 0;
    final read =
        ref.watch(readChaptersProvider).value?[position.bookId]?.length ?? 0;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final color = Color(categoryOf(position.bookId).color);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => openReaderAt(
          context,
          ref,
          position,
          from: schemeOf(ref.read(translationControllerProvider).primaryId),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color, color.withValues(alpha: 0.7)],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  book.abbreviation,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.continueReading,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: palette.muted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${book.name} ${position.chapter}'
                      '${position.verse > 1 ? ',${position.verse}' : ''}',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: total == 0 ? 0 : read / total,
                        minHeight: 5,
                        color: color,
                        backgroundColor: color.withValues(alpha: 0.14),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${S.chaptersRead(read, total)} · ${translation.abbreviation}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: palette.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: palette.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends ConsumerWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(readingStatsProvider).value;
    final percent = ((stats?.chaptersTotal ?? 0) / 1189 * 100);
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.local_fire_department,
            iconColor: const Color(0xFFE0782F),
            value: '${stats?.streakDays ?? 0}',
            label: S.streak,
            active: stats?.readToday ?? false,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            icon: Icons.calendar_today,
            iconColor: const Color(0xFF3F7CAC),
            value: '${stats?.chaptersThisWeek ?? 0}',
            label: S.thisWeek,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            icon: Icons.donut_large,
            iconColor: const Color(0xFF4E9A8A),
            value:
                '${percent.toStringAsFixed(percent < 10 ? 1 : 0).replaceAll('.', ',')} %',
            label: S.totalRead,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.active = true,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Card(
      child: Container(
        height: 112,
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? iconColor : palette.muted.withValues(alpha: 0.6),
            ),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                style: theme.textTheme.headlineSmall?.copyWith(height: 1.1),
              ),
            ),
            SizedBox(
              height: 30,
              child: Text(
                label,
                maxLines: 2,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: palette.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends ConsumerWidget {
  const _PlanCard();

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
            if (day == null)
              const Text(S.planDone)
            else ...[
              Text(
                S.planDay(day + 1, plan.schedule.length),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: palette.muted,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final r in plan.schedule[day])
                    ActionChip(
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
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () =>
                      ref.read(planProvider.notifier).toggleDay(day),
                  icon: const Icon(Icons.check),
                  label: const Text(S.markDone),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExploreGrid extends ConsumerWidget {
  const _ExploreGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void push(Widget page) =>
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => page));
    final tiles = [
      (
        Icons.map_outlined,
        const Color(0xFF3F7CAC),
        S.exploreMaps,
        S.exploreMapsHint,
        () => ref.read(shellTabProvider.notifier).select(AppTab.maps),
      ),
      (
        Icons.auto_stories_outlined,
        const Color(0xFFB0813B),
        S.exploreIntros,
        S.exploreIntrosHint,
        () => push(const BookIntrosScreen()),
      ),
      (
        Icons.translate,
        const Color(0xFF4E9A8A),
        S.exploreTranslations,
        S.exploreTranslationsHint,
        () => push(const LibraryScreen()),
      ),
      (
        Icons.history_edu,
        const Color(0xFF8C6BA8),
        S.exploreStudy,
        S.exploreStudyHint,
        () => push(const StudyPackScreen()),
      ),
      (
        Icons.view_timeline_outlined,
        const Color(0xFFB0603A),
        S.timeline,
        S.timelineHint,
        () => push(const TimelineScreen()),
      ),
      (
        Icons.event_note_outlined,
        const Color(0xFF5B7A3A),
        S.readingPlans,
        S.readingPlansHint,
        () => showPlansSheet(context),
      ),
    ];
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 128,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final (icon, color, title, hint, onTap) in tiles)
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      hint,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: AppPalette.of(context).muted),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _RecentList extends ConsumerWidget {
  const _RecentList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentReadingProvider).value ?? const [];
    if (recent.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final books = ref.watch(booksProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.recentlyRead, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              for (final (i, (ref0, at)) in recent.indexed) ...[
                if (i > 0) const Divider(indent: 56),
                ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Color(categoryOf(ref0.bookId).color),
                  ),
                  title: Text('${books[ref0.bookId - 1].name} ${ref0.chapter}'),
                  subtitle: Text(_ago(at)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => openReaderAt(
                    context,
                    ref,
                    ref0,
                    from: schemeOf(
                      ref.read(translationControllerProvider).primaryId,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static String _ago(DateTime at) {
    final now = DateTime.now();
    final days = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(at.year, at.month, at.day)).inDays;
    return switch (days) {
      0 => 'dnes',
      1 => 'včera',
      < 5 => 'před $days dny',
      _ => '${at.day}. ${at.month}. ${at.year}',
    };
  }
}
