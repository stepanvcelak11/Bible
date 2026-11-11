import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/widgets/app_sheet.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../content/presentation/people_screen.dart';
import '../application/inline_notes.dart';
import 'inline_note_view.dart';
import '../../content/presentation/notes_screen.dart';
import '../../content/application/content_providers.dart';
import '../../../domain/services/versification.dart';
import '../../../domain/entities/content_entities.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/widgets/readable_width.dart';
import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/services/bible_content.dart';
import '../../illustrations/application/illustrations.dart';
import '../../illustrations/presentation/illustration_view.dart';
import '../../maps/presentation/maps_screen.dart';
import '../../settings/application/reader_settings_controller.dart';
import '../../study/application/study_providers.dart';
import '../../study/presentation/book_intro_sheet.dart';
import '../../today/application/today_providers.dart';
import '../../translations/application/translation_controller.dart';
import '../application/chapter_content_provider.dart';
import '../application/reader_blocks.dart';
import '../application/reader_state.dart';
import '../application/reading_position_controller.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/timeline.dart';
import '../../today/presentation/timeline_screen.dart';
import '../../content/presentation/family_tree_screen.dart';
import '../../content/presentation/harmony_screen.dart';
import 'paragraph_view.dart';
import 'reflection_sheet.dart';
import 'reader_screen.dart' show readerTopBarHeight;
import 'verse_tile.dart';

/// Jedna stránka čtečky = jedna kapitola.
///
/// Používá ScrollablePositionedList, který umí skočit přímo na verš
/// (i daleko od začátku, bez měření výšek) a hlásí, který blok je nahoře –
/// jeho první verš se ukládá jako pozice čtení.
class ChapterView extends ConsumerStatefulWidget {
  const ChapterView({super.key, required this.bookId, required this.chapter});

  final int bookId;
  final int chapter;

  @override
  ConsumerState<ChapterView> createState() => _ChapterViewState();
}

class _ChapterViewState extends ConsumerState<ChapterView> {
  final _scroll = ItemScrollController();
  final _positions = ItemPositionsListener.create();
  final _progress = ValueNotifier<double>(0);
  Timer? _saveTimer;
  Timer? _readTimer;
  bool _logged = false;

  /// Čísla veršů jednotlivých položek seznamu (0 = záhlaví).
  List<List<int>> _itemVerses = const [];

  @override
  void initState() {
    super.initState();
    _positions.itemPositions.addListener(_onPositionsChanged);
  }

  @override
  void dispose() {
    _positions.itemPositions.removeListener(_onPositionsChanged);
    _saveTimer?.cancel();
    _readTimer?.cancel();
    _progress.dispose();
    super.dispose();
  }

  bool get _isCurrent {
    final p = ref.read(readingPositionProvider);
    return p.bookId == widget.bookId && p.chapter == widget.chapter;
  }

  /// Kapitola se počítá jako přečtená po 20 s čtení, nebo když čtenář
  /// dojde na konec (a strávil na ní aspoň pár sekund).
  void _scheduleReadLog() {
    if (_logged || _readTimer != null) return;
    _readTimer = Timer(const Duration(seconds: 20), _logRead);
  }

  void _logRead() {
    if (_logged || !mounted || !_isCurrent) return;
    _logged = true;
    ref
        .read(readingProgressRepositoryProvider)
        .logChapter(
          widget.bookId,
          widget.chapter,
          translationId: ref.read(translationControllerProvider).primaryId,
        );
  }

