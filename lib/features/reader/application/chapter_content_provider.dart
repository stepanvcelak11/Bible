import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../translations/application/translation_controller.dart';
import 'reading_position_controller.dart';

/// Obsah kapitoly pro čtečku – buď jeden překlad, nebo dva vedle sebe.
sealed class ChapterContent {
  const ChapterContent(this.bookId, this.chapter);

  final int bookId;
  final int chapter;

  bool get isEmpty;

  /// Verše hlavního překladu (pro kopírování, sdílení, výběr).
  List<Verse> get primaryVerses;

  /// Čísla veršů v pořadí zobrazení.
  List<int> get verseNumbers;
}

final class SingleChapter extends ChapterContent {
  const SingleChapter(super.bookId, super.chapter, this.verses);

  final List<Verse> verses;

  @override
  bool get isEmpty => verses.isEmpty;

  @override
  List<Verse> get primaryVerses => verses;

  @override
  List<int> get verseNumbers => [for (final v in verses) v.number];
}

final class ParallelChapter extends ChapterContent {
  const ParallelChapter(super.bookId, super.chapter, this.rows);

  final List<ParallelVerse> rows;

  @override
  bool get isEmpty => rows.isEmpty;

  @override
  List<Verse> get primaryVerses => [
    for (final r in rows)
      if (r.primary != null) r.primary!,
  ];

  @override
  List<int> get verseNumbers => [for (final r in rows) r.number];
}

/// Klíč stránky čtečky: překlad(y) + kapitola.
typedef ChapterKey = ({
  String primaryId,
  String? secondaryId,
  int bookId,
  int chapter,
});

/// Obsah jedné kapitoly. Stránky čtečky (PageView) ho čtou každá pro svou
/// kapitolu; sousední stránky se díky `allowImplicitScrolling` načtou
/// dopředu, takže přejetí na další kapitolu je okamžité.
final chapterPageProvider = FutureProvider.autoDispose
    .family<ChapterContent, ChapterKey>((ref, key) async {
      final repo = ref.watch(bibleRepositoryProvider);
      final secondary = key.secondaryId;
      if (secondary == null) {
        return SingleChapter(
          key.bookId,
          key.chapter,
          await repo.getChapter(key.primaryId, key.bookId, key.chapter),
        );
      }
      return ParallelChapter(
        key.bookId,
        key.chapter,
        await repo.getParallelChapter(
          key.primaryId,
          secondary,
          key.bookId,
          key.chapter,
        ),
      );
    });

/// Kapitola podle aktuálního výběru překladu a pozice čtení.
///
/// Sleduje jen knihu + kapitolu (ne verš), takže posouvání v rámci kapitoly
/// nevyvolá nové načtení.
final chapterContentProvider = FutureProvider.autoDispose<ChapterContent>((
  ref,
) {
  final selection = ref.watch(translationControllerProvider);
  final (bookId, chapter) = ref.watch(
    readingPositionProvider.select((p) => (p.bookId, p.chapter)),
  );
  return ref.watch(
    chapterPageProvider((
      primaryId: selection.primaryId,
      secondaryId: selection.secondaryId,
      bookId: bookId,
      chapter: chapter,
    )).future,
  );
});

/// Všechny kapitoly hlavního překladu v kanonickém pořadí – stránky
/// horizontálního listování čtečky.
final chapterListProvider = FutureProvider<List<VerseRef>>((ref) async {
  final primaryId = ref.watch(
    translationControllerProvider.select((s) => s.primaryId),
  );
  final counts = await ref.watch(chapterCountsProvider(primaryId).future);
  return [
    for (var book = 1; book <= 66; book++)
      for (var ch = 1; ch <= (counts[book] ?? 0); ch++) VerseRef(book, ch),
  ];
});
