import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../content/application/content_providers.dart';
import '../../content/presentation/people_screen.dart';
import '../../shell/home_shell.dart';
import '../../study/presentation/book_intro_sheet.dart';
import 'connections_screen.dart';

/// Úroveň uzlu ve stromu.
enum TreeLevel { bible, testament, era, story, leaf }

/// Uzel myšlenkové mapy Bible.
class TreeNode {
  TreeNode({
    required this.id,
    required this.level,
    required this.title,
    required this.color,
    this.subtitle,
    this.era,
    this.story,
    this.person,
  });

  final String id;
  final TreeLevel level;
  final String title;
  final String? subtitle;
  final Color color;
  final StoryEra? era;
  final BibleStory? story;
  final BiblePerson? person;

  final children = <TreeNode>[];
  TreeNode? parent;

  /// Souvislosti s jinými příběhy (oběma směry): (uzel, proč).
  final links = <(TreeNode, String)>[];

  /// Úhel (radiány, 0 = vpravo, po směru hodinových ručiček) a poloha.
  double angle = 0;
  Offset pos = Offset.zero;
}

const treeCanvas = 3900.0;
const _radii = [0.0, 640.0, 990.0, 1250.0, 1720.0];
const _fontSizes = [200.0, 96.0, 46.0, 23.0, 15.0];

/// Nejdelší popisek příběhu (vejde se mezi příběh a postavy).
const _storyLabelWidth = 420.0;

/// Postaví strom: Bible → zákony → období → příběhy → postavy.
/// Příběhy navíc propojí jejich souvislosti.
TreeNode buildBibleTree({
  required List<StoryEra> eras,
  required List<BibleStory> stories,
  required List<BiblePerson> people,
}) {
  final root = TreeNode(
    id: 'bible',
    level: TreeLevel.bible,
    title: 'Bible',
    color: const Color(0xFFE8C77E),
  );
  final ot = TreeNode(
    id: 'ot',
    level: TreeLevel.testament,
    title: S.oldTestamentShort,
    subtitle: '39 knih',
    color: const Color(0xFFD9A55A),
  );
  final nt = TreeNode(
    id: 'nt',
    level: TreeLevel.testament,
    title: S.newTestamentShort,
    subtitle: '27 knih',
    color: const Color(0xFF6E9BD1),
  );
  root.children.addAll([ot, nt]);

  final personById = {for (final p in people) p.id: p};
  final storyNodes = <String, TreeNode>{};
  for (final era in eras) {
    final testament = era.books.isNotEmpty && era.books.first >= 40 ? nt : ot;
    final eraNode = TreeNode(
      id: 'era:${era.id}',
      level: TreeLevel.era,
      title: era.title,
      subtitle: era.period,
      color: era.books.isEmpty
          ? const Color(0xFF9A9087)
          : Color(categoryOf(era.books.first).color),
      era: era,
    );
    testament.children.add(eraNode);
    for (final st in stories.where((s) => s.era == era.id)) {
      final color = Color(categoryOf(st.passage.bookId).color);
      final node = TreeNode(
        id: 'story:${st.id}',
        level: TreeLevel.story,
        title: st.title,
        subtitle: st.span,
        color: color,
        story: st,
      );
      eraNode.children.add(node);
      storyNodes[st.id] = node;
      for (final pid in st.people) {
        final person = personById[pid];
        if (person == null) continue;
        node.children.add(
          TreeNode(
            id: 'person:${st.id}:$pid',
            level: TreeLevel.leaf,
            // Na mapě bez jiného jména v závorce: „Abraham (Abram)“.
            title: person.name.replaceAll(RegExp(r' \(.*\)$'), ''),
            subtitle: person.role,
            color: color,
            person: person,
          ),
        );
      }
    }
  }
  for (final st in stories) {
    final a = storyNodes[st.id]!;
    for (final (to, why) in st.links) {
      final b = storyNodes[to];
      if (b == null) continue;
      a.links.add((b, why));
      b.links.add((a, why));
    }
  }

  _layout(root);
  return root;
}

