import '../entities/bible_entities.dart';
import '../entities/user_entities.dart';

/// Kontrakt pro osobní data uživatele (zvýraznění, záložky, poznámky).
///
/// Metody `watch…` vrací streamy, které Drift automaticky znovu vyšle po
/// každé změně – UI se tak překreslí bez ručního obnovování.
abstract interface class UserDataRepository {
  // --- Zvýraznění ---------------------------------------------------------
  Stream<List<Highlight>> watchHighlightsInChapter(int bookId, int chapter);
  Stream<List<Highlight>> watchAllHighlights();

  /// Nastaví barvu zvýraznění; `null` zvýraznění odstraní.
  Future<void> setHighlight(VerseRef ref, HighlightColor? color);

  // --- Záložky ------------------------------------------------------------
  Stream<List<Bookmark>> watchBookmarksInChapter(int bookId, int chapter);
  Stream<List<Bookmark>> watchAllBookmarks();

  /// Přidá záložku, nebo ji odebere, pokud už existuje. Vrací `true`, pokud
  /// je verš po operaci v záložkách.
  Future<bool> toggleBookmark(VerseRef ref, {String? translationId});

  // --- Poznámky -----------------------------------------------------------
  Stream<List<Note>> watchNotesInChapter(int bookId, int chapter);
  Stream<List<Note>> watchAllNotes();

  /// Vytvoří (při `id == null`) nebo upraví poznámku. Vrací její id.
  Future<int> saveNote({
    int? id,
    required VerseRef ref,
    int? verseEnd,
    required String body,
  });

  Future<void> deleteNote(int id);

  // --- Záloha -------------------------------------------------------------

  /// Všechna uživatelská data jako JSON-kompatibilní mapa (verze formátu 1).
  Future<Map<String, Object?>> exportBackup();

  /// Sloučí zálohu s existujícími daty: zvýraznění a záložky podle verše
  /// (záloha vyhrává), poznámky se přidají, pokud stejná ještě neexistuje.
  /// Při neplatném formátu vyhodí [InvalidBackupException] a nic nezmění.
  Future<BackupImportResult> importBackup(Map<String, Object?> json);
}
