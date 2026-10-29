import 'dart:math' as math;

import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/services/versification.dart';
import '../../content/application/content_providers.dart';
import '../../content/presentation/passage_card.dart';
import '../../shell/home_shell.dart';
import '../../study/presentation/book_intro_sheet.dart';
import 'bible_tree_view.dart';

/// Pohledy obrazovky Souvislosti.
enum ConnectionsView { tree, story, threads, arcs }

void openConnections(
  BuildContext context, {
  ConnectionsView view = ConnectionsView.tree,
  int? book,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => ConnectionsScreen(initial: view, book: book),
  ),
);

Color _bookColor(int bookId) => Color(categoryOf(bookId).color);

/// Globální index kapitoly (anglické číslování) pro kanonický odkaz.
int chapterIndexOf(BibleConnections data, VerseRef canonical) {
  final eng = Versification.convert(
    canonical,
    VerseScheme.hebrew,
    VerseScheme.english,
  );
  final count = data.verses[eng.bookId - 1].length;
  return data.chapterStart[eng.bookId - 1] + eng.chapter.clamp(1, count) - 1;
}

/// Souvislosti v Bibli: velký příběh, červené nitě a mapa odkazů.
class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({
    super.key,
    this.initial = ConnectionsView.tree,
    this.book,
  });

  final ConnectionsView initial;

  /// Kniha předvybraná v mapě odkazů.
  final int? book;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: initial.index,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(S.connections),
          bottom: const TabBar(
            tabs: [
              Tab(text: S.tabTree),
              Tab(text: S.tabStory),
              Tab(text: S.tabThreads),
              Tab(text: S.tabArcs),
            ],
          ),
        ),
        body: TabBarView(
          // Posouvání mezi záložkami by se bilo s posouváním stromu.
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const BibleTreeView(),
            ReadableWidth(child: const _StoryView()),
            ReadableWidth(child: const _ThreadsView()),
            ReadableWidth(child: _ArcsView(initialBook: book)),
          ],
        ),
      ),
    );
  }
}

EdgeInsets _listPadding(BuildContext context) =>
    EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.paddingOf(context).bottom + 32);

// --- Velký příběh ------------------------------------------------------------

Color _eraColor(StoryEra era, AppPalette palette) =>
    era.books.isEmpty ? palette.muted : _bookColor(era.books.first);

/// Kniha, která vypráví souvislý úsek období (od–do, indexy období),
/// a její dráha (řádek) v diagramu.
typedef _BookSpan = ({int book, int from, int to, int lane});

/// Rozdělí vyprávějící knihy do drah tak, aby se souběžné knihy
/// (Samuel, Královská, Paralipomenon…) nepřekrývaly.
List<_BookSpan> _bookSpans(List<StoryEra> eras) {
  final spans = <({int book, int from, int to})>[];
  final seen = <int>{};
  for (final (i, era) in eras.indexed) {
    for (final b in era.books) {
      if (!seen.add(b)) continue;
      var to = i;
      for (var j = i + 1; j < eras.length; j++) {
        if (eras[j].books.contains(b)) to = j;
      }
      spans.add((book: b, from: i, to: to));
    }
  }
  final laneEnd = <int>[];
  final out = <_BookSpan>[];
  for (final sp in spans) {
    var lane = laneEnd.indexWhere((end) => end < sp.from);
    if (lane < 0) {
      lane = laneEnd.length;
      laneEnd.add(sp.to);
    } else {
      laneEnd[lane] = sp.to;
    }
    out.add((book: sp.book, from: sp.from, to: sp.to, lane: lane));
  }
  return out;
}

/// Velký příběh jako vodorovná řeka dějin: období jsou sloupce zleva
/// doprava, pod proudem leží pruhy knih, které dobu vyprávějí (přes
/// všechna období, která pokrývají), a dole knihy, které k době patří.
class _StoryView extends ConsumerWidget {
  const _StoryView();

