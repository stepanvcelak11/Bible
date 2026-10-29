import '../entities/bible_entities.dart';

/// Kontrakt pro přístup k (pouze čitelnému) obsahu Bible.
///
/// Implementace musí fungovat 100% offline. UI a stavová logika závisí
/// pouze na tomto rozhraní, takže lze databázi v testech snadno nahradit.
abstract interface class BibleRepository {
  /// Všechny dostupné překlady v pořadí pro výběr překladu.
  Future<List<Translation>> getTranslations();

  /// Všech 66 knih v kanonickém pořadí.
  Future<List<Book>> getBooks();

  /// Počet kapitol každé knihy v daném překladu (`bookId → počet`).
  /// Knihy, které překlad neobsahuje, v mapě chybí.
  Future<Map<int, int>> getChapterCounts(String translationId);

  /// Verše jedné kapitoly seřazené podle čísla verše.
  Future<List<Verse>> getChapter(String translationId, int bookId, int chapter);

  /// Kapitola včetně nadpisů oddílů a poznámek překladatelů.
  Future<ChapterText> getChapterText(
    String translationId,
    int bookId,
    int chapter,
  );

  /// Překlady a jejich umístění se změnily (stažení/odstranění) – zahodit
  /// cache.
  void invalidate();

  /// Jeden verš (např. pro seznam záložek), nebo `null`, pokud v překladu
  /// neexistuje.
  Future<Verse?> getVerse(String translationId, VerseRef ref);

  /// Kapitola ve dvou překladech zarovnaná podle čísla verše.
  Future<List<ParallelVerse>> getParallelChapter(
    String primaryId,
    String secondaryId,
    int bookId,
    int chapter,
  );

  /// Fulltextové vyhledávání nezávislé na diakritice a velikosti písmen.
  /// Při `translationIds == null` hledá ve všech překladech, při
  /// `testament == null` v celé Bibli.
  Future<List<SearchHit>> search(
    String query, {
    Set<String>? translationIds,
    Testament? testament,
    int? bookId,
    int limit = 200,
    int offset = 0,
  });

  /// Verše, které obsahují aspoň jeden z [terms] (předpony slov; `a_b` =
  /// fráze, `slovo=` = celé slovo), seřazené podle relevance (BM25).
  Future<List<SearchHit>> searchAny(
    List<String> terms, {
    required String translationId,
    int limit = 150,
  });

  /// Počet nalezených veršů v jednotlivých knihách (`bookId → počet`).
  Future<Map<int, int>> searchCounts(
    String query, {
    Set<String>? translationIds,
    Testament? testament,
  });
}
