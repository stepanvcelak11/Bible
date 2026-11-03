import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/entities/content_entities.dart';
import '../../shell/home_shell.dart';
import '../application/plans.dart';

/// Seznam plánů měst a staveb.
Future<void> openPlans(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const PlansScreen()));

/// Jeden plán.
Future<void> openPlan(BuildContext context, BiblePlan plan) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => PlanScreen(plan: plan)));

class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(plansProvider).value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final groups = <String, List<BiblePlan>>{};
    for (final p in plans ?? const <BiblePlan>[]) {
      (groups[p.group] ??= []).add(p);
    }
    return Scaffold(
      appBar: AppBar(title: const Text(S.plans)),
      body: plans == null
          ? const Center(child: CircularProgressIndicator())
          : ReadableWidth(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  MediaQuery.paddingOf(context).bottom + 24,
                ),
                children: [
                  Text(
                    S.plansIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  for (final e in groups.entries) ...[
                    SectionLabel(e.key),
                    for (final p in e.value)
                      Card(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () => openPlan(context, p),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 96,
                                  height: 72,
                                  child: CustomPaint(
                                    painter: PlanPainter(
                                      p,
                                      PlanColors.of(context),
                                      markers: false,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.title,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        p.subtitle,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: palette.muted),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
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

class PlanScreen extends ConsumerStatefulWidget {
  const PlanScreen({super.key, required this.plan});

  final BiblePlan plan;

  @override
  ConsumerState<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends ConsumerState<PlanScreen> {
  int? _selected;
  final _keys = <int, GlobalKey>{};

  void _select(int n) {
    setState(() => _selected = n);
    final c = _keys[n]?.currentContext;
    if (c != null) {
      Scrollable.ensureVisible(
        c,
        alignment: 0.1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  /// Klepnutí do plánu → nejbližší číslo.
  void _tap(Offset local, Size box) {
    final plan = widget.plan;
    final k = box.width / plan.size.width;
    PlanPart? best;
    var bestDist = 22.0;
    for (final p in plan.parts) {
      final d = (p.at * k - local).distance;
      if (d < bestDist) {
        bestDist = d;
        best = p;
      }
    }
    if (best != null) _select(best.number);
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final books = ref.watch(booksProvider);
    Widget refChips(List<Passage> refs) => Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final r in refs)
          ActionChip(
            visualDensity: VisualDensity.compact,
            label: Text(r.label(books[r.bookId - 1].abbreviation)),
            onPressed: () => openReaderAt(context, ref, r.start),
          ),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: Text(plan.title)),
      body: ReadableWidth(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            MediaQuery.paddingOf(context).bottom + 24,
          ),
          children: [
            Text(plan.subtitle, style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(plan.intro, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            refChips(plan.refs),
            const SizedBox(height: 12),
            Card(
              clipBehavior: Clip.antiAlias,
              child: AspectRatio(
                aspectRatio: plan.size.width / plan.size.height,
                child: LayoutBuilder(
                  builder: (context, c) => InteractiveViewer(
                    maxScale: 5,
                    child: GestureDetector(
                      onTapUp: (d) => _tap(d.localPosition, c.biggest),
                      child: CustomPaint(
                        size: c.biggest,
                        painter: PlanPainter(
                          plan,
                          PlanColors.of(context),
                          selected: _selected,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 6, 4, 4),
              child: Text(
                S.planHint,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: palette.muted,
                ),
              ),
            ),
            for (final p in plan.parts)
              Container(
                key: _keys.putIfAbsent(p.number, GlobalKey.new),
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                decoration: BoxDecoration(
                  color: p.number == _selected
                      ? palette.gold.withValues(alpha: 0.12)
                      : palette.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: p.number == _selected
                        ? palette.gold
                        : palette.cardBorder,
                  ),
                ),
                child: InkWell(
                  onTap: () => setState(() => _selected = p.number),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: palette.gold,
                        child: Text(
                          '${p.number}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: theme.textTheme.titleSmall),
                            const SizedBox(height: 2),
                            Text(p.text, style: theme.textTheme.bodyMedium),
                            const SizedBox(height: 6),
                            refChips(p.refs),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Barvy plánu podle motivu aplikace.
class PlanColors {
  const PlanColors({
    required this.ink,
    required this.muted,
    required this.gold,
    required this.land,
    required this.water,
    required this.card,
    required this.border,
  });

  factory PlanColors.of(BuildContext context) {
    final palette = AppPalette.of(context);
    return PlanColors(
      ink: Theme.of(context).colorScheme.onSurface,
      muted: palette.muted,
      gold: palette.gold,
      land: palette.land,
      water: palette.water,
      card: palette.card,
      border: palette.cardBorder,
    );
  }

  final Color ink;
  final Color muted;
  final Color gold;
  final Color land;
  final Color water;
  final Color card;
  final Color border;
}

/// Kreslí plán z tvarů; čísla míst jako zlaté kroužky.
class PlanPainter extends CustomPainter {
  PlanPainter(this.plan, this.c, {this.selected, this.markers = true});

  final BiblePlan plan;
  final PlanColors c;
  final int? selected;
  final bool markers;

  @override
  void paint(Canvas canvas, Size size) {
    final k = math.min(
      size.width / plan.size.width,
      size.height / plan.size.height,
    );
    canvas.save();
    canvas.translate(
      (size.width - plan.size.width * k) / 2,
      (size.height - plan.size.height * k) / 2,
    );
    canvas.scale(k);
    canvas.drawRect(
      Offset.zero & plan.size,
      Paint()..color = c.land.withValues(alpha: 0.35),
    );
    for (final s in plan.shapes) {
      _shape(canvas, s, k);
    }
    if (markers) {
      for (final p in plan.parts) {
        final on = p.number == selected;
        final r = (on ? 10.0 : 8.0) / math.max(k, 0.6);
        if (on) {
          canvas.drawCircle(
            p.at,
            r + 5 / k,
            Paint()..color = c.gold.withValues(alpha: 0.3),
          );
        }
        canvas.drawCircle(p.at, r, Paint()..color = c.gold);
        canvas.drawCircle(
          p.at,
          r,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4 / k
            ..color = Colors.white,
        );
        _text(
          canvas,
          '${p.number}',
          p.at,
          TextStyle(
            color: Colors.white,
            fontSize: r * 1.15,
            fontWeight: FontWeight.w800,
          ),
        );
      }
    }
    canvas.restore();
  }

  (Paint?, Paint?) _style(String s, double k) {
    Paint fill(Color color) => Paint()..color = color;
    Paint stroke(Color color, double w) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w / k
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = color;
    return switch (s) {
      'ground' => (fill(c.land), null),
      'court' => (fill(c.card), stroke(c.border, 1)),
      'wall' => (null, stroke(c.ink.withValues(alpha: 0.75), 2.2)),
      'building' => (fill(c.muted.withValues(alpha: 0.18)), stroke(c.muted, 1)),
      'holy' => (fill(c.gold.withValues(alpha: 0.18)), stroke(c.gold, 1.2)),
      'most' => (fill(c.gold.withValues(alpha: 0.4)), stroke(c.gold, 1.4)),
      'water' => (
        fill(c.water),
        stroke(Color.lerp(c.water, Colors.blueGrey, 0.5)!, 1),
      ),
      'valley' => (null, stroke(const Color(0xFF7C8B5A), 1.6)),
      'screen' => (null, stroke(c.gold, 2.2)),
      'furniture' => (null, stroke(c.ink.withValues(alpha: 0.7), 1.2)),
      'camp' => (fill(c.card), stroke(c.border, 1)),
      'camp2' => (fill(c.gold.withValues(alpha: 0.16)), stroke(c.gold, 1.2)),
      'hill' => (
        fill(const Color(0xFFB0813B).withValues(alpha: 0.14)),
        stroke(const Color(0xFFB0813B).withValues(alpha: 0.4), 1),
      ),
      _ => (null, stroke(c.muted, 1)),
    };
  }

  void _shape(Canvas canvas, PlanShape s, double k) {
    final p = s.points;
    final (fill, stroke) = _style(s.style, k);
    final dashed = s.style == 'valley' || s.style == 'screen';
    void draw(Path path) {
      if (fill != null) canvas.drawPath(path, fill);
      if (stroke != null) {
        canvas.drawPath(dashed ? _dash(path, 5 / k, 4 / k) : path, stroke);
      }
    }

    switch (s.kind) {
      case 'rect':
        draw(Path()..addRect(Rect.fromLTWH(p[0], p[1], p[2], p[3])));
      case 'circle':
        draw(
          Path()..addOval(
            Rect.fromCircle(center: Offset(p[0], p[1]), radius: p[2]),
          ),
        );
      case 'poly' || 'line':
        final path = Path()..moveTo(p[0], p[1]);
        for (var i = 2; i + 1 < p.length; i += 2) {
          path.lineTo(p[i], p[i + 1]);
        }
        if (s.kind == 'poly') {
          path.close();
          draw(path);
        } else {
          if (stroke != null) {
            canvas.drawPath(dashed ? _dash(path, 5 / k, 4 / k) : path, stroke);
          }
        }
      case 'text':
        _text(
          canvas,
          s.text ?? '',
          Offset(p[0], p[1]),
          TextStyle(
            color: c.muted,
            fontSize: 10.5 * p[2],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        );
      case 'scale':
        final line = Paint()
          ..strokeWidth = 1.4 / k
          ..color = c.ink.withValues(alpha: 0.7);
        canvas.drawLine(Offset(p[0], p[1]), Offset(p[0] + p[2], p[1]), line);
        for (final x in [p[0], p[0] + p[2]]) {
          canvas.drawLine(Offset(x, p[1] - 3), Offset(x, p[1] + 3), line);
        }
        _text(
          canvas,
          s.text ?? '',
          Offset(p[0] + p[2] + 6, p[1]),
          TextStyle(color: c.muted, fontSize: 9),
          left: true,
        );
      case 'north':
        final at = Offset(p[0], p[1]);
        canvas.drawPath(
          Path()
            ..moveTo(at.dx, at.dy - 12)
            ..lineTo(at.dx - 4, at.dy - 2)
            ..lineTo(at.dx + 4, at.dy - 2)
            ..close(),
          Paint()..color = c.ink.withValues(alpha: 0.7),
        );
        _text(
          canvas,
          'S',
          at + const Offset(0, 5),
          TextStyle(
            color: c.ink.withValues(alpha: 0.7),
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        );
    }
  }

  /// Přerušovaná čára.
  Path _dash(Path source, double on, double off) {
    final out = Path();
    for (final m in source.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        out.addPath(m.extractPath(d, math.min(d + on, m.length)), Offset.zero);
        d += on + off;
      }
    }
    return out;
  }

  void _text(
    Canvas canvas,
    String text,
    Offset at,
    TextStyle style, {
    bool left = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    tp.paint(
      canvas,
      left
          ? at - Offset(0, tp.height / 2)
          : at - Offset(tp.width / 2, tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(PlanPainter old) =>
      old.plan != plan || old.selected != selected || old.c.ink != c.ink;
}
