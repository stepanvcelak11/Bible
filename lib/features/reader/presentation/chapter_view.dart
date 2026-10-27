import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/application/reader_settings_controller.dart';
import '../../translations/application/translation_controller.dart';
import '../application/chapter_content_provider.dart';
import '../application/reader_state.dart';
import '../application/reading_position_controller.dart';
import 'reader_screen.dart' show readerBarHeight;
import 'verse_tile.dart';

/// Jedna stránka čtečky = jedna kapitola.
///
/// Používá ScrollablePositionedList, který umí skočit přímo na verš
/// (i daleko od začátku, bez měření výšek) a hlásí, který verš je nahoře –
/// ten se ukládá jako pozice čtení.
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
  Timer? _saveTimer;
  List<int> _verseNumbers = const [];

  @override
  void initState() {
    super.initState();
    _positions.itemPositions.addListener(_onPositionsChanged);
  }

  @override
  void dispose() {
    _positions.itemPositions.removeListener(_onPositionsChanged);
    _saveTimer?.cancel();
    super.dispose();
  }

  bool get _isCurrent {
    final p = ref.read(readingPositionProvider);
    return p.bookId == widget.bookId && p.chapter == widget.chapter;
  }

  /// Uloží verš nahoře na obrazovce (s prodlevou – ne při každém snímku).
  void _onPositionsChanged() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 400), () {
      if (!mounted || !_isCurrent || _verseNumbers.isEmpty) return;
      final visible = _positions.itemPositions.value
          .where((p) => p.itemTrailingEdge > 0.12 && p.index > 0)
          .map((p) => p.index);
      if (visible.isEmpty) return;
      final index = visible.reduce((a, b) => a < b ? a : b) - 1;
      if (index < _verseNumbers.length) {
        ref
            .read(readingPositionProvider.notifier)
            .updateVisibleVerse(_verseNumbers[index]);
      }
    });
  }

  /// Index položky seznamu pro verš (0 = záhlaví kapitoly).
  int _itemIndexFor(int verse) {
    final i = _verseNumbers.indexWhere((n) => n >= verse);
    return i < 0 ? 0 : i + 1;
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

    // Skok na verš v této (už zobrazené) kapitole.
    ref.listen(jumpRequestProvider, (_, request) {
      if (request == null ||
          request.ref.bookId != widget.bookId ||
          request.ref.chapter != widget.chapter) {
        return;
      }
      ref.read(jumpRequestProvider.notifier).done(request.id);
      if (_scroll.isAttached && _verseNumbers.isNotEmpty) {
        _scroll.scrollTo(
          index: _itemIndexFor(request.ref.verse),
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

    _verseNumbers = content.verseNumbers;
    final position = ref.read(readingPositionProvider);
    final startAtVerse = _isCurrent && position.verse > 1;
    final settings = ref.watch(readerSettingsProvider);
    final insets = MediaQuery.paddingOf(context);
    final parallel = content is ParallelChapter;

    return NotificationListener<UserScrollNotification>(
      onNotification: _onScroll,
      child: ScrollablePositionedList.builder(
        itemScrollController: _scroll,
        itemPositionsListener: _positions,
        initialScrollIndex: startAtVerse ? _itemIndexFor(position.verse) : 0,
        initialAlignment: startAtVerse ? 0.12 : 0,
        padding: EdgeInsets.only(
          top: insets.top + readerBarHeight + 8,
          bottom: insets.bottom + 160,
          left: parallel ? 12 : settings.horizontalMargin,
          right: parallel ? 12 : settings.horizontalMargin,
        ),
        itemCount: content.verseNumbers.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return _ChapterHeader(
              bookId: widget.bookId,
              chapter: widget.chapter,
            );
          }
          return switch (content) {
            SingleChapter(:final verses) => VerseTile(verse: verses[i - 1]),
            ParallelChapter(:final rows) => ParallelVerseTile(row: rows[i - 1]),
          };
        },
      ),
    );
  }
}

/// Záhlaví kapitoly: název knihy a velké číslo kapitoly.
class _ChapterHeader extends ConsumerWidget {
  const _ChapterHeader({required this.bookId, required this.chapter});

  final int bookId;
  final int chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookByIdProvider(bookId));
    final colors = ReaderColors.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 20, 6, 20),
      child: Column(
        children: [
          Text(
            book.name.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              letterSpacing: 2.4,
              color: colors.verseNumber,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$chapter',
            style: theme.textTheme.displayMedium?.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
