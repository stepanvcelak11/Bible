import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/services/church_year.dart';
import '../../today/application/today_providers.dart';
import '../application/content_providers.dart';
import 'passage_card.dart';

void openChurchYear(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const ChurchYearScreen()));

/// Liturgické barvy (bílá se kreslí jako teplé zlato, aby byla vidět).
Color liturgicalColor(String key) => switch (key) {
  'violet' => const Color(0xFF7A55A8),
  'green' => const Color(0xFF3E8E5E),
  'red' => const Color(0xFFC0503A),
  _ => const Color(0xFFD1A23A),
};

const seasonColorKeys = {
  ChurchSeason.advent: 'violet',
  ChurchSeason.christmas: 'white',
  ChurchSeason.ordinary: 'green',
  ChurchSeason.lent: 'violet',
  ChurchSeason.holyweek: 'red',
  ChurchSeason.easter: 'white',
};

const _monthsShort = [
  'led', 'úno', 'bře', 'dub', 'kvě', 'čvn', //
  'čvc', 'srp', 'zář', 'říj', 'lis', 'pro',
];

String _date(DateTime d) => '${d.day}. ${d.month}.';

DateTime _today() {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

/// „Dnes“, „Zítra“ nebo „za N dní“ (jen pro budoucí dny).
String relativeDay(DateTime day, DateTime today) {
  final diff = day.difference(today).inDays;
  return switch (diff) {
    0 => S.churchToday,
    1 => S.churchTomorrow,
    _ => S.churchInDays(diff),
  };
}

/// Církevní rok: kruh s dobami a dnešním dnem, čtení pro aktuální dobu
/// a seznam svátků.
class ChurchYearScreen extends ConsumerWidget {
  const ChurchYearScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final data = ref.watch(churchYearProvider).value;
    final today = _today();
    final year = ChurchYear.of(today);
    final season = year.seasonOf(today);
    final seasonItem = data?.$1[season.name];
    final color = liturgicalColor(seasonColorKeys[season]!);
    final upcoming = upcomingFeasts(today);
    final next = upcoming.first;
    final dayOfYear = today.difference(year.start).inDays + 1;

    return Scaffold(
      appBar: AppBar(title: const Text(S.churchYear)),
      body: ReadableWidth(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            4,
            16,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(palette.heroStart, color, 0.35)!,
                    palette.heroEnd,
                  ],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: CustomPaint(
                      painter: _YearWheelPainter(
                        year: year,
                        today: today,
                        track: palette.onHero.withValues(alpha: 0.12),
                        marker: palette.onHero,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 150,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                S.churchYearSpan(year.startYear),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: palette.onHero.withValues(alpha: 0.7),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                seasonItem?.name ?? '',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: palette.onHero,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                S.churchDayOf(dayOfYear, year.lengthInDays),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: palette.onHero.withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 14,
                    runSpacing: 6,
                    children: [
                      for (final (s, key) in [
                        ('Advent, půst', 'violet'),
                        ('Vánoce, Velikonoce', 'white'),
                        ('Mezidobí', 'green'),
                        ('Svatý týden, Letnice', 'red'),
                      ])
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: liturgicalColor(key),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              s,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: palette.onHero.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (data != null) ...[
              if (data.$2[next.$1] case final f?) ...[
                const SizedBox(height: 12),
                _FeastTile(
                  item: f,
                  date: next.$2,
                  today: today,
                  highlighted: true,
                ),
              ],
              if (seasonItem != null) ...[
                SectionLabel(seasonItem.name),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
                  child: Text(
                    seasonItem.text,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                  child: Text(
                    S.churchSeasonReadings.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                for (final p in seasonItem.passages)
                  PassageCard(passage: p, accent: color),
              ],
              _SeasonPlans(year: year, today: today),
              const SectionLabel(S.churchUpcoming),
              for (final (id, date) in upcoming.skip(1))
                if (data.$2[id] case final f?)
                  _FeastTile(item: f, date: date, today: today),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                child: Text(
                  S.churchYearAbout,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.muted,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Sezónní plán čtení pro aktuální dobu nebo dobu, která brzy začne.
class _SeasonPlans extends ConsumerWidget {
  const _SeasonPlans({required this.year, required this.today});

  final ChurchYear year;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final soon = DateTime(today.year, today.month, today.day + 40);
    final ids = <String>{
      for (final d in [today, soon])
        ?seasonalPlanIds[ChurchYear.of(d).seasonOf(d).name],
    };
    final active = ref.watch(planProvider).value?.plan.id;
    final plans = [for (final id in ids) ?planById(id)];
    if (plans.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionLabel(S.churchSeasonPlan),
        for (final plan in plans)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.name, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    plan.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: active == plan.id
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.check_circle,
                              color: palette.gold,
                            ),
                          )
                        : FilledButton.tonal(
                            onPressed: () async {
                              await ref
                                  .read(planProvider.notifier)
                                  .start(plan.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(S.planStarted(plan.name)),
                                  ),
                                );
                              }
                            },
                            child: const Text(S.startPlan),
                          ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _FeastTile extends StatelessWidget {
  const _FeastTile({
    required this.item,
    required this.date,
    required this.today,
    this.highlighted = false,
  });

  final ChurchYearItem item;
  final DateTime date;
  final DateTime today;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final color = liturgicalColor(item.color);
    final past = date.isBefore(today);
    final isToday = date == today;
    return Opacity(
      opacity: past ? 0.55 : 1,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        shape: highlighted || isToday
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: color, width: 1.5),
              )
            : null,
        child: InkWell(
          onTap: () => showFeast(context, item, date),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              children: [
                Container(
                  width: 48,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${date.day}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        _monthsShort[date.month - 1],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: theme.textTheme.titleSmall),
                      if (!past)
                        Text(
                          relativeDay(date, today),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isToday ? color : palette.muted,
                            fontWeight: isToday ? FontWeight.w700 : null,
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
      ),
    );
  }
}

/// Karta na stránce Dnes: liturgická doba a nejbližší svátek.
class ChurchYearCard extends ConsumerWidget {
  const ChurchYearCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(churchYearProvider).value;
    if (data == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final today = _today();
    final year = ChurchYear.of(today);
    final season = year.seasonOf(today);
    final seasonItem = data.$1[season.name];
    final (feastId, feastDate) = nextFeast(today);
    final feast = data.$2[feastId];
    if (seasonItem == null || feast == null) return const SizedBox.shrink();
    final color = liturgicalColor(seasonColorKeys[season]!);
    final feastColor = liturgicalColor(feast.color);
    return Card(
      margin: const EdgeInsets.only(top: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openChurchYear(context),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color, feastColor],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.churchYear.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: color,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(seasonItem.name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: relativeDay(feastDate, today),
                              style: TextStyle(
                                color: feastColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: ' · ${feast.name}'),
                          ],
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 56,
                child: Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CustomPaint(
                      painter: _YearWheelPainter(
                        year: year,
                        today: today,
                        track: palette.muted.withValues(alpha: 0.15),
                        marker: theme.colorScheme.onSurface,
                        mini: true,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Detail svátku: text a čtení.
Future<void> showFeast(
  BuildContext context,
  ChurchYearItem item,
  DateTime date,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      final theme = Theme.of(context);
      final color = liturgicalColor(item.color);
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            MediaQuery.paddingOf(context).bottom + 24,
          ),
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_date(date)} ${date.year}',
                  style: theme.textTheme.labelLarge?.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.name, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text(
              item.text,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 16),
            for (final p in item.passages)
              PassageCard(passage: p, accent: color),
          ],
        ),
      );
    },
  );
}

/// Kruh církevního roku: barevné oblouky dob, tečky svátků a značka dneška.
class _YearWheelPainter extends CustomPainter {
  _YearWheelPainter({
    required this.year,
    required this.today,
    required this.track,
    required this.marker,
    this.mini = false,
  });

  final bool mini;
  final ChurchYear year;
  final DateTime today;
  final Color track;
  final Color marker;

  double _angle(DateTime d) => -math.pi / 2 + 2 * math.pi * year.fractionOf(d);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - (mini ? 4 : 14);
    final stroke = mini ? 6.0 : 16.0;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    final total = year.lengthInDays;
    for (final (season, from, to) in year.periods) {
      final days = to.difference(from).inDays + 1;
      final start =
          -math.pi / 2 +
          2 * math.pi * from.difference(year.start).inDays / total;
      final sweep = 2 * math.pi * days / total;
      final past = !to.isBefore(today) ? 1.0 : 0.45;
      canvas.drawArc(
        rect,
        start + 0.012,
        math.max(sweep - 0.024, 0.01),
        false,
        Paint()
          ..color = liturgicalColor(seasonColorKeys[season]!)
              .withValues(alpha: past)
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.butt,
      );
    }
    // Letnice – červený den uprostřed bílé doby.
    final pentecost = _angle(year.pentecost);
    canvas.drawArc(
      rect,
      pentecost - 0.03,
      0.06,
      false,
      Paint()
        ..color = liturgicalColor('red')
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    // Svátky jako tečky na vnitřním okraji.
    if (!mini) _feastDots(canvas, center, radius, stroke);
    _todayMarker(canvas, center, radius, stroke);
  }

  void _feastDots(Canvas canvas, Offset center, double radius, double stroke) {
    final dot = Paint()..color = marker.withValues(alpha: 0.55);
    for (final d in year.feasts.values) {
      final a = _angle(d);
      canvas.drawCircle(
        center + Offset(math.cos(a), math.sin(a)) * (radius - stroke / 2 - 7),
        2,
        dot,
      );
    }
  }

  void _todayMarker(
    Canvas canvas,
    Offset center,
    double radius,
    double stroke,
  ) {
    // Dnešek: ručička a výrazný bod na oblouku.
    final a = _angle(today);
    if (mini) {
      canvas.drawLine(
        center,
        center + Offset(math.cos(a), math.sin(a)) * radius,
        Paint()
          ..color = marker
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(center, 2.5, Paint()..color = marker);
      return;
    }
    final dir = Offset(math.cos(a), math.sin(a));
    canvas.drawLine(
      center + dir * (radius - stroke / 2 - 14),
      center + dir * (radius + stroke / 2 + 6),
      Paint()
        ..color = marker
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center + dir * radius, 9, Paint()..color = marker);
    canvas.drawCircle(
      center + dir * radius,
      5.5,
      Paint()..color = liturgicalColor(seasonColorKeys[year.seasonOf(today)]!),
    );
  }

  @override
  bool shouldRepaint(_YearWheelPainter old) =>
      old.today != today || old.track != track || old.marker != marker;
}
