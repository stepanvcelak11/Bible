import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/entities/content_entities.dart';
import '../../content/application/content_providers.dart';
import '../../content/presentation/passage_card.dart';
import '../../content/presentation/quiz_screen.dart';
import '../../memory/application/memory_controller.dart';
import '../../memory/presentation/memory_screen.dart';
import '../../prayer/application/prayer_controller.dart';
import '../../prayer/presentation/prayers_view.dart';

const _green = Color(0xFF3E8E5E);
const _red = Color(0xFFC0503A);

String _dayKey(DateTime d) =>
    '${d.year}${d.month.toString().padLeft(2, '0')}'
    '${d.day.toString().padLeft(2, '0')}';

/// Otázka dne (každý den jiná) a pořadí jejích odpovědí.
(QuizQuestion, List<String>) quizOfDay(List<QuizQuestion> all, DateTime day) {
  final n = DateTime(
    day.year,
    day.month,
    day.day,
  ).difference(DateTime(2024)).inDays;
  // Krok nesoudělný s počtem otázek projde všechny, než se zopakují.
  var step = 7;
  while (all.length % step == 0) {
    step++;
  }
  final q = all[(n * step) % all.length];
  return (q, [...q.answers]..shuffle(Random(n)));
}

/// „Na dnešek“: otázka dne a – pokud je co dělat – verše k opakování
/// a modlitby.
class ForTodaySection extends ConsumerWidget {
  const ForTodaySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quiz = ref.watch(quizProvider).value;
    final memoryDue = ref.watch(memoryProvider).where((m) => !m.learned).length;
    final prayers = [
      for (final p in ref.watch(prayerProvider))
        if (!p.isAnswered) p,
    ];
    if (quiz == null || quiz.$2.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionLabel(S.forToday),
        _QuizOfDayCard(questions: quiz.$2),
        if (memoryDue > 0 || prayers.isNotEmpty) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              if (memoryDue > 0)
                Expanded(
                  child: _MiniTile(
                    icon: Icons.psychology_outlined,
                    color: const Color(0xFF8C6BA8),
                    title: S.memory,
                    subtitle: S.memoryDue(memoryDue),
                    onTap: () => openMemory(context),
                  ),
                ),
              if (memoryDue > 0 && prayers.isNotEmpty)
                const SizedBox(width: 10),
              if (prayers.isNotEmpty)
                Expanded(
                  child: _MiniTile(
                    icon: Icons.volunteer_activism_outlined,
                    color: _green,
                    title: S.prayerTime,
                    subtitle: S.prayersDue(prayers.length),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        fullscreenDialog: true,
                        builder: (_) => PrayerTimeScreen(
                          ids: [for (final p in prayers) p.id],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _QuizOfDayCard extends ConsumerStatefulWidget {
  const _QuizOfDayCard({required this.questions});

  final List<QuizQuestion> questions;

  @override
  ConsumerState<_QuizOfDayCard> createState() => _QuizOfDayCardState();
}

class _QuizOfDayCardState extends ConsumerState<_QuizOfDayCard> {
  String? _chosen;

  @override
  void initState() {
    super.initState();
    // Dnešní odpověď zůstane zobrazená i po návratu na stránku.
    final saved = ref.read(appPreferencesProvider).quizOfDay;
    final today = _dayKey(DateTime.now());
    if (saved != null && saved.startsWith('$today|')) {
      _chosen = saved.substring(today.length + 1);
    }
  }

  void _answer(String a, QuizQuestion q) {
    if (_chosen != null) return;
    a == q.correct
        ? HapticFeedback.lightImpact()
        : HapticFeedback.heavyImpact();
    setState(() => _chosen = a);
    ref
        .read(appPreferencesProvider)
        .setQuizOfDay('${_dayKey(DateTime.now())}|$a');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final (q, answers) = quizOfDay(widget.questions, DateTime.now());
    final answered = _chosen != null;
    final ok = _chosen == q.correct;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.emoji_events_outlined,
                  size: 18,
                  color: Color(0xFFC08A2E),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    S.quizOfDay.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: const Color(0xFFC08A2E),
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(q.question, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final a in answers)
                  _AnswerChip(
                    text: a,
                    color: !answered
                        ? null
                        : a == q.correct
                        ? _green
                        : a == _chosen
                        ? _red
                        : palette.muted.withValues(alpha: 0.5),
                    selected: answered && (a == q.correct || a == _chosen),
                    onTap: answered ? null : () => _answer(a, q),
                  ),
              ],
            ),
            if (answered) ...[
              const SizedBox(height: 12),
              Text(
                ok ? S.quizCorrect : S.quizWrong(q.correct),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: ok ? _green : _red,
                ),
              ),
              const SizedBox(height: 8),
              PassageCard(passage: q.passage, accent: palette.gold),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => openQuiz(context),
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text(S.quizMore),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerChip extends StatelessWidget {
  const _AnswerChip({
    required this.text,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final Color? color;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final c = color;
    return Material(
      color: c == null
          ? palette.gold.withValues(alpha: 0.10)
          : c.withValues(alpha: selected ? 0.16 : 0.06),
      shape: StadiumBorder(
        side: BorderSide(
          color: c ?? palette.cardBorder,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              color: c,
              fontWeight: selected ? FontWeight.w700 : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniTile extends StatelessWidget {
  const _MiniTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge,
                    ),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: palette.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
