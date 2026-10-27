import '../entities/bible_entities.dart';

/// Čistá logika přechodů mezi kapitolami (bez I/O → snadno testovatelná).
///
/// Pracuje s počty kapitol konkrétního překladu, protože se mezi překlady
/// liší (BKR: Jóel 3 kapitoly, ČSP: 4). Knihy, které překlad neobsahuje,
/// se při listování přeskočí.
class ChapterNavigator {
  const ChapterNavigator(this.chapterCounts);

  /// `bookId → počet kapitol` v daném překladu.
  final Map<int, int> chapterCounts;

  /// Následující kapitola (přes hranici knihy), nebo `null` na konci Bible.
  VerseRef? next(VerseRef current) {
    final count = chapterCounts[current.bookId] ?? 0;
    if (current.chapter < count) {
      return VerseRef(current.bookId, current.chapter + 1);
    }
    for (var book = current.bookId + 1; book <= 66; book++) {
      if ((chapterCounts[book] ?? 0) > 0) return VerseRef(book, 1);
    }
    return null;
  }

  /// Předchozí kapitola (přes hranici knihy), nebo `null` na začátku Bible.
  VerseRef? previous(VerseRef current) {
    if (current.chapter > 1) {
      final count = chapterCounts[current.bookId] ?? 0;
      // Pokud jsme mimo rozsah překladu (např. Jóel 4 v BKR), skoč na
      // jeho poslední kapitolu.
      return VerseRef(
        current.bookId,
        (current.chapter - 1).clamp(1, count > 0 ? count : 1),
      );
    }
    for (var book = current.bookId - 1; book >= 1; book--) {
      final count = chapterCounts[book] ?? 0;
      if (count > 0) return VerseRef(book, count);
    }
    return null;
  }

  /// Upraví pozici tak, aby v překladu existovala. Pokud kapitola chybí
  /// (jiné číslování), přejde na poslední kapitolu knihy. Verš se zachová –
  /// pokud v kapitole neexistuje, čtečka se prostě posune na její konec.
  VerseRef clamp(VerseRef ref) {
    final count = chapterCounts[ref.bookId] ?? 0;
    if (count == 0 || ref.chapter <= count) return ref;
    return VerseRef(ref.bookId, count);
  }
}
