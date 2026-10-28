import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../content/application/content_providers.dart';
import '../../content/presentation/people_screen.dart';
import '../../shell/home_shell.dart';
import '../../study/presentation/book_intro_sheet.dart';
import 'connections_screen.dart';

/// Úroveň uzlu ve stromu.
enum TreeLevel { bible, testament, era, book, leaf }

/// Uzel myšlenkové mapy Bible.
class TreeNode {
  TreeNode({
    required this.id,
    required this.level,
    required this.title,
    required this.color,
    this.subtitle,
    this.era,
    this.book,
    this.person,
    this.passage,
  });

  final String id;
  final TreeLevel level;
  final String title;
  final String? subtitle;
  final Color color;
  final StoryEra? era;
  final int? book;
  final BiblePerson? person;

  /// Klíčová kapitola (list stromu).
  final Passage? passage;

  final children = <TreeNode>[];
  TreeNode? parent;

  /// Úhel (radiány, 0 = vpravo, po směru hodinových ručiček) a poloha.
  double angle = 0;
  Offset pos = Offset.zero;
  TextPainter? label;
}

const treeCanvas = 3300.0;
const _radii = [0.0, 610.0, 920.0, 1180.0, 1430.0];
const _fontSizes = [190.0, 92.0, 44.0, 25.0, 15.0];

