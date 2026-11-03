import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../shell/home_shell.dart';
import '../../today/application/today_providers.dart';
import '../../../domain/services/versification.dart';
import '../../translations/application/translation_controller.dart';

/// Sloupců mozaiky: 1189 kapitol = 41 × 29.
const _columns = 41;

/// Dlaždice mozaiky v pořadí Bible (kniha, kapitola).
List<(int, int)> mosaicTiles(Map<int, int> counts) => [
  for (var b = 1; b <= 66; b++)
    for (var c = 1; c <= (counts[b] ?? 0); c++) (b, c),
];

/// Mozaika celé Bible: každá přečtená kapitola odkryje jednu dlaždici
/// obrazu. Dlaždice jdou po sloupcích zleva doprava – Genesis je vlevo
/// u stromu života, Zjevení vpravo u nového Jeruzaléma.
class BibleMosaicCard extends ConsumerWidget {
  const BibleMosaicCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final data = _MosaicData.watch(ref);
    if (data == null) return const SizedBox.shrink();
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const MosaicScreen())),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: data.aspect,
                  child: _MosaicCanvas(data: data),
                ),
              ),
              const SizedBox(height: 4),
              _SectionStrip(data: data),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.grid_view_rounded, size: 18, color: palette.gold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      S.mosaicProgress(data.readCount, data.tiles.length),
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: palette.muted),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 26, top: 2),
                child: Text(
                  S.mosaicHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.muted,
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

/// Celá mozaika s přiblížením; klepnutí na dlaždici ukáže kapitolu.
class MosaicScreen extends ConsumerStatefulWidget {
  const MosaicScreen({super.key});

  @override
  ConsumerState<MosaicScreen> createState() => _MosaicScreenState();
}

class _MosaicScreenState extends ConsumerState<MosaicScreen> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final data = _MosaicData.watch(ref);
    final books = ref.watch(booksProvider);
    final sel = _selected == null || data == null
        ? null
        : data.tiles[_selected!];
    return Scaffold(
      appBar: AppBar(title: const Text(S.mosaic)),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Text(
                    S.mosaicIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, c) {
                      // Obraz na výšku obrazovky (otočený o 90°) by byl
                      // nepřirozený – necháme ho na šířku a dovolíme zoom.
                      final w = c.maxWidth - 16;
                      final h = math.min(c.maxHeight - 16, w / data.aspect);
                      final width = h * data.aspect;
                      return InteractiveViewer(
                        maxScale: 8,
                        boundaryMargin: const EdgeInsets.all(40),
                        child: Center(
                          child: GestureDetector(
                            onTapUp: (d) {
                              final col =
                                  (d.localPosition.dx / width * _columns)
                                      .floor();
                              final row = (d.localPosition.dy / h * data.rows)
                                  .floor();
                              final i = col * data.rows + row;
                              if (i >= 0 && i < data.tiles.length) {
                                setState(() => _selected = i);
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: width,
                                height: h,
                                child: _MosaicCanvas(
                                  data: data,
                                  selected: _selected,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: sel == null
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(
                            20,
                            8,
                            20,
                            MediaQuery.paddingOf(context).bottom + 16,
                          ),
                          child: Text(
                            S.mosaicProgress(data.readCount, data.tiles.length),
                            style: theme.textTheme.titleMedium,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.fromLTRB(
                            12,
                            8,
                            12,
                            MediaQuery.paddingOf(context).bottom + 12,
                          ),
                          child: Card(
                            child: ListTile(
                              leading: Icon(
                                data.isRead(sel)
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: data.isRead(sel)
                                    ? palette.gold
                                    : palette.muted,
                              ),
                              title: Text(
                                '${books[sel.$1 - 1].name} ${sel.$2}',
                              ),
                              subtitle: Text(
                                data.isRead(sel)
                                    ? S.chapterAlreadyRead
                                    : S.mosaicUnread,
                              ),
                              trailing: FilledButton.tonal(
                                onPressed: () => openReaderAt(
                                  context,
                                  ref,
                                  VerseRef(sel.$1, sel.$2),
                                  from: schemeOf(
                                    ref
                                        .read(translationControllerProvider)
                                        .primaryId,
                                  ),
                                ),
                                child: const Text(S.timelineRead),
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

/// Barevný pruh oddílů Bible pod mozaikou (šířka podle sloupců).
class _SectionStrip extends StatelessWidget {
  const _SectionStrip({required this.data});

  final _MosaicData data;

  @override
  Widget build(BuildContext context) {
    final cols = <int, int>{};
    for (final (i, t) in data.tiles.indexed) {
      if (i % data.rows != 0) continue;
      final c = bookCategories.indexOf(categoryOf(t.$1));
      cols[c] = (cols[c] ?? 0) + 1;
    }
    return Row(
      children: [
        for (final MapEntry(:key, :value) in cols.entries)
          Expanded(
            flex: value,
            child: Tooltip(
              message: bookCategories[key].name,
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 0.5),
                decoration: BoxDecoration(
                  color: Color(bookCategories[key].color),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MosaicData {
  _MosaicData(this.tiles, this.read)
    : rows = (tiles.length / _columns).ceil(),
      readCount = tiles
          .where((t) => read[t.$1]?.contains(t.$2) ?? false)
          .length;

  final List<(int, int)> tiles;
  final Map<int, Set<int>> read;
  final int rows;
  final int readCount;

  double get aspect => _columns / rows;

  bool isRead((int, int) t) => read[t.$1]?.contains(t.$2) ?? false;

  static _MosaicData? watch(WidgetRef ref) {
    final id = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final counts = ref.watch(chapterCountsProvider(id)).value;
    if (counts == null || counts.isEmpty) return null;
    final read = ref.watch(readChaptersProvider).value ?? const {};
    return _MosaicData(mosaicTiles(counts), read);
  }
}

class _MosaicCanvas extends StatelessWidget {
  const _MosaicCanvas({required this.data, this.selected});

  final _MosaicData data;
  final int? selected;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return RepaintBoundary(
      child: CustomPaint(
        painter: MosaicPainter(
          read: [for (final t in data.tiles) data.isRead(t)],
          rows: data.rows,
          grout: palette.card,
          cover: dark ? const Color(0xFF2A2622) : const Color(0xFFEDE6DA),
          selected: selected,
          highlight: palette.gold,
        ),
      ),
    );
  }
}

/// Kreslí mozaiku: obraz pod dlaždicemi, nepřečtené kapitoly zakryté
/// (obraz jen tušený), přečtené v plných barvách.
class MosaicPainter extends CustomPainter {
  MosaicPainter({
    required this.read,
    required this.rows,
    required this.grout,
    required this.cover,
    required this.highlight,
    this.selected,
  });

  final List<bool> read;
  final int rows;
  final Color grout;
  final Color cover;
  final Color highlight;
  final int? selected;

  @override
  void paint(Canvas canvas, Size size) {
    final tw = size.width / _columns;
    final th = size.height / rows;
    final gap = math.max(0.6, math.min(tw, th) * 0.08);
    canvas.drawRect(Offset.zero & size, Paint()..color = grout);

    Rect tile(int i) {
      final col = i ~/ rows;
      final row = i % rows;
      return Rect.fromLTWH(
        col * tw + gap / 2,
        row * th + gap / 2,
        tw - gap,
        th - gap,
      );
    }

    final revealed = Path();
    final hidden = Path();
    for (var i = 0; i < read.length; i++) {
      final r = RRect.fromRectAndRadius(tile(i), Radius.circular(gap));
      (read[i] ? revealed : hidden).addRRect(r);
    }

    // Nepřečtené: jen bledý náznak obrazu.
    canvas.save();
    canvas.clipPath(hidden);
    canvas.drawRect(Offset.zero & size, Paint()..color = cover);
    canvas.saveLayer(
      Offset.zero & size,
      Paint()
        ..colorFilter = const ColorFilter.matrix([
          0.33, 0.33, 0.33, 0, 0, //
          0.33, 0.33, 0.33, 0, 0, //
          0.33, 0.33, 0.33, 0, 0, //
          0, 0, 0, 0.16, 0,
        ]),
    );
    paintBibleScene(canvas, size);
    canvas.restore();
    canvas.restore();

    // Přečtené: plné barvy a jemná nerovnost kamínků.
    canvas.save();
    canvas.clipPath(revealed);
    paintBibleScene(canvas, size);
    final rnd = math.Random(3);
    final shade = Paint();
    for (var i = 0; i < read.length; i++) {
      final v = rnd.nextDouble();
      if (!read[i]) continue;
      shade.color = (v > 0.5 ? Colors.white : Colors.black).withValues(
        alpha: (v - 0.5).abs() * 0.12,
      );
      canvas.drawRect(tile(i), shade);
    }
    canvas.restore();

    if (selected case final s?) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(tile(s).inflate(gap), Radius.circular(gap)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.5, gap * 2)
          ..color = highlight,
      );
    }
  }

  @override
  bool shouldRepaint(MosaicPainter old) =>
      old.rows != rows ||
      old.selected != selected ||
      old.grout != grout ||
      old.cover != cover ||
      !_same(old.read, read);

  static bool _same(List<bool> a, List<bool> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Obraz pod mozaikou – cesta Bible zleva doprava: noc stvoření a strom
/// života, hora Sínaj, Jeruzalém s chrámem, pahorek s křížem a zářící
/// nové město. Vlastní kresba aplikace.
void paintBibleScene(Canvas canvas, Size size) {
  final w = size.width;
  final h = size.height;
  Offset p(double x, double y) => Offset(x * w, y * h);
  final rect = Offset.zero & size;

  // Obloha: vlevo noc stvoření, vpravo zlaté světlo.
  canvas.drawRect(
    rect,
    Paint()
      ..shader = ui.Gradient.linear(
        p(0, 0),
        p(1, 0),
        [
          const Color(0xFF1E2A4F),
          const Color(0xFF3F5E96),
          const Color(0xFF8FB3D9),
          const Color(0xFFF2C77E),
        ],
        const [0, 0.25, 0.6, 1],
      ),
  );
  canvas.drawRect(
    rect,
    Paint()
      ..shader = ui.Gradient.linear(p(0, 0.25), p(0, 0.62), [
        const Color(0x00FFFFFF),
        const Color(0x66FFE2B0),
      ]),
  );
  // Hvězdy stvoření.
  final rnd = math.Random(11);
  final star = Paint()..color = Colors.white.withValues(alpha: 0.85);
  for (var i = 0; i < 60; i++) {
    final x = math.pow(rnd.nextDouble(), 1.8) * 0.4;
    final y = rnd.nextDouble() * 0.4;
    canvas.drawCircle(p(x, y), (0.6 + rnd.nextDouble()) * w / 900, star);
  }
  // Slunce a světlo nového města.
  canvas.drawCircle(
    p(0.9, 0.3),
    w * 0.32,
    Paint()
      ..shader = ui.Gradient.radial(
        p(0.9, 0.3),
        w * 0.32,
        [
          const Color(0xFFFFF6D8),
          const Color(0x99FFE4A0),
          const Color(0x00FFE4A0),
        ],
        const [0, 0.25, 1],
      ),
  );

  // Vzdálené hory.
  final far = Path()..moveTo(0, h * 0.58);
  for (var i = 0; i <= 20; i++) {
    final x = i / 20;
    final y = 0.5 + 0.06 * math.sin(i * 1.7) + 0.03 * math.cos(i * 3.1);
    far.lineTo(x * w, y * h);
  }
  far
    ..lineTo(w, h)
    ..lineTo(0, h)
    ..close();
  canvas.drawPath(far, Paint()..color = const Color(0xFF7286A8));

  // Hora Sínaj s ohněm a oblakem (Exodus).
  final sinai = Path()
    ..moveTo(p(0.04, 0.62).dx, p(0.04, 0.62).dy)
    ..lineTo(p(0.12, 0.26).dx, p(0.12, 0.26).dy)
    ..lineTo(p(0.14, 0.3).dx, p(0.14, 0.3).dy)
    ..lineTo(p(0.22, 0.62).dx, p(0.22, 0.62).dy)
    ..close();
  canvas.drawPath(sinai, Paint()..color = const Color(0xFF5C5470));
  canvas.drawCircle(
    p(0.125, 0.24),
    w * 0.04,
    Paint()
      ..shader = ui.Gradient.radial(p(0.125, 0.24), w * 0.04, [
        const Color(0xFFFFC163),
        const Color(0x00FF8A3D),
      ]),
  );
  final cloud = Paint()..color = const Color(0xCCE7E9F2);
  for (final (x, y, r) in [
    (0.1, 0.21, 0.025),
    (0.13, 0.19, 0.03),
    (0.16, 0.21, 0.022),
  ]) {
    canvas.drawCircle(p(x, y), r * w, cloud);
  }

  // Zvlněné kopce.
  void hill(double y0, double amp, double phase, Color c) {
    final path = Path()..moveTo(0, h);
    for (var i = 0; i <= 40; i++) {
      final x = i / 40;
      final y =
          y0 + amp * math.sin(x * 9 + phase) + amp * 0.5 * math.sin(x * 23);
      path.lineTo(x * w, y * h);
    }
    path
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(path, Paint()..color = c);
  }

  hill(0.64, 0.025, 0.4, const Color(0xFF7E9A5C));

  // Jeruzalém na hoře: hradby a chrám (doba králů).
  final wall = Paint()..color = const Color(0xFFD8C39A);
  final wallDark = Paint()..color = const Color(0xFFB89E70);
  canvas.drawRect(Rect.fromLTRB(0.24 * w, 0.52 * h, 0.4 * w, 0.64 * h), wall);
  for (var i = 0; i < 8; i++) {
    final x = 0.24 + i * 0.02;
    canvas.drawRect(Rect.fromLTWH(x * w, 0.5 * h, -0.048 * w, 0.025 * h), wall);
  }
  canvas.drawRect(
    Rect.fromLTRB(0.29 * w, 0.4 * h, 0.35 * w, 0.52 * h),
    Paint()..color = const Color(0xFFEBDDBA),
  );
  canvas.drawRect(
    Rect.fromLTRB(0.305 * w, 0.44 * h, 0.335 * w, 0.52 * h),
    wallDark,
  );
  final roof = Path()
    ..moveTo(0.285 * w, 0.4 * h)
    ..lineTo(0.32 * w, 0.35 * h)
    ..lineTo(0.355 * w, 0.4 * h)
    ..close();
  canvas.drawPath(roof, Paint()..color = const Color(0xFFC9A24B));

  // Řeka života – teče z Edenu až k městu.
  final river = Path()
    ..moveTo(0, 0.78 * h)
    ..cubicTo(0.2 * w, 0.68 * h, 0.35 * w, 0.92 * h, 0.55 * w, 0.8 * h)
    ..cubicTo(0.72 * w, 0.7 * h, 0.82 * w, 0.76 * h, w, 0.68 * h);
  canvas.drawPath(
    river,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.06 * h
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF4F8CC4),
  );
  canvas.drawPath(
    river,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.02 * h
      ..color = const Color(0xFFA9D2F0),
  );

  // Popředí: zahrada.
  hill(0.86, 0.02, 1.3, const Color(0xFF4F7436));
  final flower = Paint();
  for (var i = 0; i < 70; i++) {
    final x = rnd.nextDouble();
    final y = 0.88 + rnd.nextDouble() * 0.1;
    flower.color = [
      const Color(0xFFF2D06B),
      const Color(0xFFE88BA6),
      const Color(0xFFFFFFFF),
    ][i % 3].withValues(alpha: 0.9);
    canvas.drawCircle(p(x, y), w * 0.0035, flower);
  }

  // Strom života (Genesis).
  canvas.drawRect(
    Rect.fromLTRB(0.045 * w, 0.6 * h, 0.06 * w, 0.88 * h),
    Paint()..color = const Color(0xFF6B4A2B),
  );
  final leaves = Paint()..color = const Color(0xFF3E7A3A);
  for (final (x, y, r) in [
    (0.052, 0.52, 0.055),
    (0.02, 0.6, 0.04),
    (0.085, 0.6, 0.042),
    (0.052, 0.64, 0.04),
  ]) {
    canvas.drawCircle(p(x, y), r * w, leaves);
  }
  final fruit = Paint()..color = const Color(0xFFE5A23C);
  for (final (x, y) in [
    (0.035, 0.5),
    (0.065, 0.55),
    (0.02, 0.6),
    (0.09, 0.62),
    (0.05, 0.62),
  ]) {
    canvas.drawCircle(p(x, y), w * 0.006, fruit);
  }

  // Pařez s novým výhonkem (proroci, Iz 11,1).
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTRB(0.645 * w, 0.6 * h, 0.685 * w, 0.72 * h),
      Radius.circular(w * 0.004),
    ),
    Paint()..color = const Color(0xFF6B4A2B),
  );
  canvas.drawOval(
    Rect.fromLTRB(0.645 * w, 0.585 * h, 0.685 * w, 0.615 * h),
    Paint()..color = const Color(0xFFB08A5C),
  );
  final shoot = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = w * 0.004
    ..color = const Color(0xFF5FA34A);
  canvas.drawPath(
    Path()
      ..moveTo(0.665 * w, 0.6 * h)
      ..quadraticBezierTo(0.66 * w, 0.5 * h, 0.675 * w, 0.44 * h),
    shoot,
  );
  final sprout = Paint()..color = const Color(0xFF6DBE55);
  for (final (x, y, a) in [
    (0.672, 0.47, -0.6),
    (0.66, 0.52, 0.6),
    (0.676, 0.44, -0.2),
  ]) {
    canvas.save();
    canvas.translate(x * w, y * h);
    canvas.rotate(a);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: w * 0.018, height: w * 0.008),
      sprout,
    );
    canvas.restore();
  }

  // Betlémská hvězda nad začátkem evangelií.
  final bright = Paint()..color = const Color(0xFFFFF4C8);
  final sp = Path();
  for (var i = 0; i < 8; i++) {
    final a = i * math.pi / 4 - math.pi / 2;
    final r = i.isEven ? w * 0.016 : w * 0.005;
    final o = p(0.785, 0.14) + Offset(math.cos(a), math.sin(a)) * r;
    i == 0 ? sp.moveTo(o.dx, o.dy) : sp.lineTo(o.dx, o.dy);
  }
  canvas.drawPath(sp..close(), bright);

  // Pahorek s křížem (evangelia).
  final calvary = Path()
    ..moveTo(0.76 * w, 0.68 * h)
    ..quadraticBezierTo(0.82 * w, 0.48 * h, 0.88 * w, 0.68 * h)
    ..close();
  canvas.drawPath(calvary, Paint()..color = const Color(0xFF8E9A63));
  final wood = Paint()..color = const Color(0xFF5A3D24);
  canvas.drawRect(
    Rect.fromLTRB(0.816 * w, 0.32 * h, 0.824 * w, 0.58 * h),
    wood,
  );
  canvas.drawRect(
    Rect.fromLTRB(0.798 * w, 0.38 * h, 0.842 * w, 0.395 * h),
    wood,
  );

  // Nové město – zlaté hradby, brány a světlo (Zjevení).
  final gold = Paint()..color = const Color(0xFFF3D27A);
  final goldDark = Paint()..color = const Color(0xFFD9AE4C);
  canvas.drawRect(Rect.fromLTRB(0.88 * w, 0.42 * h, w, 0.7 * h), gold);
  for (final x in [0.885, 0.93, 0.975]) {
    canvas.drawRect(Rect.fromLTWH(x * w, 0.32 * h, 0.03 * w, 0.38 * h), gold);
    canvas.drawRect(
      Rect.fromLTWH((x + 0.008) * w, 0.58 * h, 0.014 * w, 0.12 * h),
      Paint()..color = const Color(0xFFFFFBEA),
    );
  }
  canvas.drawRect(Rect.fromLTRB(0.88 * w, 0.42 * h, w, 0.44 * h), goldDark);
  // Paprsky ze středu města.
  final ray = Paint()
    ..color = const Color(0x33FFFFFF)
    ..strokeWidth = w * 0.004;
  for (var i = 0; i < 9; i++) {
    final a = math.pi + i * math.pi / 8;
    canvas.drawLine(
      p(0.94, 0.4),
      p(0.94, 0.4) + Offset(math.cos(a), math.sin(a)) * w * 0.12,
      ray,
    );
  }

  // Cesta – od zahrady k městu.
  final road = Path()
    ..moveTo(0.06 * w, h)
    ..cubicTo(0.3 * w, 0.9 * h, 0.6 * w, 1.02 * h, 0.94 * w, 0.72 * h);
  canvas.drawPath(
    road,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.035 * h
      ..color = const Color(0xCCE9D7AE),
  );
}
