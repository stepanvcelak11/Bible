import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/services/versification.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/services/citation.dart';
import '../../reader/application/reading_position_controller.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../application/today_providers.dart';
import '../../content/application/content_providers.dart';
import '../../content/presentation/situations_screen.dart';
import '../../content/presentation/church_year_screen.dart';
import '../../guide/presentation/guide_screen.dart';
import '../../progress/presentation/progress_screen.dart';
import 'day_scene.dart';
import 'for_today.dart';
import 'plans_sheet.dart';

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
    final insets = MediaQuery.paddingOf(context);

    final time = dayTimeOf(now);
    final darkScene = theme.brightness == Brightness.dark;
    // Na obrázku: v noci a za soumraku světlý text, jinak tmavý.
    final onScene = time == DayTime.night || time == DayTime.dusk || darkScene
        ? Colors.white
        : const Color(0xFF2A2018);
    final heroHeight = insets.top + 270;

    return ListView(
      padding: EdgeInsets.only(bottom: insets.bottom + 110),
      children: [
        Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: heroHeight,
              // Spodní okraj obrázku se rozplyne do pozadí aplikace.
              child: ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (r) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.72, 1.0],
                  colors: [Colors.black, Colors.black, Colors.transparent],
                ).createShader(r),
                child: DayScene(time: time, dark: darkScene),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, insets.top + 12, 12, 0),
              child: Row(
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
                            color: onScene.withValues(alpha: 0.8),
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          greeting,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: onScene,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: S.guide,
                    color: onScene,
                    onPressed: () => openGuide(context),
                    icon: const Icon(Icons.help_outline),
                  ),
                  IconButton(
                    tooltip: S.settings,
                    color: onScene,
                    style: IconButton.styleFrom(
                      backgroundColor: onScene.withValues(alpha: 0.14),
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.tune),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, heroHeight - 92, 20, 0),
              child: const _VerseOfDayCard(),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionLabel(S.myReading),
              const _ContinueCard(),
              const SizedBox(height: 10),
              const _StatsRow(),
              const SizedBox(height: 10),
              const _PlanCard(),
              const ForTodaySection(),
              const _SituationsStrip(),
              const ChurchYearCard(),
              const _RecentList(),
            ],
          ),
        ),
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
    final palette = AppPalette.of(context);
    Widget divider() =>
        Container(width: 1, height: 40, color: palette.cardBorder);
    return Card(
      child: InkWell(
        onTap: () => openProgress(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
          child: Column(
            children: [
              Row(
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
                  divider(),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.calendar_today,
                      iconColor: const Color(0xFF3F7CAC),
                      value: '${stats?.chaptersThisWeek ?? 0}',
                      label: S.thisWeek,
                    ),
                  ),
                  divider(),
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
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.progress,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: palette.gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 16, color: palette.gold),
                ],
              ),
            ],
          ),
        ),
      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: active
                    ? iconColor
                    : palette.muted.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: theme.textTheme.titleLarge?.copyWith(height: 1.1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(color: palette.muted),
          ),
        ],
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
            if (day == null)
              const Text(S.planDone)
            else ...[
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
              const SizedBox(height: 8),
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

/// Odkaz do záložky Studium s ukázkou obsahu.
/// Rychlé zkratky do studijních materiálů (otevřou se rovnou).
class _SituationsStrip extends ConsumerWidget {
  const _SituationsStrip();

  static const _featured = [
    'fear',
    'anxiety',
    'sadness',
    'joy',
    'decision',
    'tired',
    'lonely',
    'gratitude',
    'guilt',
    'hope',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final all = ref.watch(situationsProvider).value?.$2 ?? const [];
    final featured = [
      for (final id in _featured) ...all.where((s) => s.id == id),
    ];
    void openAll() => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SituationsScreen()));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(S.situationsToday, action: S.all, onAction: openAll),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: featured.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final s = featured[i];
              return ActionChip(
                avatar: Icon(
                  situationIcons[s.icon],
                  size: 18,
                  color: situationColor(s),
                ),
                label: Text(s.title),
                labelStyle: theme.textTheme.labelLarge,
                backgroundColor: palette.card,
                side: BorderSide(color: palette.cardBorder),
                onPressed: () => openSituation(context, s),
              );
            },
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
    final books = ref.watch(booksProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(S.recentlyRead),
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