/// Postaví strom: Bible → zákony → období → knihy → postavy a události.
TreeNode buildBibleTree({
  required List<StoryEra> eras,
  required List<BiblePerson> people,
  required List<Book> books,
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

  // Kniha → uzly knihy v obdobích (Genesis je ve dvou obdobích…).
  final bookNodes = <int, List<(TreeNode, StoryEra)>>{};
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
    final ids = <int>{...era.books, for (final (_, b) in era.branches) ...b};
    for (final b in ids) {
      final node = TreeNode(
        id: 'book:${era.id}:$b',
        level: TreeLevel.book,
        title: books[b - 1].name,
        subtitle: categoryOf(b).name,
        color: Color(categoryOf(b).color),
        book: b,
      );
      eraNode.children.add(node);
      (bookNodes[b] ??= []).add((node, era));
    }
    for (final (p, label) in era.key) {
      final leaf = TreeNode(
        id: 'key:${era.id}:${p.bookId}:${p.chapter}',
        level: TreeLevel.leaf,
        title: label,
        subtitle: S.chapterTitle(books[p.bookId - 1].name, p.chapter),
        color: Color(categoryOf(p.bookId).color),
        passage: p,
      );
      final owner = [
        for (final (n, e)
            in bookNodes[p.bookId] ?? const <(TreeNode, StoryEra)>[])
          if (e == era) n,
      ];
      (owner.isEmpty ? eraNode : owner.first).children.add(leaf);
    }
  }

  // Postavy k uzlu knihy svého klíčového verše; u knih ve více obdobích
  // rozhodne nejbližší klíčová kapitola.
  for (final p in people) {
    final r = p.key.start;
    final options = bookNodes[r.bookId];
    if (options == null || options.isEmpty) continue;
    var best = options.first.$1;
    var bestDist = 1 << 30;
    for (final (node, era) in options) {
      for (final (k, _) in era.key) {
        if (k.bookId != r.bookId) continue;
        final d = (k.chapter - r.chapter).abs();
        if (d < bestDist) (best, bestDist) = (node, d);
      }
    }
    best.children.add(
      TreeNode(
        id: 'person:${p.id}',
        level: TreeLevel.leaf,
        title: p.name,
        subtitle: p.role,
        color: Color(categoryOf(r.bookId).color),
        person: p,
      ),
    );
  }

  _layout(root);
  return root;
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
    // Malá období dostanou místo navíc, aby se jejich popisky nepřekrývaly.
    final pad = n.level == TreeLevel.era
        ? math.max(0, 22 - _leafCount(n)) / 2
        : 0.0;
    cursor += pad;
    for (final (i, c) in n.children.indexed) {
      if (i > 0) {
        cursor += switch (n.level) {
          TreeLevel.bible => 12.0,
          TreeLevel.testament => 4.0,
          TreeLevel.era => 0.5,
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
      ..scaleByDouble(s, s, 1, 1);
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
    setState(() => _selected = hit);
    final zoom = switch (hit.level) {
      TreeLevel.bible => 1.0,
      TreeLevel.testament => 2.0,
      TreeLevel.era => 3.4,
      TreeLevel.book => 5.6,
      TreeLevel.leaf => math.max(z, 6.5),
    };
    _animateTo(hit.pos, zoom);
  }

  @override
  Widget build(BuildContext context) {
    final eras = ref.watch(storyProvider).value;
    final people = ref.watch(peopleProvider).value;
    final threads = ref.watch(threadsProvider).value;
    final books = ref.watch(booksProvider);
    if (eras == null || people == null || threads == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final root = _root ??= buildBibleTree(
      eras: eras,
      people: people,
      books: books,
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
                          ? const _Hint()
                          : _NodePanel(
                              key: ValueKey(_selected!.id),
                              node: _selected!,
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

/// Měřítko v rovině (getMaxScaleOnAxis by vrátil 1 z osy Z).
double scaleOf(Matrix4 m) => math.sqrt(
  m.entry(0, 0) * m.entry(0, 0) + m.entry(1, 0) * m.entry(1, 0),
);

/// Průhlednost úrovně podle přiblížení (z = 1 je celá Bible na obrazovce).
double levelAlpha(TreeLevel level, double z) {
  double ramp(double from, double to) => ((z - from) / (to - from)).clamp(0, 1);
  return switch (level) {
    TreeLevel.bible || TreeLevel.testament => 1,
    TreeLevel.era => ramp(1.25, 1.75),
    TreeLevel.book => ramp(2.3, 3.0),
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

  /// Uzel knihy, kam patří místo nitě (nejbližší podle klíčových kapitol).
  TreeNode? _bookNode(Passage p) {
    TreeNode? best;
    var bestDist = 1 << 30;
    for (final n in nodes) {
      if (n.book != p.bookId) continue;
      best ??= n;
      final era = n.parent?.era;
      for (final (k, _) in era?.key ?? const <(Passage, String)>[]) {
        if (k.bookId != p.bookId) continue;
        final d = (k.chapter - p.chapter).abs();
        if (d < bestDist) (best, bestDist) = (n, d);
      }
    }
    return best;
  }

  late final Map<String, List<TreeNode>> _threadNodes = {
    for (final t in threads)
      t.id: [for (final s in t.stations) ?_bookNode(s.passage)],
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
              TreeLevel.book => 3.0,
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

    // Nitě: spojnice mezi knihami (svazované směrem ke středu).
    final bookAlpha = levelAlpha(TreeLevel.book, z);
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
      if (!visible.contains(n.pos) && n.level.index >= TreeLevel.book.index) {
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
      case TreeLevel.book || TreeLevel.leaf:
        final leaf = n.level == TreeLevel.leaf;
        final r = leaf ? 6.0 : 11.0;
        if (n.passage != null) {
          // Klíčová událost: kosočtverec.
          canvas.save();
          canvas.translate(n.pos.dx, n.pos.dy);
          canvas.rotate(math.pi / 4);
          canvas.drawRect(Rect.fromCircle(center: Offset.zero, radius: r), dot);
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
        final tp = _painter(
          n.title,
          font,
          (leaf ? Colors.white : Color.lerp(n.color, Colors.white, 0.45)!)
              .withValues(alpha: alpha * (leaf ? 0.9 : 1)),
          bold: !leaf,
        );
        final flip = math.cos(n.angle) < 0;
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
  }) {
    final key = '$text|$size|${color.toARGB32()}|$maxWidth|$bold';
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
      textAlign: TextAlign.center,
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

/// Panel vybraného uzlu: popis a akce (podrobnosti, úvod, čtení…).
class _NodePanel extends ConsumerWidget {
  const _NodePanel({super.key, required this.node});

  final TreeNode node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final era = node.era;
    final book = node.book;
    final person = node.person;
    final passage = node.passage;
    final description = era?.summary ?? person?.lessons.firstOrNull;
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
                  child: Text(node.title, style: theme.textTheme.titleMedium),
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
            Wrap(
              alignment: WrapAlignment.end,
              children: [
                if (era != null)
                  TextButton(
                    onPressed: () => showEra(context, era),
                    child: const Text(S.treeEraDetail),
                  ),
                if (book != null) ...[
                  TextButton(
                    onPressed: () => showBookIntro(context, book),
                    child: const Text(S.bookIntro),
                  ),
                  TextButton(
                    onPressed: () =>
                        openReaderAt(context, ref, VerseRef(book, 1)),
                    child: const Text(S.treeRead),
                  ),
                ],
                if (person != null)
                  TextButton(
                    onPressed: () => openPerson(context, person),
                    child: const Text(S.treePerson),
                  ),
                if (passage != null)
                  TextButton(
                    onPressed: () => openReaderAt(context, ref, passage.start),
                    child: const Text(S.treeRead),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
