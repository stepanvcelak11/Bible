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
    int limit = 200,
  });
}