  static const _col = 160.0;
  static const _lane = 34.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final eras = ref.watch(storyProvider).value;
    if (eras == null) return const Center(child: CircularProgressIndicator());
    final books = ref.watch(booksProvider);
    final spans = _bookSpans(eras);
    final lanes = spans.fold(0, (m, s) => math.max(m, s.lane + 1));
    final colors = [for (final e in eras) _eraColor(e, palette)];
    final width = eras.length * _col;

    Widget label(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: palette.muted,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );

    return ListView(
      padding: EdgeInsets.fromLTRB(
        0,
        12,
        0,
        MediaQuery.paddingOf(context).bottom + 32,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text(
            S.storyIntro,
            style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _StoryLegend(),
        ),
        const SizedBox(height: 8),
        ScrollConfiguration(
          // Diagram jde táhnout i myší (na počítači).
          behavior: ScrollConfiguration.of(context)
              .copyWith(dragDevices: PointerDeviceKind.values.toSet()),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: width,
              child: Stack(
                children: [
                  // Svislé předěly mezi obdobími.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ColumnsPainter(
                        count: eras.length,
                        width: _col,
                        color: palette.muted.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Názvy období.
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final (i, era) in eras.indexed)
                            SizedBox(
                              width: _col,
                              child: _EraHeader(
                                era: era,
                                number: i + 1,
                                color: colors[i],
                              ),
                            ),
                        ],
                      ),
                      // Proud dějin.
                      SizedBox(
                        width: width,
                        height: 34,
                        child: CustomPaint(
                          painter: _RiverPainter(
                            colors: colors,
                            thin: [for (final e in eras) e.books.isEmpty],
                            column: _col,
                            background: theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                      label(S.storyTells),
                      // Dráhy knih.
                      for (var lane = 0; lane < lanes; lane++)
                        SizedBox(
                          width: width,
                          height: _lane,
                          child: Stack(
                            children: [
                              for (final sp in spans.where(
                                (s) => s.lane == lane,
                              ))
                                Positioned(
                                  left: sp.from * _col + 6,
                                  width: (sp.to - sp.from + 1) * _col - 12,
                                  top: 3,
                                  bottom: 3,
                                  child: _BookBar(
                                    book: sp.book,
                                    name: books[sp.book - 1].name,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      label(S.storyBelongs),
                      // Knihy, které k době patří.
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final era in eras)
                            SizedBox(
                              width: _col,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  0,
                                  10,
                                  0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (final (text, b) in era.branches) ...[
                                      Text(
                                        text,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(color: palette.muted),
                                      ),
                                      const SizedBox(height: 4),
                                      _BookChips(books: b, small: true),
                                      const SizedBox(height: 10),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            children: [
              Icon(Icons.swipe, size: 18, color: palette.muted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  S.storyScrollHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: palette.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Záhlaví sloupce: číslo, název a doba období a klíčové události.
class _EraHeader extends StatelessWidget {
  const _EraHeader({
    required this.era,
    required this.number,
    required this.color,
  });

  final StoryEra era;
  final int number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => showEra(context, era),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  era.title,
                  maxLines: 2,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              era.period,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 48,
              child: Text(
                era.key.isEmpty
                    ? S.storyNoBooksShort
                    : [for (final (_, l) in era.key) l].join(' · '),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: palette.muted,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Proud dějin: pás, který plynule mění barvu podle období, s očíslovanými
/// uzly; v době bez knih se zúží.
class _RiverPainter extends CustomPainter {
  _RiverPainter({
    required this.colors,
    required this.thin,
    required this.column,
    required this.background,
  });

  final List<Color> colors;
  final List<bool> thin;
  final double column;
  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    for (var i = 0; i < colors.length; i++) {
      final x0 = i * column, x1 = x0 + column;
      final prev = i == 0 ? colors[i] : colors[i - 1];
      final next = i == colors.length - 1 ? colors[i] : colors[i + 1];
      final h = thin[i] ? 4.0 : 12.0;
      final rect = Rect.fromLTRB(x0, y - h / 2, x1, y + h / 2);
      canvas.drawRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            colors: [
              Color.lerp(prev, colors[i], 0.5)!,
              colors[i],
              Color.lerp(colors[i], next, 0.5)!,
            ],
          ).createShader(rect),
      );
    }
    for (var i = 0; i < colors.length; i++) {
      final c = Offset(i * column + 26, y);
      canvas.drawCircle(c, 15, Paint()..color = background);
      canvas.drawCircle(c, 13, Paint()..color = colors[i]);
      final tp = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
    }
    // Šipka na konci: příběh pokračuje.
    final end = Offset(size.width - 4, y);
    canvas.drawPath(
      Path()
        ..moveTo(end.dx - 12, y - 10)
        ..lineTo(end.dx, y)
        ..lineTo(end.dx - 12, y + 10)
        ..close(),
      Paint()..color = colors.last,
    );
  }

  @override
  bool shouldRepaint(_RiverPainter old) =>
      old.colors != colors || old.background != background;
}

class _ColumnsPainter extends CustomPainter {
  _ColumnsPainter({
    required this.count,
    required this.width,
    required this.color,
  });

  final int count;
  final double width;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (var i = 1; i < count; i++) {
      final x = i * width;
      for (var y = 0.0; y < size.height; y += 8) {
        canvas.drawLine(Offset(x, y), Offset(x, y + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ColumnsPainter old) =>
      old.count != count || old.color != color;
}

/// Pruh knihy přes období, která vypráví; klepnutí otevře úvod ke knize.
class _BookBar extends StatelessWidget {
  const _BookBar({required this.book, required this.name});

  final int book;
  final String name;

  @override
  Widget build(BuildContext context) {
    final color = _bookColor(book);
    return Material(
      color: color.withValues(alpha: 0.88),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => showBookIntro(context, book),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Jak číst řeku dějin.
class _StoryLegend extends StatelessWidget {
  const _StoryLegend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    Widget row(Widget mark, String text) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(width: 30, child: Center(child: mark)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 12, 4),
      decoration: BoxDecoration(
        color: palette.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          row(
            Container(
              width: 26,
              height: 18,
              decoration: BoxDecoration(
                color: palette.gold,
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            S.storyLegendRiver,
          ),
          row(
            Container(
              width: 30,
              height: 12,
              decoration: BoxDecoration(
                color: _bookColor(9),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            S.storyLegendLanes,
          ),
          row(
            Icon(Icons.library_books_outlined, size: 18, color: palette.muted),
            S.storyLegendBranches,
          ),
        ],
      ),
    );
  }
}

/// Kmen stromu: svislá čára s uzlem období (barvy plynule přecházejí).
class _TrunkPainter extends CustomPainter {
  _TrunkPainter({
    required this.color,
    required this.previous,
    required this.next,
    required this.background,
    required this.label,
  });

  final Color color;
  final Color? previous;
  final Color? next;
  final Color background;
  final String label;

  static const _nodeY = 30.0;

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width / 2;
    final line = Paint()
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    if (previous case final p?) {
      line.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.lerp(p, color, 0.5)!, color],
      ).createShader(Rect.fromLTRB(0, 0, size.width, _nodeY));
      canvas.drawLine(Offset(x, 0), Offset(x, _nodeY), line);
    }
    if (next case final n?) {
      line.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color, Color.lerp(color, n, 0.5)!],
      ).createShader(Rect.fromLTRB(0, _nodeY, size.width, size.height));
      canvas.drawLine(Offset(x, _nodeY), Offset(x, size.height), line);
    }
    canvas.drawCircle(Offset(x, _nodeY), 15, Paint()..color = background);
    canvas.drawCircle(Offset(x, _nodeY), 13, Paint()..color = color);
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, _nodeY - tp.height / 2));
  }

  @override
  bool shouldRepaint(_TrunkPainter old) =>
      old.color != color ||
      old.previous != previous ||
      old.next != next ||
      old.background != background;
}

/// Větev stromu: zahnutá čára a knihy, které k období patří.
class _Branch extends StatelessWidget {
  const _Branch({
    required this.label,
    required this.books,
    required this.color,
  });

  final String label;
  final List<int> books;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 18,
              child: CustomPaint(
                painter: _BranchPainter(color.withValues(alpha: 0.6)),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _BookChips(books: books, small: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BranchPainter extends CustomPainter {
  _BranchPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(4, 0)
      ..lineTo(4, 4)
      ..quadraticBezierTo(4, 10, size.width, 10);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_BranchPainter old) => old.color != color;
}

/// Knihy jako barevné štítky (barva podle oddílu Bible); klepnutí otevře
/// úvod ke knize.
class _BookChips extends ConsumerWidget {
  const _BookChips({required this.books, this.small = false});

  final List<int> books;
  final bool small;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final all = ref.watch(booksProvider);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final b in books)
          Material(
            color: _bookColor(b).withValues(alpha: 0.13),
            shape: StadiumBorder(
              side: BorderSide(color: _bookColor(b).withValues(alpha: 0.35)),
            ),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => showBookIntro(context, b),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: small ? 8 : 10,
                  vertical: small ? 3 : 5,
                ),
                child: Text(
                  small ? all[b - 1].abbreviation : all[b - 1].name,
                  style:
                      (small
                              ? theme.textTheme.labelSmall
                              : theme.textTheme.labelMedium)
                          ?.copyWith(
                            color: _bookColor(b),
                            fontWeight: FontWeight.w700,
                          ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

Future<void> showEra(BuildContext context, StoryEra era) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, controller) => Consumer(
        builder: (context, ref, _) {
          final theme = Theme.of(context);
          final palette = AppPalette.of(context);
          final books = ref.watch(booksProvider);
          final color = _eraColor(era, palette);
          return ListView(
            controller: controller,
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              MediaQuery.paddingOf(context).bottom + 24,
            ),
            children: [
              Text(
                era.period.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(era.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 10),
              Text(
                era.summary,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
              if (era.key.isNotEmpty) ...[
                const SectionLabel(S.storyKey),
                for (final (p, label) in era.key)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _bookColor(p.bookId)
                            .withValues(alpha: 0.15),
                        child: Icon(
                          Icons.menu_book_outlined,
                          color: _bookColor(p.bookId),
                          size: 20,
                        ),
                      ),
                      title: Text(label),
                      subtitle: Text(
                        S.chapterTitle(books[p.bookId - 1].name, p.chapter),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => openReaderAt(context, ref, p.start),
                    ),
                  ),
              ],
              const SectionLabel(S.storyBooks),
              if (era.books.isEmpty && era.branches.isEmpty)
                Text(
                  S.storyNoBooks,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.muted,
                  ),
                )
              else ...[
                _BookChips(books: era.books),
                for (final (label, b) in era.branches)
                  _Branch(label: label, books: b, color: color),
              ],
            ],
          );
        },
      ),
    ),
  );
}

// --- Červené nitě ------------------------------------------------------------

const _threadIcons = {
  'lamb': Icons.pets_outlined,
  'temple': Icons.account_balance_outlined,
  'crown': Icons.workspace_premium_outlined,
  'handshake': Icons.handshake_outlined,
  'waves': Icons.waves,
  'drop': Icons.water_drop_outlined,
  'tree': Icons.park_outlined,
  'globe': Icons.public,
  'shepherd': Icons.nature_people_outlined,
  'serpent': Icons.shield_outlined,
  'spirit': Icons.air,
  'light': Icons.wb_sunny_outlined,
  'bread': Icons.bakery_dining_outlined,
  'mountain': Icons.landscape_outlined,
  'rest': Icons.bedtime_outlined,
  'home': Icons.home_outlined,
  'priest': Icons.local_fire_department_outlined,
  'name': Icons.record_voice_over_outlined,
  'bride': Icons.favorite_border,
  'vine': Icons.wine_bar_outlined,
  'weak': Icons.spa_outlined,
  'rock': Icons.terrain_outlined,
};

class _ThreadsView extends ConsumerWidget {
  const _ThreadsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final threads = ref.watch(threadsProvider).value;
    final data = ref.watch(connectionsProvider).value;
    if (threads == null || data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: _listPadding(context),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
          child: Text(
            S.threadsIntro,
            style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
          ),
        ),
        for (final t in threads) _ThreadCard(thread: t, data: data),
      ],
    );
  }
}

class _ThreadCard extends StatelessWidget {
  const _ThreadCard({required this.thread, required this.data});

  final BibleThread thread;
  final BibleConnections data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final color = Color(thread.color);
    final books = {for (final s in thread.stations) s.passage.bookId};
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => ThreadScreen(thread: thread)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _threadIcons[thread.icon] ?? Icons.timeline,
                      color: color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(thread.title, style: theme.textTheme.titleMedium),
                        Text(
                          S.threadSpan(thread.stations.length, books.length),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: palette.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: palette.muted),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                thread.intro,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.muted,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 54,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: ThreadStripPainter(
                    data: data,
                    points: [
                      for (final s in thread.stations)
                        chapterIndexOf(data, s.passage.start),
                    ],
                    color: color,
                    axis: palette.muted,
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

/// Pruh celé Bible (SZ a NZ) s místy nitě a oblouky mezi nimi.
class ThreadStripPainter extends CustomPainter {
  ThreadStripPainter({
    required this.data,
    required this.points,
    required this.color,
    required this.axis,
    this.labels,
    this.labelStyle,
  });

  final BibleConnections data;

  /// Globální indexy kapitol zastavení v pořadí nitě.
  final List<int> points;
  final Color color;
  final Color axis;

  /// Volitelné popisky pod pruhem (např. zkratky knih).
  final List<String>? labels;
  final TextStyle? labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final n = data.chapterCount;
    final bottom = size.height - (labels == null ? 10 : 26);
    double x(int i) => 4 + (size.width - 8) * (i + 0.5) / n;
    final ntStart = data.chapterStart[39];
    // Pruh: Starý a Nový zákon.
    final band = Paint()..strokeWidth = 5;
    band.color = axis.withValues(alpha: 0.22);
    canvas.drawLine(Offset(x(0), bottom), Offset(x(ntStart - 1), bottom), band);
    band.color = axis.withValues(alpha: 0.4);
    canvas.drawLine(Offset(x(ntStart), bottom), Offset(x(n - 1), bottom), band);
    // Oblouky mezi po sobě jdoucími zastaveními.
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = color.withValues(alpha: 0.75);
    final maxR = bottom - 4;
    for (var i = 1; i < points.length; i++) {
      final a = x(math.min(points[i - 1], points[i]));
      final b = x(math.max(points[i - 1], points[i]));
      final r = (b - a) / 2;
      final h = math.min(r, maxR);
      canvas.drawArc(
        Rect.fromLTRB(a, bottom - h, b, bottom + h),
        math.pi,
        math.pi,
        false,
        arc,
      );
    }
    final dot = Paint()..color = color;
    final ring = Paint()..color = Colors.white;
    for (final p in points) {
      canvas.drawCircle(Offset(x(p), bottom), 4.5, ring);
      canvas.drawCircle(Offset(x(p), bottom), 3.2, dot);
    }
    if (labels case final l?) {
      var lastRight = -100.0;
      for (var i = 0; i < points.length && i < l.length; i++) {
        final tp = TextPainter(
          text: TextSpan(text: l[i], style: labelStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        final left = (x(points[i]) - tp.width / 2).clamp(
          0.0,
          size.width - tp.width,
        );
        // Překrývající se popisky se vynechají.
        if (left < lastRight + 3) continue;
        tp.paint(canvas, Offset(left, bottom + 8));
        lastRight = left + tp.width;
      }
    }
  }

  @override
  bool shouldRepaint(ThreadStripPainter old) =>
      old.points != points || old.color != color || old.axis != axis;
}

/// Detail nitě: pruh přes celou Bibli a zastavení s vysvětlením.
class ThreadScreen extends ConsumerWidget {
  const ThreadScreen({super.key, required this.thread});

  final BibleThread thread;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final color = Color(thread.color);
    final data = ref.watch(connectionsProvider).value;
    final books = ref.watch(booksProvider);
    return Scaffold(
      appBar: AppBar(title: Text(thread.title)),
      body: ReadableWidth(
        child: ListView(
          padding: _listPadding(context),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(palette.heroStart, color, 0.45)!,
                    palette.heroEnd,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _threadIcons[thread.icon] ?? Icons.timeline,
                        color: palette.onHero,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          thread.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: palette.onHero,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    thread.intro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.onHero.withValues(alpha: 0.9),
                      height: 1.45,
                    ),
                  ),
                  if (data != null) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 92,
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: ThreadStripPainter(
                          data: data,
                          points: [
                            for (final s in thread.stations)
                              chapterIndexOf(data, s.passage.start),
                          ],
                          color: palette.onHero,
                          axis: palette.onHero,
                          labels: [
                            for (final s in thread.stations)
                              books[s.passage.bookId - 1].abbreviation,
                          ],
                          labelStyle: theme.textTheme.labelSmall?.copyWith(
                            color: palette.onHero.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            S.oldTestamentShort,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: palette.onHero.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        Text(
                          S.newTestamentShort,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: palette.onHero.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            for (final (i, s) in thread.stations.indexed)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 36,
                      child: CustomPaint(
                        painter: _TrunkPainter(
                          color: color,
                          previous: i == 0 ? null : color,
                          next: i == thread.stations.length - 1 ? null : color,
                          background: theme.scaffoldBackgroundColor,
                          label: '${i + 1}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 18),
                            Text(s.title, style: theme.textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(
                              s.text,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 8),
                            PassageCard(passage: s.passage, accent: color),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- Mapa odkazů (obloukový graf) --------------------------------------------

class _ArcsView extends ConsumerStatefulWidget {
  const _ArcsView({this.initialBook});

  final int? initialBook;

  @override
  ConsumerState<_ArcsView> createState() => _ArcsViewState();
}

class _ArcsViewState extends ConsumerState<_ArcsView>
    with AutomaticKeepAliveClientMixin {
  late int? _book = widget.initialBook;
  int? _expanded;

  /// Knihy obou konců každého oblouku (spočítá se jednou).
  List<(int, int)>? _arcBooks;

  @override
  bool get wantKeepAlive => true;

  void _select(int? book) => setState(() {
    _book = book == _book ? null : book;
    _expanded = null;
  });

  Future<void> _pickBook() async {
    final books = ref.read(booksProvider);
    final picked = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (context, controller) => GridView.count(
          controller: controller,
          crossAxisCount: 5,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 1.5,
          children: [
            for (final b in books)
              Material(
                color: _bookColor(b.id).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => Navigator.pop(context, b.id),
                  child: Center(
                    child: Text(
                      b.abbreviation,
                      style: TextStyle(
                        color: _bookColor(b.id),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    if (picked != null) setState(() => _book = picked);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final data = ref.watch(connectionsProvider).value;
    final books = ref.watch(booksProvider);
    if (data == null) return const Center(child: CircularProgressIndicator());
    final arcBooks = _arcBooks ??= [
      for (final a in data.arcs)
        (data.bookOfChapter(a[0]), data.bookOfChapter(a[1])),
    ];
    final book = _book;
    final rows = book == null
        ? [for (final p in data.pairs.take(10)) (p[0], p[1], p[2])]
        : [for (final (b, w) in data.partnersOf(book).take(10)) (book, b, w)];
    final maxW = rows.isEmpty ? 1 : rows.first.$3;

    return ListView(
      padding: _listPadding(context),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
          child: Text(
            S.arcsIntro,
            style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: const Color(0xFF17130F),
          ),
          padding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth;
                  final h = w / 2 + 34;
                  return GestureDetector(
                    onTapUp: (d) {
                      final i =
                          ((d.localPosition.dx - 4) /
                                  (w - 8) *
                                  data.chapterCount)
                              .floor()
                              .clamp(0, data.chapterCount - 1);
                      _select(data.bookOfChapter(i));
                    },
                    child: RepaintBoundary(
                      child: CustomPaint(
                        size: Size(w, h),
                        painter: ArcDiagramPainter(
                          data: data,
                          arcBooks: arcBooks,
                          selected: book,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      book == null ? '' : books[book - 1].name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: book == null ? null : _bookColor(book),
                      ),
                    ),
                  ),
                  if (book != null)
                    IconButton(
                      tooltip: S.close,
                      onPressed: () => _select(null),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  TextButton.icon(
                    onPressed: _pickBook,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFE8C77E),
                    ),
                    icon: const Icon(Icons.menu_book_outlined, size: 18),
                    label: const Text(S.arcsChooseBook),
                  ),
                ],
              ),
            ],
          ),
        ),
        SectionLabel(
          book == null ? S.arcsTop : S.arcsPartners(books[book - 1].name),
        ),
        for (final (i, (a, b, w)) in rows.indexed)
          _PairTile(
            a: a,
            b: b,
            fraction: w / maxW,
            showBoth: book == null,
            expanded: _expanded == i,
            onTap: () => setState(() => _expanded = _expanded == i ? null : i),
            examples: data.examplesFor(a, b),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
          child: Text(
            S.arcsCredit,
            style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
        ),
      ],
    );
  }
}

/// Obloukový graf: všechny kapitoly Bible jako sloupky a nad nimi oblouky
/// spojení. Vybraná kniha se rozsvítí, ostatní oblouky ztlumí.
class ArcDiagramPainter extends CustomPainter {
  ArcDiagramPainter({
    required this.data,
    required this.arcBooks,
    required this.selected,
  });

  final BibleConnections data;
  final List<(int, int)> arcBooks;
  final int? selected;

  @override
  void paint(Canvas canvas, Size size) {
    final n = data.chapterCount;
    final axisY = size.height - 26;
    double x(int i) => 4 + (size.width - 8) * (i + 0.5) / n;
    final maxW = data.arcs.isEmpty ? 1.0 : data.arcs.last[2].toDouble();
    final logMax = math.log(maxW + 1);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..blendMode = BlendMode.plus;
    void drawArc(List<int> a, Color color, double alpha, double width) {
      final x1 = x(a[0]), x2 = x(a[1]);
      final r = (x2 - x1) / 2;
      paint
        ..color = color.withValues(alpha: alpha)
        ..strokeWidth = width;
      canvas.drawArc(
        Rect.fromLTRB(x1, axisY - r, x2, axisY + r),
        math.pi,
        math.pi,
        false,
        paint,
      );
    }

    final sel = selected;
    for (var i = 0; i < data.arcs.length; i++) {
      final a = data.arcs[i];
      final (b1, b2) = arcBooks[i];
      final strength = math.log(a[2] + 1) / logMax;
      if (sel != null && (b1 == sel || b2 == sel)) continue;
      drawArc(
        a,
        _bookColor(b1),
        (sel == null ? 0.05 + 0.32 * strength : 0.012 + 0.025 * strength),
        0.8,
      );
    }
    if (sel != null) {
      for (var i = 0; i < data.arcs.length; i++) {
        final (b1, b2) = arcBooks[i];
        if (b1 != sel && b2 != sel) continue;
        final a = data.arcs[i];
        final strength = math.log(a[2] + 1) / logMax;
        drawArc(a, _bookColor(b1 == sel ? b2 : b1), 0.35 + 0.6 * strength, 1.1);
      }
    }

    // Sloupky kapitol (výška podle počtu veršů).
    final bar = Paint()..strokeWidth = math.max((size.width - 8) / n, 0.6);
    var i = 0;
    for (var b = 0; b < data.verses.length; b++) {
      final dim = sel != null && sel != b + 1;
      bar.color = _bookColor(b + 1).withValues(alpha: dim ? 0.35 : 0.95);
      for (final v in data.verses[b]) {
        final h = 2 + 9 * math.sqrt(v / 176);
        canvas.drawLine(Offset(x(i), axisY), Offset(x(i), axisY + h), bar);
        i++;
      }
    }

    // Popisky zákonů a vybrané knihy.
    final nt = data.chapterStart[39];
    void label(String text, double center, Color color) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(color: color, fontSize: 10, letterSpacing: 0.8),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          (center - tp.width / 2).clamp(0, size.width - tp.width),
          axisY + 13,
        ),
      );
    }

    label(
      S.oldTestamentShort.toUpperCase(),
      (x(0) + x(nt - 1)) / 2,
      Colors.white54,
    );
    label(
      S.newTestamentShort.toUpperCase(),
      (x(nt) + x(n - 1)) / 2,
      Colors.white54,
    );
    if (sel != null) {
      final from = data.chapterStart[sel - 1];
      final to = from + data.verses[sel - 1].length - 1;
      canvas.drawRect(
        Rect.fromLTRB(x(from) - 1.5, axisY - 2, x(to) + 1.5, axisY + 12),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(ArcDiagramPainter old) =>
      old.selected != selected || old.data != data;
}

/// Dvojice knih s pruhem síly spojení; po rozbalení příklady veršů.
class _PairTile extends ConsumerWidget {
  const _PairTile({
    required this.a,
    required this.b,
    required this.fraction,
    required this.showBoth,
    required this.expanded,
    required this.onTap,
    required this.examples,
  });

  final int a;
  final int b;
  final double fraction;
  final bool showBoth;
  final bool expanded;
  final VoidCallback onTap;
  final List<List<int>> examples;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final books = ref.watch(booksProvider);
    final title = showBoth
        ? '${books[a - 1].name} ↔ ${books[b - 1].name}'
        : books[b - 1].name;
    final color = _bookColor(b);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleSmall),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: palette.muted,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: fraction,
                  minHeight: 6,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.12),
                ),
              ),
              if (expanded) ...[
                const SizedBox(height: 12),
                Text(
                  S.arcsExamples.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.muted,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                for (final e in examples) _ExamplePair(example: e),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Dvojice veršů, které na sebe odkazují (v anglickém číslování zdroje).
class _ExamplePair extends StatelessWidget {
  const _ExamplePair({required this.example});

  final List<int> example;

  Passage _passage(int book, int chapter, int verse, int end) {
    VerseRef canon(int v) => Versification.convert(
      VerseRef(book, chapter, v),
      VerseScheme.english,
      VerseScheme.hebrew,
    );
    final s = canon(verse), e = canon(end);
    return Passage(s.bookId, s.chapter, s.verse, e.verse, e.chapter);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final e = example;
    final left = _passage(e[0], e[1], e[2], e[2]);
    final right = _passage(e[3], e[4], e[5], e[6]);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        children: [
          PassageCard(passage: left, accent: _bookColor(left.bookId)),
          Icon(Icons.swap_vert, color: palette.muted, size: 20),
          const SizedBox(height: 4),
          PassageCard(passage: right, accent: _bookColor(right.bookId)),
        ],
      ),
    );
  }
}

/// Velká karta ve Studiu: náhled obloukového grafu a vstup do tří pohledů.
class ConnectionsHeroCard extends ConsumerWidget {
  const ConnectionsHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final data = ref.watch(connectionsProvider).value;
    const ink = Color(0xFFF3E6CC);
    return Material(
      color: const Color(0xFF17130F),
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openConnections(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data != null)
                LayoutBuilder(
                  builder: (context, c) => RepaintBoundary(
                    child: CustomPaint(
                      size: Size(c.maxWidth, c.maxWidth / 2 + 34),
                      painter: ArcDiagramPainter(
                        data: data,
                        arcBooks: [
                          for (final a in data.arcs)
                            (
                              data.bookOfChapter(a[0]),
                              data.bookOfChapter(a[1]),
                            ),
                        ],
                        selected: null,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                S.connections,
                style: theme.textTheme.titleLarge?.copyWith(color: ink),
              ),
              const SizedBox(height: 4),
              Text(
                S.connectionsHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ink.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (view, label, icon) in [
                    (ConnectionsView.tree, S.tabTree, Icons.hub_outlined),
                    (ConnectionsView.story, S.tabStory, Icons.account_tree),
                    (ConnectionsView.threads, S.tabThreads, Icons.timeline),
                    (ConnectionsView.arcs, S.tabArcs, Icons.blur_on),
                  ])
                    Material(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: StadiumBorder(
                        side: BorderSide(color: ink.withValues(alpha: 0.3)),
                      ),
                      child: InkWell(
                        customBorder: const StadiumBorder(),
                        onTap: () => openConnections(context, view: view),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 7, 14, 7),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(icon, size: 18, color: ink),
                              const SizedBox(width: 6),
                              Text(
                                label,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
