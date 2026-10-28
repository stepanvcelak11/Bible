import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/services/progress.dart';
import '../../study/presentation/book_intro_sheet.dart';
import '../../today/application/today_providers.dart';
import '../../translations/application/translation_controller.dart';

void openProgress(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const ProgressScreen()));

const _badgeIcons = {
  'spark': Icons.auto_awesome,
  'flame': Icons.local_fire_department,
  'book': Icons.menu_book,
  'cross': Icons.auto_stories,
  'music': Icons.music_note,
  'scroll': Icons.history_edu,
  'star': Icons.star,
  'crown': Icons.workspace_premium,
};

/// Můj pokrok: série, kalendář čtení, odznaky a přečtená Bible po knihách.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final stats = ref.watch(readingStatsProvider).value;
    final daily = ref.watch(dailyReadingProvider).value ?? const {};
    final read = ref.watch(readChaptersProvider).value ?? const {};
    final translationId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final counts =
        ref.watch(chapterCountsProvider(translationId)).value ?? const {};
    final books = ref.watch(booksProvider);

    final allChapters = counts.values.fold<int>(0, (s, n) => s + n);
    final readCount = read.values.fold<int>(0, (s, c) => s + c.length);
    final fraction = allChapters == 0 ? 0.0 : readCount / allChapters;
    final longest = longestStreak(daily.keys);
    final badges = computeBadges(
      read: read,
      counts: counts,
      streak: math.max(longest, stats?.streakDays ?? 0),
    );
    final earned = badges.where((b) => b.earned).length;
    // Tempo za posledních 30 dní → odhad dočtení celé Bible.
    final now = DateTime.now();
    final monthAgo = DateTime(now.year, now.month, now.day - 30);
    final recent = daily.entries
        .where((e) => e.key.isAfter(monthAgo))
        .fold<int>(0, (s, e) => s + e.value);
    final remaining = allChapters - readCount;
    final finish = recent == 0 || remaining <= 0
        ? null
        : DateTime(
            now.year,
            now.month,
            now.day + (remaining / (recent / 30)).ceil(),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text(S.progress),
        actions: [
          IconButton(
            tooltip: S.markReadEarlier,
            icon: const Icon(Icons.playlist_add_check),
            onPressed: () => _showBulkMark(context),
          ),
        ],
      ),
      body: ReadableWidth(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            4,
            16,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          children: [
            // --- Hlavní karta ---------------------------------------------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [palette.heroStart, palette.heroEnd],
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 112,
                    height: 112,
                    child: CustomPaint(
                      painter: _RingPainter(
                        fraction,
                        palette.gold,
                        palette.onHero.withValues(alpha: 0.15),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(fraction * 100).toStringAsFixed(fraction < 0.1 ? 1 : 0).replaceAll('.', ',')} %',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: palette.onHero,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              S.ofBible,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: palette.onHero.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (icon, value, label) in [
                          (
                            Icons.local_fire_department,
                            '${stats?.streakDays ?? 0}',
                            S.streak,
                          ),
                          (Icons.emoji_events, '$longest', S.longestStreak),
                          (Icons.menu_book, '$readCount', S.chaptersReadLabel),
                          (Icons.calendar_month, '${daily.length}', S.daysRead),
                        ])
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                Icon(icon, size: 18, color: palette.gold),
                                const SizedBox(width: 8),
                                Text(
                                  value,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: palette.onHero,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    label,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: palette.onHero.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (finish != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, size: 18, color: palette.gold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        S.finishEstimate(
                          '${finish.day}. ${finish.month}. ${finish.year}',
                          (recent / 30).toStringAsFixed(1).replaceAll('.', ','),
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // --- Kalendář -------------------------------------------------
            const SectionLabel(S.readingCalendar),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                child: _Heatmap(daily: daily),
              ),
            ),
            // --- Odznaky --------------------------------------------------
            SectionLabel(S.badgesCount(earned, badges.length)),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.0,
              children: [for (final b in badges) _BadgeTile(badge: b)],
            ),
            // --- Knihy ----------------------------------------------------
            SectionLabel(
              S.bibleByBooks,
              action: S.markReadEarlierShort,
              onAction: () => _showBulkMark(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Text(
                S.markReadHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                ),
              ),
            ),
            for (final cat in bookCategories) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                child: Text(
                  cat.name,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Color(cat.color),
                  ),
                ),
              ),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (var b = cat.first; b <= cat.last; b++)
                    _BookCell(
                      label: books[b - 1].abbreviation,
                      name: books[b - 1].name,
                      color: Color(cat.color),
                      fraction: (counts[b] ?? 0) == 0
                          ? 0
                          : (read[b]?.length ?? 0) / counts[b]!,
                      onTap: () => showBookProgress(context, b),
                    ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.fraction, this.color, this.track);

  final double fraction;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final stroke = size.width * 0.09;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final r = rect.deflate(stroke / 2);
    canvas.drawArc(r, 0, math.pi * 2, false, paint..color = track);
    if (fraction > 0) {
      canvas.drawArc(
        r,
        -math.pi / 2,
        math.pi * 2 * math.max(fraction, 0.01),
        false,
        paint..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.color != color;
}

/// Kalendář posledních 18 týdnů: čím tmavší políčko, tím víc kapitol.
class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.daily});

  final Map<DateTime, int> daily;

  static const _weeks = 18;
  static const _months = [
    'led', 'úno', 'bře', 'dub', 'kvě', 'čvn', //
    'čvc', 'srp', 'zář', 'říj', 'lis', 'pro',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Začátek: pondělí před (_weeks - 1) týdny.
    final start = DateTime(
      today.year,
      today.month,
      today.day - (today.weekday - 1) - 7 * (_weeks - 1),
    );
    Color cell(int n) => switch (n) {
      0 => palette.muted.withValues(alpha: 0.12),
      1 => palette.gold.withValues(alpha: 0.35),
      2 || 3 => palette.gold.withValues(alpha: 0.65),
      _ => palette.gold,
    };
    return LayoutBuilder(
      builder: (context, c) {
        const labelW = 18.0;
        final size = math.min(18.0, (c.maxWidth - labelW) / _weeks - 3);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Měsíce nad sloupci.
            SizedBox(
              height: 16,
              child: Stack(
                children: [
                  for (var w = 0; w < _weeks; w++)
                    if (_monthStart(start, w, today) case final m?)
                      Positioned(
                        left: labelW + w * (size + 3),
                        child: Text(
                          _months[m - 1],
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: palette.muted,
                          ),
                        ),
                      ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            for (var d = 0; d < 7; d++)
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: labelW,
                      child: Text(
                        const ['Po', '', 'St', '', 'Pá', '', 'Ne'][d],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: palette.muted,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    for (var w = 0; w < _weeks; w++)
                      Builder(
                        builder: (context) {
                          final day = DateTime(
                            start.year,
                            start.month,
                            start.day + w * 7 + d,
                          );
                          final future = day.isAfter(today);
                          final n = daily[day] ?? 0;
                          return Container(
                            width: size,
                            height: size,
                            margin: const EdgeInsets.only(right: 3),
                            decoration: BoxDecoration(
                              color: future ? Colors.transparent : cell(n),
                              borderRadius: BorderRadius.circular(4),
                              border: day == today
                                  ? Border.all(color: palette.gold, width: 1.5)
                                  : null,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  S.less,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.muted,
                  ),
                ),
                for (final n in const [0, 1, 2, 4])
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: cell(n),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                const SizedBox(width: 4),
                Text(
                  S.more,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.muted,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Měsíc, který v týdnu [w] začíná (pro popisek), jinak `null`.
  static int? _monthStart(DateTime start, int w, DateTime today) {
    final monday = DateTime(start.year, start.month, start.day + w * 7);
    final sunday = DateTime(monday.year, monday.month, monday.day + 6);
    if (w == 0) return monday.month;
    if (sunday.month == monday.month && monday.day != 1) return null;
    // Měsíc, který teprve začne, ještě neoznačujeme.
    final first = DateTime(sunday.year, sunday.month);
    return first.isAfter(today) ? null : sunday.month;
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge});

  final ReadingBadge badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final on = badge.earned;
    return Tooltip(
      message: badge.description,
      triggerMode: TooltipTriggerMode.tap,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: on
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [palette.gold, palette.heroEnd],
                        )
                      : null,
                  color: on ? null : palette.muted.withValues(alpha: 0.12),
                  boxShadow: on
                      ? [
                          BoxShadow(
                            color: palette.gold.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  on ? _badgeIcons[badge.icon] : Icons.lock_outline,
                  color: on ? Colors.white : palette.muted,
                  size: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                badge.title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: on ? null : palette.muted,
                  fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookCell extends StatelessWidget {
  const _BookCell({
    required this.label,
    required this.name,
    required this.color,
    required this.fraction,
    required this.onTap,
  });

  final String label;
  final String name;
  final Color color;
  final double fraction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final done = fraction >= 1;
    return Tooltip(
      message: '$name · ${(fraction * 100).round()} %',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 46,
          height: 46,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Stack(
            children: [
              // Výplň zdola podle přečtené části knihy.
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: fraction.clamp(0, 1),
                  widthFactor: 1,
                  child: ColoredBox(color: color.withValues(alpha: 0.75)),
                ),
              ),
              Center(
                child: done
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : Text(
                        label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: fraction > 0.5 ? Colors.white : color,
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

/// Kapitoly knihy k odškrtnutí (přečteno dříve, mimo aplikaci).
Future<void> showBookProgress(BuildContext context, int bookId) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _BookProgressSheet(bookId: bookId),
    );

class _BookProgressSheet extends ConsumerWidget {
  const _BookProgressSheet({required this.bookId});

  final int bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final book = ref.watch(bookByIdProvider(bookId));
    final translationId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final total =
        ref.watch(chapterCountsProvider(translationId)).value?[bookId] ?? 0;
    final read = ref.watch(readChaptersProvider).value?[bookId] ?? const {};
    final repo = ref.read(readingProgressRepositoryProvider);
    final color = Color(categoryOf(bookId).color);
    final all = [for (var c = 1; c <= total; c++) c];
    final done = all.where(read.contains).length;

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(book.name, style: theme.textTheme.headlineSmall),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                showBookIntro(context, bookId);
              },
              icon: const Icon(Icons.auto_stories_outlined, size: 18),
              label: const Text(S.bookIntro),
            ),
          ],
        ),
        Text(
          S.chaptersDone(done, total),
          style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : done / total,
            minHeight: 6,
            color: color,
            backgroundColor: color.withValues(alpha: 0.15),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: done == total
                    ? null
                    : () => repo.markRead(bookId, all),
                icon: const Icon(Icons.done_all),
                label: const Text(S.markWholeBook),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: done == 0
                    ? null
                    : () async {
                        final ok = await _confirm(
                          context,
                          S.unmarkBookConfirm(book.name),
                        );
                        if (ok) await repo.markUnread(bookId, all);
                      },
                icon: const Icon(Icons.remove_done),
                label: const Text(S.unmarkAll),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          S.tapChapterHint,
          style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in all)
              Material(
                color: read.contains(c) ? color : color.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: color.withValues(alpha: 0.35)),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => read.contains(c)
                      ? repo.markUnread(bookId, [c])
                      : repo.markRead(bookId, [c]),
                  child: SizedBox(
                    width: 44,
                    height: 40,
                    child: Center(
                      child: Text(
                        '$c',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: read.contains(c) ? Colors.white : color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

Future<bool> _confirm(BuildContext context, String text) async =>
    await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(false),
            child: const Text(S.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialog).pop(true),
            child: const Text(S.confirm),
          ),
        ],
      ),
    ) ??
    false;

/// Hromadné označení oddílů Bible jako přečtených.
Future<void> _showBulkMark(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => const _BulkMarkSheet(),
);

class _BulkMarkSheet extends ConsumerWidget {
  const _BulkMarkSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final translationId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final counts =
        ref.watch(chapterCountsProvider(translationId)).value ?? const {};
    final read = ref.watch(readChaptersProvider).value ?? const {};
    final repo = ref.read(readingProgressRepositoryProvider);

    int done(int from, int to) {
      var n = 0;
      for (var b = from; b <= to; b++) {
        n += (read[b] ?? const {}).where((c) => c <= (counts[b] ?? 0)).length;
      }
      return n;
    }

    int size(int from, int to) {
      var n = 0;
      for (var b = from; b <= to; b++) {
        n += counts[b] ?? 0;
      }
      return n;
    }

    Future<void> mark(int from, int to) async {
      for (var b = from; b <= to; b++) {
        await repo.markRead(b, [for (var c = 1; c <= (counts[b] ?? 0); c++) c]);
      }
    }

    final groups = [
      (S.presetBible, 1, 66, palette.gold),
      (S.presetOt, 1, 39, const Color(0xFFB0813B)),
      (S.presetNt, 40, 66, const Color(0xFF3F7CAC)),
      for (final c in bookCategories) (c.name, c.first, c.last, Color(c.color)),
    ];

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        Text(S.markReadEarlier, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          S.markReadEarlierIntro,
          style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
        ),
        const SizedBox(height: 12),
        for (final (i, (name, from, to, color)) in groups.indexed) ...[
          if (i == 3) const SectionLabel(S.byParts),
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(name),
              subtitle: Text(S.chaptersOf(done(from, to), size(from, to))),
              leading: CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                foregroundColor: color,
                child: done(from, to) >= size(from, to) && size(from, to) > 0
                    ? const Icon(Icons.check)
                    : const Icon(Icons.menu_book_outlined, size: 20),
              ),
              trailing: done(from, to) >= size(from, to)
                  ? null
                  : FilledButton.tonal(
                      onPressed: () async {
                        final ok = await _confirm(
                          context,
                          S.markPartConfirm(name),
                        );
                        if (ok) await mark(from, to);
                      },
                      child: const Text(S.markPartDone),
                    ),
            ),
          ),
        ],
        const SizedBox(height: 4),
        Text(
          S.markSingleBooksHint,
          style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
        ),
      ],
    );
  }
}
