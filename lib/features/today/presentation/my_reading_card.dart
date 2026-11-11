import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/services/progress.dart';
import '../../../domain/services/versification.dart';
import '../../progress/presentation/progress_screen.dart';
import '../../reader/application/reading_position_controller.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../application/today_providers.dart';

/// „Moje čtení“ v jedné kartě: kde pokračovat, rytmus týdne a plamínek
/// se sérií dní v řadě. Podrobné statistiky jsou v Mém pokroku.
class MyReadingCard extends ConsumerWidget {
  const MyReadingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final position = ref.watch(readingPositionProvider);
    final book = ref.watch(bookByIdProvider(position.bookId));
    final translation = ref.watch(primaryTranslationProvider);
    final counts =
        ref.watch(chapterCountsProvider(translation.id)).value ?? const {};
    final total = counts[position.bookId] ?? 0;
    final read =
        ref.watch(readChaptersProvider).value?[position.bookId]?.length ?? 0;
    final color = Color(categoryOf(position.bookId).color);
    final daily = ref.watch(dailyReadingProvider).value ?? const {};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last = daily.keys.isEmpty
        ? null
        : daily.keys.reduce((a, b) => a.isAfter(b) ? a : b);
    final readDays = [
      for (final e in daily.entries)
        if (e.value > 0) e.key,
    ];
    final streak = currentStreak(readDays, today);
    final readToday = readDays.any(
      (d) =>
          d.year == today.year && d.month == today.month && d.day == today.day,
    );

    // Úplně nový čtenář: místo „Pokračovat v Genesis 1“ rovnou nabídnout
    // dobrý začátek (Marek 1) – jedna jasná volba.
    final firstTime =
        last == null && position.bookId == 1 && position.chapter == 1;
    const start = VerseRef(41, 1, 1);
    final mainRef = firstTime ? start : position;
    final mainBook = firstTime ? ref.watch(bookByIdProvider(41)) : book;
    final mainColor = firstTime ? Color(categoryOf(41).color) : color;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => openReaderAt(
              context,
              ref,
              mainRef,
              from: firstTime
                  ? VerseScheme.hebrew
                  : schemeOf(ref.read(translationControllerProvider).primaryId),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 12, 12),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [mainColor, mainColor.withValues(alpha: 0.7)],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      mainBook.abbreviation,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstTime ? S.whereToStart : S.continueReading,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: palette.muted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${mainBook.name} ${mainRef.chapter}'
                          '${mainRef.verse > 1 ? ',${mainRef.verse}' : ''}',
                          style: theme.textTheme.titleLarge,
                        ),
                        if (!firstTime) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: total == 0 ? 0 : read / total,
                              minHeight: 4,
                              color: color,
                              backgroundColor: color.withValues(alpha: 0.14),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: palette.muted),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => openProgress(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 10, 12),
              child: Row(
                children: [
                  _Flame(streak: streak, lit: readToday),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _WeekRhythm(daily: daily, today: today),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sedm dní týdne: kdy jsem četl(a). Bez počítání a bez výčitek;
/// klepnutím Můj pokrok.
class _WeekRhythm extends StatelessWidget {
  const _WeekRhythm({required this.daily, required this.today});

  final Map<DateTime, int> daily;
  final DateTime today;

  static const _days = ['Po', 'Út', 'St', 'Čt', 'Pá', 'So', 'Ne'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    return Row(
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: Builder(
              builder: (context) {
                final d = DateTime(monday.year, monday.month, monday.day + i);
                final read = (daily[d] ?? 0) > 0;
                final isToday = d == today;
                return Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: read ? palette.gold : null,
                        border: Border.all(
                          color: read || isToday
                              ? palette.gold
                              : palette.cardBorder,
                          width: isToday ? 2 : 1.2,
                        ),
                      ),
                      child: read
                          ? const Icon(
                              Icons.check,
                              size: 13,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _days[i],
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isToday ? palette.gold : palette.muted,
                        fontWeight: isToday ? FontWeight.w700 : null,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        Icon(Icons.chevron_right, size: 18, color: palette.muted),
      ],
    );
  }
}

/// Plamínek se sérií dní v řadě. Dnes přečteno = plně hoří; série ze
/// včerejška ještě platí = bledší; žádná série = šedý.
class _Flame extends StatelessWidget {
  const _Flame({required this.streak, required this.lit});

  final int streak;
  final bool lit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    const orange = Color(0xFFE8792B);
    final color = streak == 0
        ? palette.muted.withValues(alpha: 0.5)
        : lit
        ? orange
        : orange.withValues(alpha: 0.55);
    return Semantics(
      label: S.streakDays(streak),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
        decoration: BoxDecoration(
          color: streak == 0 ? null : orange.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: streak == 0 ? Border.all(color: palette.cardBorder) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_fire_department_rounded, color: color, size: 26),
            const SizedBox(width: 2),
            Text(
              '$streak',
              style: theme.textTheme.titleLarge?.copyWith(
                color: streak == 0 ? palette.muted : color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