  void _onPositionsChanged() {
    final positions = _positions.itemPositions.value;
    if (positions.isEmpty || _itemVerses.isEmpty) return;
    final last = positions.map((p) => p.index).reduce((a, b) => a > b ? a : b);
    _progress.value = (last + 1) / _itemVerses.length;
    if (last == _itemVerses.length - 1 && _readTimer != null) {
      _readTimer?.cancel();
      _readTimer = Timer(const Duration(seconds: 4), _logRead);
    }

    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 400), () {
      if (!mounted || !_isCurrent) return;
      final visible = _positions.itemPositions.value
          .where((p) => p.itemTrailingEdge > 0.12 && p.index > 0)
          .map((p) => p.index);
      if (visible.isEmpty) return;
      final first = visible.reduce((a, b) => a < b ? a : b);
      for (var i = first; i < _itemVerses.length; i++) {
        if (_itemVerses[i].isNotEmpty) {
          ref
              .read(readingPositionProvider.notifier)
              .updateVisibleVerse(_itemVerses[i].first);
          break;
        }
      }
    });
  }

  /// Index položky seznamu, která obsahuje verš.
  int _itemIndexFor(int verse) {
    for (var i = 1; i < _itemVerses.length; i++) {
      final vs = _itemVerses[i];
      if (vs.isNotEmpty && vs.last >= verse) {
        // Nadpis těsně před veršem ukázat také.
        return i > 1 && _itemVerses[i - 1].isEmpty && vs.first == verse
            ? i - 1
            : i;
      }
    }
    return 0;
  }

  bool _onScroll(UserScrollNotification n) {
    final controls = ref.read(controlsVisibleProvider.notifier);
    if (n.direction == ScrollDirection.reverse) controls.hide();
    if (n.direction == ScrollDirection.forward) controls.show();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final selection = ref.watch(translationControllerProvider);
    final key = (
      primaryId: selection.primaryId,
      secondaryId: selection.secondaryId,
      bookId: widget.bookId,
      chapter: widget.chapter,
    );
    final content = ref.watch(chapterPageProvider(key)).value;
    final settings = ref.watch(readerSettingsProvider);

    // Aktuální stránka → začít počítat čtení.
    ref.listen(readingPositionProvider.select((p) => (p.bookId, p.chapter)), (
      _,
      next,
    ) {
      if (next == (widget.bookId, widget.chapter)) _scheduleReadLog();
    });
    if (_isCurrent) _scheduleReadLog();

    // Skok na verš v této (už zobrazené) kapitole.
    ref.listen(jumpRequestProvider, (_, request) {
      if (request == null ||
          request.ref.bookId != widget.bookId ||
          request.ref.chapter != widget.chapter) {
        return;
      }
      ref.read(jumpRequestProvider.notifier).done(request.id);
      if (_scroll.isAttached && _itemVerses.isNotEmpty) {
        final index = _itemIndexFor(request.ref.verse);
        if (request.ifNeeded) {
          // Položka (verš nebo odstavec) je na obrazovce dost vidět – dlouhý
          // odstavec se nesmí vracet na začátek s každým veršem.
          final visible = _positions.itemPositions.value.any(
            (p) =>
                p.index == index &&
                p.itemTrailingEdge > 0.3 &&
                p.itemLeadingEdge < 0.72,
          );
          if (visible) return;
        }
        _scroll.scrollTo(
          index: index,
          alignment: 0.12,
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeOutCubic,
        );
      }
    });

    if (content == null) return const SizedBox.expand();
    if (content.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(S.chapterMissing, textAlign: TextAlign.center),
        ),
      );
    }

    // Délka kapitoly pro záhlaví (~180 slov za minutu).
    final verses = switch (content) {
      SingleChapter(:final text) => text.verses,
      ParallelChapter(:final rows) => [
        for (final r in rows)
          if (r.primary != null) r.primary!,
      ],
    };
    final words = verses.fold<int>(
      0,
      (n, v) => n + v.text.split(RegExp(r'\s+')).length,
    );
    final minutes = (words / 180).ceil().clamp(1, 99);

    // Kresby k příběhům: před blok s veršem (a před jeho nadpis).
    final art = settings.illustrations
        ? ref.watch(
            chapterIllustrationsProvider((
              selection.primaryId,
              widget.bookId,
              widget.chapter,
            )),
          )
        : const <int, List<Illustration>>{};
    final pending = art.keys.toList()..sort();
    // Popisek kresby = text verše ve zvoleném překladu.
    final verseText = {
      for (final v in verses) v.ref.verse: v.text.replaceAll('\n', ' '),
    };
    Iterable<Widget Function()> artBefore(int lastVerse) sync* {
      while (pending.isNotEmpty && pending.first <= lastVerse) {
        final v = pending.removeAt(0);
        for (final il in art[v]!) {
          yield () => IllustrationView(
            illustration: il,
            caption: verseText[v] ?? il.caption,
            reference: '${widget.chapter},$v',
            fontSize: settings.fontSize,
          );
        }
      }
    }

    final items = <Widget Function()>[];
    final itemVerses = <List<int>>[const []];
    void insertArt(int lastVerse, {int headings = 0}) {
      final at = items.length - headings;
      final add = artBefore(lastVerse).toList();
      items.insertAll(at, add);
      itemVerses.insertAll(at + 1, [for (final _ in add) const <int>[]]);
    }

    // Krátké poznámky: za blok (odstavec, verš), který obsahuje jejich verš.
    final noteMap = settings.inlineNotes
        ? ref.watch(
            chapterInlineNotesProvider((
              selection.primaryId,
              widget.bookId,
              widget.chapter,
            )),
          )
        : const <int, List<InlineNote>>{};
    // Poznámky a slovníček: malá značka za veršem, text v panelu.
    final extras = settings.inlineNotes
        ? buildVerseExtras(noteMap, [
            for (final v in verses) (v.ref.verse, v.text),
          ], widget.bookId)
        : const <int, VerseExtras>{};
    switch (content) {
      case SingleChapter(:final text):
        final blocks = buildReaderBlocks(
          text,
          paragraphs: settings.paragraphMode,
        );
        var headings = 0;
        for (final b in blocks) {
          switch (b) {
            case HeadingBlock(:final text):
              items.add(() => HeadingView(text: text));
              itemVerses.add(const []);
              headings++;
            case ParagraphBlock():
              insertArt(b.verseNumbers.last, headings: headings);
              headings = 0;
              items.add(
                () => ParagraphView(
                  block: b,
                  bookId: widget.bookId,
                  chapter: widget.chapter,
                  footnotes: text.footnotes,
                ),
              );
              itemVerses.add(b.verseNumbers);
          }
        }
      case ParallelChapter(:final rows):
        for (final r in rows) {
          insertArt(r.number);
          items.add(() => ParallelVerseTile(row: r));
          itemVerses.add([r.number]);
        }
    }
    _itemVerses = [...itemVerses, const []];

    final position = ref.read(readingPositionProvider);
    final startAtVerse = _isCurrent && position.verse > 1;
    final insets = MediaQuery.paddingOf(context);
    final parallel = content is ParallelChapter;
    final palette = AppPalette.of(context);
    // Na tabletu text ve sloupci příjemné šířky (cca 70 znaků na řádek),
    // porovnání překladů smí být širší.
    final width = MediaQuery.sizeOf(context).width;
    final maxText = parallel ? 1100.0 : settings.fontSize * 38;
    final margin = parallel ? 12.0 : settings.horizontalMargin;
    final side = width - 2 * margin > maxText ? (width - maxText) / 2 : margin;

    return VerseExtrasScope(
      extras: extras,
      bookId: widget.bookId,
      chapter: widget.chapter,
      bookName: ref.watch(bookByIdProvider(widget.bookId)).name,
      child: Stack(
        children: [
          NotificationListener<UserScrollNotification>(
            onNotification: _onScroll,
            child: ScrollablePositionedList.builder(
              itemScrollController: _scroll,
              itemPositionsListener: _positions,
              initialScrollIndex: startAtVerse
                  ? _itemIndexFor(position.verse)
                  : 0,
              initialAlignment: startAtVerse ? 0.12 : 0,
              padding: EdgeInsets.only(
                top: insets.top + readerTopBarHeight(ref) + 8,
                bottom: insets.bottom + 180,
                left: side,
                right: side,
              ),
              itemCount: items.length + 2,
              itemBuilder: (context, i) => i == 0
                  ? _ChapterHeader(
                      bookId: widget.bookId,
                      chapter: widget.chapter,
                      verseCount: verses.length,
                      minutes: minutes,
                    )
                  : i > items.length
                  ? ChapterFooter(
                      bookId: widget.bookId,
                      chapter: widget.chapter,
                      onNext: () => ref
                          .read(readingPositionProvider.notifier)
                          .nextChapter(),
                    )
                  : items[i - 1](),
            ),
          ),
          // Tenký ukazatel, kolik z kapitoly je přečteno.
          // Se skrytou lištou se posune nahoru (jinak by visel přes text).
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            top:
                insets.top +
                (ref.watch(controlsVisibleProvider)
                    ? readerTopBarHeight(ref)
                    : 0),
            left: 0,
            right: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _progress,
              builder: (context, value, _) => Align(
                alignment: Alignment.centerLeft,
                child: AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 200),
                  widthFactor: value.clamp(0, 1),
                  child: Container(
                    height: 2,
                    color: palette.gold.withValues(alpha: 0.7),
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

/// Záhlaví kapitoly: název knihy, velké číslo kapitoly, úvod ke knize a
/// místa zmíněná v kapitole.
class _ChapterHeader extends ConsumerWidget {
  const _ChapterHeader({
    required this.bookId,
    required this.chapter,
    required this.verseCount,
    required this.minutes,
  });

  final int bookId;
  final int chapter;
  final int verseCount;
  final int minutes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookByIdProvider(bookId));
    final colors = ReaderColors.of(context);
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final category = categoryOf(bookId);
    final read = ref.watch(
      readChaptersProvider.select(
        (m) => m.value?[bookId]?.contains(chapter) ?? false,
      ),
    );
    final translationId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final places = ref.watch(
      mapDataProvider.select(
        (d) =>
            d.value?.places
                .where(
                  (p) => p.mentionedInChapterOf(bookId, chapter, translationId),
                )
                .toList() ??
            const [],
      ),
    );

    final canonicalRef = Versification.toCanonical(
      VerseRef(bookId, chapter, 1),
      translationId,
    );
    // Studijní obsah ke kapitole (uložený v kanonickém číslování).
    final canonical = Versification.chaptersSpanned(
      bookId,
      chapter,
      176,
      schemeOf(translationId),
      VerseScheme.hebrew,
    );
    bool covers(Passage p) =>
        p.bookId == bookId &&
        canonical.any((c) => c >= p.chapter && c <= p.endChapter);
    final notes = [
      for (final n in ref.watch(notesProvider).value ?? const <AppNote>[])
        if (covers(n.passage)) n,
    ];
    // Události, které vyprávějí i jiná evangelia.
    final parallels = canonicalRef.bookId < 40 || canonicalRef.bookId > 43
        ? const <HarmonyEvent>[]
        : [
            for (final per
                in ref.watch(harmonyProvider).value ?? const <HarmonyPeriod>[])
              for (final e in per.events)
                if (e.refs.whereType<Passage>().length > 1 &&
                    e.refs.any(
                      (p) =>
                          p != null &&
                          p.bookId == canonicalRef.bookId &&
                          canonicalRef.chapter >= p.chapter &&
                          canonicalRef.chapter <= p.endChapter,
                    ))
                  e,
          ];
    final people = [
      for (final p in ref.watch(peopleProvider).value ?? const <BiblePerson>[])
        if (p.story.any(covers) || covers(p.key)) p,
    ];

    if (isCompactHeight(context)) {
      // Malý panel: jen skromný řádek místo velkého záhlaví.
      return Padding(
        padding: const EdgeInsets.fromLTRB(6, 10, 6, 8),
        child: Text(
          '${book.name.toUpperCase()} $chapter  ·  '
          '${S.chapterLength(verseCount, minutes)}',
          textAlign: TextAlign.center,
          style: theme.textTheme.labelMedium?.copyWith(
            letterSpacing: 1.2,
            color: colors.verseNumber,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 28, 6, 18),
      child: Column(
        children: [
          Text(
            book.name.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              letterSpacing: 3,
              color: colors.verseNumber,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          _ReadGlow(
            read: read,
            color: palette.gold,
            child: Text(
              '$chapter',
              style: theme.textTheme.displayLarge?.copyWith(
                color: colors.text,
                fontWeight: FontWeight.w300,
                height: 1.1,
              ),
            ),
          ),
          Container(
            width: 36,
            height: 3,
            margin: const EdgeInsets.only(top: 6, bottom: 4),
            decoration: BoxDecoration(
              color: Color(category.color).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              text: S.chapterLength(verseCount, minutes),
              children: [
                if (read) ...[
                  const TextSpan(text: '  ·  '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.check_circle,
                      size: 14,
                      color: palette.gold,
                    ),
                  ),
                  TextSpan(
                    text: ' ${S.chapterAlreadyRead}',
                    style: TextStyle(
                      color: palette.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
          if (timelinePlaceOf(canonicalRef.bookId, canonicalRef.chapter)
              case final place?)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TimelineStrip(place: place),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              if (chapter == 1)
                ActionChip(
                  avatar: Icon(
                    Icons.auto_stories,
                    size: 18,
                    color: palette.gold,
                  ),
                  label: const Text(S.bookIntro),
                  onPressed: () => showBookIntro(context, bookId),
                ),
              if (places.isNotEmpty)
                ActionChip(
                  avatar: Icon(
                    Icons.place_outlined,
                    size: 18,
                    color: palette.gold,
                  ),
                  label: Text(S.placesInChapter(places.length)),
                  onPressed: () => openChapterMap(context, bookId, chapter),
                ),
              for (final n in notes)
                ActionChip(
                  avatar: Icon(
                    Icons.sticky_note_2_outlined,
                    size: 18,
                    color: palette.gold,
                  ),
                  label: Text(n.title),
                  onPressed: () => showNoteSheet(context, n),
                ),
              if (familyChapters.contains((
                canonicalRef.bookId,
                canonicalRef.chapter,
              )))
                ActionChip(
                  avatar: Icon(
                    Icons.account_tree_outlined,
                    size: 18,
                    color: palette.gold,
                  ),
                  label: const Text(S.familyTree),
                  onPressed: () => openFamilyTree(context),
                ),
              if (parallels.isNotEmpty)
                ActionChip(
                  avatar: Icon(
                    Icons.view_column_outlined,
                    size: 18,
                    color: palette.gold,
                  ),
                  label: const Text(S.parallelOpen),
                  onPressed: () => _openParallels(context, parallels),
                ),
              for (final p in people.take(4))
                ActionChip(
                  avatar: Icon(
                    Icons.person_outline,
                    size: 18,
                    color: palette.gold,
                  ),
                  label: Text(p.name),
                  onPressed: () => openPerson(context, p),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Když se kapitola během čtení započítá jako přečtená, číslo kapitoly
/// jednou jemně zazáří (bez konfet – jen světlo).
class _ReadGlow extends StatefulWidget {
  const _ReadGlow({
    required this.read,
    required this.color,
    required this.child,
  });

  final bool read;
  final Color color;
  final Widget child;

  @override
  State<_ReadGlow> createState() => _ReadGlowState();
}

class _ReadGlowState extends State<_ReadGlow>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didUpdateWidget(_ReadGlow old) {
    super.didUpdateWidget(old);
    if (widget.read && !old.read && !MediaQuery.disableAnimationsOf(context)) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    child: widget.child,
    builder: (context, child) {
      if (!_c.isAnimating) return child!;
      // Rychle se rozsvítí, pomalu dohasne.
      final t = _c.value;
      final k = t < 0.2 ? t / 0.2 : 1 - (t - 0.2) / 0.8;
      return Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 80 + 60 * t,
            height: 80 + 60 * t,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.color.withValues(alpha: 0.45 * k),
                  widget.color.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          child!,
        ],
      );
    },
  );
}

/// Kde v dějinách se kapitola odehrává: pruh období s tečkou a datum
/// s událostí. Klepnutím časová osa na tomto místě.
class TimelineStrip extends StatelessWidget {
  const TimelineStrip({super.key, required this.place});

  final TimelinePlace place;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final color = Color(place.event.era.color);
    final note = place.span.note;
    return Semantics(
      button: true,
      label: '${S.timeline}: ${place.event.date}, ${place.event.title}',
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => openTimeline(context, focus: place.index, note: note),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: ExcludeSemantics(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 12,
                  child: CustomPaint(
                    size: const Size(double.infinity, 12),
                    painter: _EraStripPainter(
                      position: place.position,
                      dot: color,
                      ring: palette.card,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history_edu, size: 15, color: color),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: place.event.date,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: '  ·  ${place.event.title}'),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
                if (note != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      note,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: palette.muted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Barevné úseky období (šířka podle počtu událostí) a tečka „tady“.
class _EraStripPainter extends CustomPainter {
  _EraStripPainter({
    required this.position,
    required this.dot,
    required this.ring,
  });

  final double position;
  final Color dot;
  final Color ring;

  @override
  void paint(Canvas canvas, Size size) {
    final total = timelineEvents.length;
    final y = size.height / 2;
    var x = 0.0;
    for (final era in TimelineEra.values) {
      final n = timelineEvents.where((e) => e.era == era).length;
      final w = size.width * n / total;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 1, y - 2, w - 2, 4),
          const Radius.circular(2),
        ),
        Paint()..color = Color(era.color).withValues(alpha: 0.55),
      );
      x += w;
    }
    // Střed události v jejím „slotu“.
    final cx = size.width * (position * (total - 1) + 0.5) / total;
    canvas.drawCircle(Offset(cx, y), 6, Paint()..color = ring);
    canvas.drawCircle(Offset(cx, y), 4.5, Paint()..color = dot);
  }

  @override
  bool shouldRepaint(_EraStripPainter old) =>
      old.position != position || old.dot != dot || old.ring != ring;
}

void _openParallels(BuildContext context, List<HarmonyEvent> events) {
  void open(HarmonyEvent e) => Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => GospelParallelScreen(event: e)),
  );
  if (events.length == 1) return open(events.single);
  showAppSheet<void>(
    context: context,
    builder: (sheet) => ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: Text(
            S.parallelOpen,
            style: Theme.of(sheet).textTheme.titleLarge,
          ),
        ),
        for (final e in events)
          ListTile(
            leading: const Icon(Icons.view_column_outlined),
            title: Text(e.title),
            onTap: () {
              Navigator.of(sheet).pop();
              open(e);
            },
          ),
      ],
    ),
  );
}
