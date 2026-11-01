import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/services/versification.dart';
import '../../progress/presentation/progress_screen.dart';
import '../../reader/application/reading_position_controller.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../application/today_providers.dart';

/// Krátké myšlenky o čtení jako setkání s Bohem (vlastní texty aplikace).
const _thoughts = [
  'Čtení Bible není výkon. Je to čas, kdy Bůh mluví a vy nasloucháte.',
  'Nemusíte rozumět všemu. Stačí si odnést do dne jednu větu.',
  'Než začnete, řekněte jednoduše: „Mluv, Pane, tvůj služebník slyší.“',
  'Bůh vás hledá dřív, než vy hledáte jeho.',
  'Raději deset minut každý den než hodinu jednou za měsíc.',
  'Co vás v textu zastaví, o tom si s Bohem promluvte.',
  'Vztah roste rozhovorem: čtěte, ptejte se a odpovídejte modlitbou.',
  'Když nevíte, jak se modlit, přečtěte žalm a modlete se jeho slovy.',
  'Čtěte pomalu. Jedna kapitola přečtená se srdcem je víc než pět '
      'přelétnutých.',
];

/// Krátké žalmy na nový začátek.
const _shortPsalms = [23, 27, 34, 46, 62, 91, 103, 121, 130, 139];

/// „Moje čtení“ v jedné kartě: kde pokračovat, jedna věta pozvání (začátek,
/// návrat po pauze bez výčitek, nebo myšlenka na den) a rytmus týdne.
/// Podrobné statistiky jsou v Mém pokroku.
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
    final day = today.difference(DateTime(2024)).inDays;
    final last = daily.keys.isEmpty
        ? null
        : daily.keys.reduce((a, b) => a.isAfter(b) ? a : b);
    final gap = last == null ? null : today.difference(last).inDays;

    // Jedna věta pozvání a případně krátký začátek.
    final (String text, String? button, VerseRef? target) = switch (gap) {
      null => (
        S.inviteStartText,
        S.inviteStartButton,
        const VerseRef(41, 1, 1),
      ),
      >= 2 => (
        S.inviteBackText,
        S.inviteBackButton(_shortPsalms[day % _shortPsalms.length]),
        VerseRef(19, _shortPsalms[day % _shortPsalms.length], 1),
      ),
      _ => (_thoughts[day % _thoughts.length], null, null),
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => openReaderAt(
              context,
              ref,
              position,
              from: schemeOf(ref.read(translationControllerProvider).primaryId),
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
                        colors: [color, color.withValues(alpha: 0.7)],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      book.abbreviation,
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
                            minHeight: 4,
                            color: color,
                            backgroundColor: color.withValues(alpha: 0.14),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: palette.muted,
                height: 1.4,
              ),
            ),
          ),
          if (button != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => openReaderAt(context, ref, target!),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(button),
                ),
              ),
            ),
          InkWell(
            onTap: () => openProgress(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
              child: _WeekRhythm(daily: daily, today: today),
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