/// Uzel stromu, kam patří biblické místo: příběh, který kapitolu
/// obsahuje (nebo je nejblíž), jinak období, ke kterému kniha patří.
TreeNode? anchorFor(Passage p, List<TreeNode> nodes) {
  TreeNode? best;
  var bestDist = 1 << 30;
  for (final n in nodes) {
    final st = n.story;
    if (st == null || n.level != TreeLevel.story) continue;
    if (st.passage.bookId != p.bookId) continue;
    final d = p.chapter < st.passage.chapter
        ? st.passage.chapter - p.chapter
        : math.max(0, p.chapter - st.passage.endChapter);
    if (d < bestDist) (best, bestDist) = (n, d);
  }
  if (best != null) return best;
  for (final n in nodes) {
    final era = n.era;
    if (era == null) continue;
    if (era.books.contains(p.bookId) ||
        era.branches.any((b) => b.$2.contains(p.bookId))) {
      return n;
    }
  }
  return null;
}

/// Radiální rozložení: listy rovnoměrně po kruhu (s mezerami mezi
/// obdobími a knihami), vnitřní uzly uprostřed svých listů.
void _layout(TreeNode root) {
  var cursor = 0.0;
  final leaves = <(TreeNode, double)>[];
  void visit(TreeNode n) {
    for (final c in n.children) {
      c.parent = n;
    }
    if (n.children.isEmpty) {
      leaves.add((n, cursor));
      cursor += 1;
      return;
    }
    // Malá období a příběhy dostanou místo navíc, aby se jejich popisky
    // nepřekrývaly.
    final pad = switch (n.level) {
      TreeLevel.era => math.max(0, 16 - _leafCount(n)) / 2,
      TreeLevel.story => math.max(0, 2.2 - _leafCount(n)) / 2,
      _ => 0.0,
    };
    cursor += pad;
    for (final (i, c) in n.children.indexed) {
      if (i > 0) {
        cursor += switch (n.level) {
          TreeLevel.bible => 12.0,
          TreeLevel.testament => 4.0,
          TreeLevel.era => 0.8,
          _ => 0.0,
        };
      }
      visit(c);
    }
    cursor += pad;
  }

  visit(root);
  final total = cursor + 12;
  final angles = <TreeNode, double>{
    for (final (n, u) in leaves) n: -math.pi / 2 + 2 * math.pi * u / total,
  };
  double place(TreeNode n) {
    if (n.children.isEmpty) {
      n.angle = angles[n]!;
    } else {
      final a = [for (final c in n.children) place(c)];
      n.angle = (a.first + a.last) / 2;
    }
    final r = _radii[n.level.index];
    n.pos =
        const Offset(treeCanvas / 2, treeCanvas / 2) +
        Offset(math.cos(n.angle), math.sin(n.angle)) * r;
    return n.angle;
  }

  place(root);
}

int _leafCount(TreeNode n) =>
    n.children.isEmpty ? 1 : n.children.fold(0, (s, c) => s + _leafCount(c));

Iterable<TreeNode> _all(TreeNode n) sync* {
  yield n;
  for (final c in n.children) {
    yield* _all(c);
  }
}

/// Myšlenková mapa Bible: přibližováním se strom větví od celé Bible
/// po jednotlivé postavy a události. Nitě propojují vzdálené větve.
class BibleTreeView extends ConsumerStatefulWidget {
  const BibleTreeView({super.key});

  @override
  ConsumerState<BibleTreeView> createState() => _BibleTreeViewState();
}

