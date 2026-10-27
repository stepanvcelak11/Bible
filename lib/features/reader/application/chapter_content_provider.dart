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
}

final class SingleChapter extends ChapterContent {
  const SingleChapter(super.bookId, super.chapter, this.verses);

  final List<Verse> verses;

  @override
  bool get isEmpty => verses.isEmpty;
}

final class ParallelChapter extends ChapterContent {
  const ParallelChapter(super.bookId, super.chapter, this.rows);

  final List<ParallelVerse> rows;

  @override
  bool get isEmpty => rows.isEmpty;
}

/// Kapitola podle aktuálního výběru překladu a pozice čtení.
///
/// Sleduje jen knihu + kapitolu (ne verš), takže posouvání v rámci kapitoly
/// nevyvolá nové načtení. Při přepnutí překladu/kapitoly Riverpod ponechá
/// předchozí data (`AsyncValue.value` během `isLoading`), takže UI může
/// zobrazovat starý obsah až do okamžiku, kdy je nový připraven – bez
/// probliknutí načítacího indikátoru.
final chapterContentProvider = FutureProvider.autoDispose<ChapterContent>((
  ref,
) async {
  final selection = ref.watch(translationControllerProvider);
  final (bookId, chapter) = ref.watch(
    readingPositionProvider.select((p) => (p.bookId, p.chapter)),
  );
  final repo = ref.watch(bibleRepositoryProvider);

  final secondary = selection.secondaryId;
  if (secondary == null) {
    return SingleChapter(
      bookId,
      chapter,
      await repo.getChapter(selection.primaryId, bookId, chapter),
    );
  }
  return ParallelChapter(
    bookId,
    chapter,
    await repo.getParallelChapter(
      selection.primaryId,
      secondary,
      bookId,
      chapter,
    ),
  );
});
