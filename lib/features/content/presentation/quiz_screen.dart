import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/entities/content_entities.dart';
import '../application/content_providers.dart';
import 'passage_card.dart';

/// Kolik otázek má jedno kolo.
const quizRoundLength = 10;

const _all = 'all';
const _green = Color(0xFF3E8E5E);
const _red = Color(0xFFC0503A);

const _categoryStyle = <String, (IconData, Color)>{
  _all: (Icons.auto_awesome, Color(0xFFB0813B)),
  'ot': (Icons.landscape_outlined, Color(0xFF8C6BA8)),
  'gospels': (Icons.wb_sunny_outlined, Color(0xFFB0603A)),
  'church': (Icons.groups_outlined, Color(0xFF3F7CAC)),
  'people': (Icons.diversity_3_outlined, Color(0xFF2E8B57)),
};

void openQuiz(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const QuizScreen()));

/// Úvod kvízu: výběr oblasti a nejlepší výsledky.
class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  Future<void> _start(String category, List<QuizQuestion> pool) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuizRoundScreen(category: category, pool: pool),
      ),
    );
    // Po kole obnovit nejlepší výsledky.
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(quizProvider).value;
    final best = ref.read(appPreferencesProvider).quizBest;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.quiz)),
        body: data == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  MediaQuery.paddingOf(context).bottom + 24,
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [palette.heroEnd, palette.heroStart],
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.quiz,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: palette.onHero,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                S.quizIntro,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: palette.onHero.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 48,
                          color: palette.onHero.withValues(alpha: 0.9),
                        ),
                      ],
                    ),
                  ),
                  const SectionLabel(S.quizChoose),
                  for (final (id, name) in [(_all, S.quizAll), ...data.$1])
                    _CategoryCard(
                      id: id,
                      name: name,
                      count: id == _all
                          ? data.$2.length
                          : data.$2.where((q) => q.category == id).length,
                      best: best[id],
                      onTap: () => _start(id, [
                        for (final q in data.$2)
                          if (id == _all || q.category == id) q,
                      ]),
                    ),
                ],
              ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.id,
    required this.name,
    required this.count,
    required this.best,
    required this.onTap,
  });

  final String id;
  final String name;
  final int count;
  final int? best;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final (icon, color) =
        _categoryStyle[id] ?? (Icons.quiz_outlined, palette.gold);
    final total = min(quizRoundLength, count);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color, Color.lerp(color, Colors.black, 0.25)!],
                    ),
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        [
                          S.quizQuestions(count),
                          if (best != null) S.quizBest(best!, total),
                        ].join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (best != null && best == total)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(Icons.emoji_events, color: Color(0xFFD9A93B)),
                  ),
                Icon(Icons.play_circle_fill, color: color, size: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Jedno kolo kvízu: [quizRoundLength] náhodných otázek s promíchanými
/// odpověďmi; po odpovědi se ukáže biblické místo.
class QuizRoundScreen extends ConsumerStatefulWidget {
  const QuizRoundScreen({
    super.key,
    required this.category,
    required this.pool,
    this.random,
  });

  final String category;
  final List<QuizQuestion> pool;

  /// Pro testy (deterministické pořadí).
  final Random? random;

  @override
  ConsumerState<QuizRoundScreen> createState() => _QuizRoundScreenState();
}

class _QuizRoundScreenState extends ConsumerState<QuizRoundScreen> {
  late Random _random = widget.random ?? Random();
  late List<(QuizQuestion, List<String>)> _round;
  var _index = 0;
  String? _chosen;
  final _missed = <QuizQuestion>[];
  var _score = 0;
  var _newBest = false;
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _newRound() {
    final questions = [...widget.pool]..shuffle(_random);
    _round = [
      for (final q in questions.take(quizRoundLength))
        (q, [...q.answers]..shuffle(_random)),
    ];
    _index = 0;
    _chosen = null;
    _score = 0;
    _missed.clear();
    _newBest = false;
  }

  bool get _finished => _index >= _round.length;

  void _answer(String a) {
    if (_chosen != null) return;
    final q = _round[_index].$1;
    final ok = a == q.correct;
    ok ? HapticFeedback.lightImpact() : HapticFeedback.heavyImpact();
    setState(() {
      _chosen = a;
      if (ok) {
        _score++;
      } else {
        _missed.add(q);
      }
    });
  }

  void _next() {
    setState(() {
      _index++;
      _chosen = null;
      if (_finished) _saveBest();
    });
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  void _saveBest() {
    final prefs = ref.read(appPreferencesProvider);
    final best = prefs.quizBest;
    final old = best[widget.category];
    if (old == null || _score > old) {
      _newBest = old != null && _score > old;
      prefs.setQuizBest({...best, widget.category: _score});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final n = _round.length;
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_finished ? S.quiz : S.quizProgress(_index + 1, n)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFD9A93B)),
                  const SizedBox(width: 4),
                  Text('$_score', style: theme.textTheme.titleMedium),
                ],
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                end: n == 0 ? 1 : (_index + (_chosen != null ? 1 : 0)) / n,
              ),
              duration: const Duration(milliseconds: 300),
              builder: (_, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 4,
                color: palette.gold,
                backgroundColor: palette.cardBorder,
              ),
            ),
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: _finished ? _result(context) : _question(context),
        ),
      ),
    );
  }

  Widget _question(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final (q, answers) = _round[_index];
    final answered = _chosen != null;
    final ok = _chosen == q.correct;
    return ListView(
      key: ValueKey(_index),
      controller: _scroll,
      padding: EdgeInsets.fromLTRB(
        20,
        24,
        20,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      children: [
        Text(
          q.question,
          style: theme.textTheme.headlineSmall?.copyWith(height: 1.3),
        ),
        const SizedBox(height: 22),
        for (final (i, a) in answers.indexed)
          _AnswerButton(
            letter: String.fromCharCode(65 + i),
            text: a,
            state: !answered
                ? _AnswerState.open
                : a == q.correct
                ? _AnswerState.correct
                : a == _chosen
                ? _AnswerState.wrong
                : _AnswerState.faded,
            onTap: () => _answer(a),
          ),
        if (answered) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                ok ? Icons.check_circle : Icons.info_outline,
                color: ok ? _green : _red,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ok ? S.quizCorrect : S.quizWrong(q.correct),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: ok ? _green : _red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PassageCard(passage: q.passage, accent: palette.gold),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: _next,
            icon: Icon(
              _index + 1 < _round.length ? Icons.arrow_forward : Icons.flag,
            ),
            label: Text(
              _index + 1 < _round.length ? S.quizNext : S.quizShowResult,
            ),
          ),
        ],
      ],
    );
  }

  Widget _result(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final n = _round.length;
    return ListView(
      key: const ValueKey('result'),
      padding: EdgeInsets.fromLTRB(
        20,
        28,
        20,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      children: [
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: n == 0 ? 0 : _score / n),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, v, _) => SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: v,
                    strokeWidth: 12,
                    strokeCap: StrokeCap.round,
                    color: palette.gold,
                    backgroundColor: palette.cardBorder,
                  ),
                  Center(
                    child: Text(
                      '$_score/$n',
                      style: theme.textTheme.displaySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          S.quizResultTitle(_score, n),
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 6),
        Text(
          S.quizResultBody(_score, n),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
        ),
        if (_newBest) ...[
          const SizedBox(height: 10),
          Center(
            child: Chip(
              avatar: const Icon(Icons.emoji_events, color: Color(0xFFD9A93B)),
              label: const Text(S.quizNewBest),
            ),
          ),
        ],
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(S.quizDone),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () => setState(() {
                  _random = widget.random ?? Random();
                  _newRound();
                }),
                icon: const Icon(Icons.replay),
                label: const Text(S.quizAgain),
              ),
            ),
          ],
        ),
        if (_missed.isNotEmpty) ...[
          const SectionLabel(S.quizReview),
          for (final q in _missed)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.question, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    q.correct,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PassageCard(passage: q.passage, accent: palette.gold),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

enum _AnswerState { open, correct, wrong, faded }

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.letter,
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String letter;
  final String text;
  final _AnswerState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final (bg, border, fg) = switch (state) {
      _AnswerState.open => (palette.card, palette.cardBorder, null),
      _AnswerState.correct => (_green.withValues(alpha: 0.14), _green, _green),
      _AnswerState.wrong => (_red.withValues(alpha: 0.12), _red, _red),
      _AnswerState.faded => (
        palette.card.withValues(alpha: 0.5),
        palette.cardBorder,
        palette.muted,
      ),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: border,
            width: state == _AnswerState.open ? 1 : 2,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: state == _AnswerState.open ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (fg ?? palette.gold).withValues(alpha: 0.15),
                    ),
                    child: switch (state) {
                      _AnswerState.correct => const Icon(
                        Icons.check,
                        size: 18,
                        color: _green,
                      ),
                      _AnswerState.wrong => const Icon(
                        Icons.close,
                        size: 18,
                        color: _red,
                      ),
                      _ => Text(
                        letter,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: fg ?? palette.gold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: fg,
                        fontWeight: state == _AnswerState.correct
                            ? FontWeight.w600
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