class _BibleTreeViewState extends ConsumerState<BibleTreeView>
    with SingleTickerProviderStateMixin {
  final _transform = TransformationController();
  late final _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );
  Animation<Matrix4>? _tween;
  TreeNode? _root;
  List<TreeNode> _nodes = const [];
  TreeNode? _selected;
  BibleThread? _thread;
  double _fit = 1;
  Size _viewport = Size.zero;

  /// Nápověda zmizí po prvním dotyku (už je jasné, jak strom funguje).
  bool _hintSeen = false;

  @override
  void initState() {
    super.initState();
    _anim.addListener(() {
      if (_tween case final t?) _transform.value = t.value;
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    _transform.dispose();
    super.dispose();
  }

  Matrix4 _matrixFor(Offset canvasPoint, double zoom) {
    final s = _fit * zoom;
    return Matrix4.identity()
      ..translateByDouble(
        _viewport.width / 2 - canvasPoint.dx * s,
        _viewport.height / 2 - canvasPoint.dy * s,
        0,
        1,
      )
      // Stejné měřítko i v ose Z: InteractiveViewer čte aktuální zoom
      // přes getMaxScaleOnAxis, a s osou Z = 1 by se ruční zoom zasekl
      // na maxScale.
      ..scaleByDouble(s, s, s, 1);
  }

  void _animateTo(Offset point, double zoom) {
    _tween = Matrix4Tween(
      begin: _transform.value,
      end: _matrixFor(point, zoom),
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOutCubic));
    _anim.forward(from: 0);
  }

  void _reset() {
    setState(() => _selected = null);
    _animateTo(const Offset(treeCanvas / 2, treeCanvas / 2), 1);
  }

  double get _zoom => scaleOf(_transform.value) / _fit;

  void _onTap(Offset p) {
    if (!_hintSeen) setState(() => _hintSeen = true);
    final scale = scaleOf(_transform.value);
    final z = _zoom;
    TreeNode? hit;
    var best = 44 / scale;
    for (final n in _nodes) {
      if (levelAlpha(n.level, z) < 0.4) continue;
      final d = (n.pos - p).distance;
      if (d < best) (hit, best) = (n, d);
    }
    if (hit == null) return;
    _focus(hit);
  }

  void _focus(TreeNode n) {
    setState(() => _selected = n);
    final zoom = switch (n.level) {
      TreeLevel.bible => 1.0,
      TreeLevel.testament => 2.0,
      TreeLevel.era => 3.2,
      TreeLevel.story => 5.2,
      TreeLevel.leaf => math.max(_zoom, 6.5),
    };
    _animateTo(n.pos, zoom);
  }

  @override
  Widget build(BuildContext context) {
    final eras = ref.watch(storyProvider).value;
    final stories = ref.watch(storiesProvider).value;
    final people = ref.watch(peopleProvider).value;
    final threads = ref.watch(threadsProvider).value;
    if (eras == null || stories == null || people == null || threads == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final root = _root ??= buildBibleTree(
      eras: eras,
      stories: stories,
      people: people,
    );
    if (_nodes.isEmpty) _nodes = _all(root).toList();

    return LayoutBuilder(
      builder: (context, c) {
        final size = c.biggest;
        if (size != _viewport) {
          _viewport = size;
          _fit = math.min(size.width, size.height) / treeCanvas * 1.02;
          _transform.value = _matrixFor(
            const Offset(treeCanvas / 2, treeCanvas / 2),
            1,
          );
        }
        return Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(
                color: const Color(0xFF14110E),
                child: InteractiveViewer(
                  transformationController: _transform,
                  constrained: false,
                  minScale: _fit * 0.8,
                  maxScale: _fit * 14,
                  boundaryMargin: const EdgeInsets.all(treeCanvas / 2),
                  onInteractionStart: (_) {
                    if (!_hintSeen) setState(() => _hintSeen = true);
                  },
                  child: GestureDetector(
                    onTapUp: (d) => _onTap(d.localPosition),
                    child: CustomPaint(
                      size: const Size.square(treeCanvas),
                      painter: BibleTreePainter(
                        root: root,
                        nodes: _nodes,
                        transform: _transform,
                        fit: _fit,
                        viewport: size,
                        selected: _selected,
                        threads: threads,
                        thread: _thread,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: _ThreadChips(
                threads: threads,
                selected: _thread,
                onSelect: (t) => setState(() => _thread = t),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: MediaQuery.paddingOf(context).bottom + 12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _selected == null
                          ? (_hintSeen || isCompactHeight(context)
                                ? const SizedBox.shrink()
                                : const _Hint())
                          : _NodePanel(
                              key: ValueKey(_selected!.id),
                              node: _selected!,
                              nodes: _nodes,
                              onFocus: _focus,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    heroTag: 'tree-reset',
                    tooltip: S.treeWhole,
                    onPressed: _reset,
                    child: const Icon(Icons.zoom_out_map),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Měřítko v rovině (nezávislé na ose Z).
double scaleOf(Matrix4 m) =>
    math.sqrt(m.entry(0, 0) * m.entry(0, 0) + m.entry(1, 0) * m.entry(1, 0));

/// Průhlednost úrovně podle přiblížení (z = 1 je celá Bible na obrazovce).
double levelAlpha(TreeLevel level, double z) {
  double ramp(double from, double to) => ((z - from) / (to - from)).clamp(0, 1);
  return switch (level) {
    TreeLevel.bible || TreeLevel.testament => 1,
    TreeLevel.era => ramp(1.25, 1.75),
    TreeLevel.story => ramp(2.3, 3.0),
    TreeLevel.leaf => ramp(4.0, 5.0),
  };
}

class BibleTreePainter extends CustomPainter {
  BibleTreePainter({
    required this.root,
    required this.nodes,
    required this.transform,
    required this.fit,
    required this.viewport,
    required this.selected,
    required this.threads,
    required this.thread,
  }) : super(repaint: transform);

  final TreeNode root;
  final List<TreeNode> nodes;
  final TransformationController transform;
  final double fit;
  final Size viewport;
  final TreeNode? selected;
  final List<BibleThread> threads;
  final BibleThread? thread;

  static const _center = Offset(treeCanvas / 2, treeCanvas / 2);

  late final Map<String, List<TreeNode>> _threadNodes = {
    for (final t in threads)
      t.id: [for (final s in t.stations) ?anchorFor(s.passage, nodes)],
  };

  /// Příběh, k němuž patří vybraný uzel (příběh sám nebo jeho postava).
  TreeNode? get _selectedStory => switch (selected) {
    final n? when n.level == TreeLevel.story => n,
    final n? when n.level == TreeLevel.leaf => n.parent,
    _ => null,
  };

  @override
  void paint(Canvas canvas, Size size) {
    final m = transform.value;
    final scale = scaleOf(m);
    final z = scale / fit;
    // Viditelná oblast v souřadnicích plátna (pro vynechání popisků).
    final inv = Matrix4.tryInvert(m);
    final visible = inv == null
        ? Offset.zero & size
        : MatrixUtils.transformRect(inv, Offset.zero & viewport).inflate(200);

    // Jemná záře uprostřed.
    canvas.drawCircle(
      _center,
      treeCanvas / 2,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF3A2C1C).withValues(alpha: 0.9),
            const Color(0xFF14110E).withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: _center, radius: 1600)),
    );
    // Soustředné kružnice úrovní.
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 / scale
      ..color = Colors.white.withValues(alpha: 0.05);
    for (final r in _radii.skip(1)) {
      canvas.drawCircle(_center, r, ring);
    }

    // Hrany stromu.
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (final n in nodes) {
      final p = n.parent;
      if (p == null) continue;
      final a = levelAlpha(n.level, z);
      if (a <= 0) continue;
      final onPath = _onSelectedPath(n);
      edge
        ..color = n.color.withValues(alpha: a * (onPath ? 0.95 : 0.45))
        ..strokeWidth =
            (switch (n.level) {
              TreeLevel.testament => 10.0,
              TreeLevel.era => 6.0,
              TreeLevel.story => 3.0,
              _ => 1.4,
            }) *
            (onPath ? 1.6 : 1);
      // Hrana jde nejprve po kružnici rodiče a pak paprskem ven – jako
      // větev stromu.
      final mid = (_radii[p.level.index] + _radii[n.level.index]) / 2;
      final c1 = _center + Offset(math.cos(p.angle), math.sin(p.angle)) * mid;
      final c2 = _center + Offset(math.cos(n.angle), math.sin(n.angle)) * mid;
      final path = Path()
        ..moveTo(p.pos.dx, p.pos.dy)
        ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, n.pos.dx, n.pos.dy);
      canvas.drawPath(path, edge);
    }

    // Souvislosti mezi příběhy (oblouky svazované směrem ke středu).
    final storyAlpha = levelAlpha(TreeLevel.story, z);
    final focus = _selectedStory;
    if (storyAlpha > 0 && thread == null) {
      final link = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      for (final n in nodes) {
        for (final (o, _) in n.links) {
          // Každou dvojici kreslíme jednou.
          if (o.id.compareTo(n.id) < 0) continue;
          final hot = focus != null && (focus == n || focus == o);
          final a = storyAlpha * (hot ? 0.95 : (focus == null ? 0.28 : 0.07));
          link
            ..strokeWidth = (hot ? 3.4 : 1.6) / math.sqrt(scale) * 1.6
            ..color = Color.lerp(n.color, o.color, 0.5)!.withValues(alpha: a);
          final mid = Offset.lerp(n.pos, o.pos, 0.5)!;
          final ctrl = _center + (mid - _center) * 0.3;
          canvas.drawPath(
            Path()
              ..moveTo(n.pos.dx, n.pos.dy)
              ..quadraticBezierTo(ctrl.dx, ctrl.dy, o.pos.dx, o.pos.dy),
            link,
          );
        }
      }
    }

    // Nitě: témata, která se táhnou napříč příběhy.
    final bookAlpha = storyAlpha;
    for (final t in threads) {
      final active = thread?.id == t.id;
      final a = active ? 0.95 : (thread == null ? bookAlpha * 0.22 : 0.0);
      if (a <= 0) continue;
      final pts = _threadNodes[t.id]!;
      final link = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = (active ? 3.2 : 1.6) / math.sqrt(scale)
        ..color = Color(t.color).withValues(alpha: a);
      for (var i = 1; i < pts.length; i++) {
        final p1 = pts[i - 1].pos, p2 = pts[i].pos;
        if (p1 == p2) continue;
        final mid = Offset.lerp(p1, p2, 0.5)!;
        final ctrl = _center + (mid - _center) * 0.25;
        canvas.drawPath(
          Path()
            ..moveTo(p1.dx, p1.dy)
            ..quadraticBezierTo(ctrl.dx, ctrl.dy, p2.dx, p2.dy),
          link,
        );
      }
      if (active) {
        for (final (i, n) in pts.indexed) {
          canvas.drawCircle(n.pos, 16, Paint()..color = Color(t.color));
          _text(
            canvas,
            '${i + 1}',
            n.pos,
            16,
            Colors.white,
            bold: true,
            centered: true,
          );
        }
      }
    }

    // Uzly a popisky.
    for (final n in nodes) {
      final a = levelAlpha(n.level, z);
      if (a <= 0) continue;
      if (!visible.contains(n.pos) && n.level.index >= TreeLevel.story.index) {
        continue;
      }
      _node(canvas, n, a, scale);
    }
  }

  bool _onSelectedPath(TreeNode n) {
    for (TreeNode? s = selected; s != null; s = s.parent) {
      if (s == n) return true;
    }
    return false;
  }

  void _node(Canvas canvas, TreeNode n, double alpha, double scale) {
    final isSel = selected == n;
    final dot = Paint()..color = n.color.withValues(alpha: alpha);
    switch (n.level) {
      case TreeLevel.bible:
        canvas.drawCircle(n.pos, 150, Paint()..color = const Color(0xFF2A2117));
        canvas.drawCircle(
          n.pos,
          150,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6
            ..color = n.color,
        );
        _text(canvas, n.title, n.pos, _fontSizes[0], n.color, centered: true);
      case TreeLevel.testament || TreeLevel.era:
        final font = _fontSizes[n.level.index];
        final tp = _painter(
          n.title,
          font,
          Colors.white.withValues(alpha: alpha),
          maxWidth: n.level == TreeLevel.era ? 330 : 800,
          bold: true,
        );
        final box = Rect.fromCenter(
          center: n.pos,
          width: tp.width + font,
          height: tp.height + font * 0.6,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(box, Radius.circular(font * 0.6)),
          Paint()
            ..color = Color.lerp(
              const Color(0xFF14110E),
              n.color,
              0.55,
            )!.withValues(alpha: alpha * 0.95),
        );
        if (isSel) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              box.inflate(6),
              Radius.circular(font * 0.6 + 6),
            ),
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = Colors.white,
          );
        }
        tp.paint(canvas, n.pos - Offset(tp.width / 2, tp.height / 2));
      case TreeLevel.story || TreeLevel.leaf:
        final leaf = n.level == TreeLevel.leaf;
        final r = leaf ? 6.0 : 12.0;
        if (!leaf) {
          // Příběh: kosočtverec.
          canvas.save();
          canvas.translate(n.pos.dx, n.pos.dy);
          canvas.rotate(math.pi / 4);
          canvas.drawRect(
            Rect.fromCircle(center: Offset.zero, radius: r * 0.8),
            dot,
          );
          canvas.restore();
        } else {
          canvas.drawCircle(n.pos, r, dot);
        }
        if (isSel) {
          canvas.drawCircle(
            n.pos,
            r + 7,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = Colors.white,
          );
        }
        // Popisek po paprsku ven (na levé straně otočený, aby nebyl
        // vzhůru nohama).
        final font = _fontSizes[n.level.index];
        final flip = math.cos(n.angle) < 0;
        final tp = _painter(
          n.title,
          font,
          (leaf ? Colors.white : Color.lerp(n.color, Colors.white, 0.45)!)
              .withValues(alpha: alpha * (leaf ? 0.9 : 1)),
          bold: !leaf,
          maxWidth: leaf ? double.infinity : _storyLabelWidth,
          align: flip ? TextAlign.right : TextAlign.left,
        );
        canvas.save();
        canvas.translate(n.pos.dx, n.pos.dy);
        canvas.rotate(flip ? n.angle + math.pi : n.angle);
        final gap = r + 6;
        tp.paint(canvas, Offset(flip ? -gap - tp.width : gap, -tp.height / 2));
        canvas.restore();
    }
  }

  static final _cache = <String, TextPainter>{};

  TextPainter _painter(
    String text,
    double size,
    Color color, {
    double maxWidth = double.infinity,
    bool bold = false,
    TextAlign align = TextAlign.center,
  }) {
    final key = '$text|$size|${color.toARGB32()}|$maxWidth|$bold|$align';
    return _cache[key] ??= TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          height: 1.15,
        ),
      ),
      textAlign: align,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
  }

  void _text(
    Canvas canvas,
    String text,
    Offset at,
    double size,
    Color color, {
    bool bold = true,
    bool centered = false,
  }) {
    final tp = _painter(text, size, color, bold: bold);
    tp.paint(canvas, centered ? at - Offset(tp.width / 2, tp.height / 2) : at);
  }

  @override
  bool shouldRepaint(BibleTreePainter old) =>
      old.selected != selected ||
      old.thread != thread ||
      old.viewport != viewport ||
      old.root != root;
}

class _ThreadChips extends StatelessWidget {
  const _ThreadChips({
    required this.threads,
    required this.selected,
    required this.onSelect,
  });

  final List<BibleThread> threads;
  final BibleThread? selected;
  final ValueChanged<BibleThread?> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          for (final t in threads)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Material(
                color: selected == t
                    ? Color(t.color)
                    : Colors.black.withValues(alpha: 0.45),
                shape: StadiumBorder(
                  side: BorderSide(
                    color: Color(t.color).withValues(alpha: 0.7),
                  ),
                ),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: () => onSelect(selected == t ? null : t),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      t.title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        S.treeHint,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: Colors.white70),
      ),
    );
  }
}

/// Panel vybraného uzlu: popis, souvislosti a akce (podrobnosti, čtení…).
class _NodePanel extends ConsumerWidget {
  const _NodePanel({
    super.key,
    required this.node,
    required this.nodes,
    required this.onFocus,
  });

  final TreeNode node;
  final List<TreeNode> nodes;
  final ValueChanged<TreeNode> onFocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final era = node.era;
    final story = node.story;
    final person = node.person;
    final description =
        era?.summary ?? story?.summary ?? person?.lessons.firstOrNull;
    // Souvislosti příběhu, u postavy její další příběhy.
    final related = <(TreeNode, String)>[
      ...node.links,
      if (person != null)
        for (final n in nodes)
          if (n.person?.id == person.id && n != node) (n.parent!, S.treeAlsoIn),
    ];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: node.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    person?.name ?? node.title,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            if (node.subtitle case final s?)
              Padding(
                padding: const EdgeInsets.only(left: 18, top: 2),
                child: Text(
                  s,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: node.color,
                  ),
                ),
              ),
            if (description != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 6, 4, 0),
                child: Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            if (related.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 0, 4),
                child: Text(
                  person != null ? S.treeAlsoIn : S.treeLinks,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(
                height: person != null ? 40 : 64,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 14),
                  children: [
                    for (final (n, why) in related)
                      _LinkCard(
                        node: n,
                        why: person != null ? null : why,
                        onTap: () => onFocus(n),
                      ),
                  ],
                ),
              ),
            ],
            Wrap(
              alignment: WrapAlignment.end,
              children: [
                if (era != null)
                  TextButton(
                    onPressed: () => showEra(context, era),
                    child: const Text(S.treeEraDetail),
                  ),
                if (story != null) ...[
                  TextButton(
                    onPressed: () =>
                        showBookIntro(context, story.passage.bookId),
                    child: const Text(S.bookIntro),
                  ),
                  TextButton(
                    onPressed: () =>
                        openReaderAt(context, ref, story.passage.start),
                    child: const Text(S.treeRead),
                  ),
                ],
                if (person != null)
                  TextButton(
                    onPressed: () => openPerson(context, person),
                    child: const Text(S.treePerson),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Karta souvislosti: barevný proužek, název příběhu a proč souvisí.
class _LinkCard extends StatelessWidget {
  const _LinkCard({required this.node, required this.why, required this.onTap});

  final TreeNode node;
  final String? why;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: node.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            width: why == null ? null : 230,
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: node.color, width: 3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  node.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge,
                ),
                if (why != null)
                  Text(
                    why!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.2),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
