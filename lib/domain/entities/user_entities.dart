import 'bible_entities.dart';

/// Barvy zvýraznění veršů. Do databáze se ukládá `name`.
enum HighlightColor { yellow, green, blue, pink, purple }

/// Zvýrazněný verš.
class Highlight {
  const Highlight({
    required this.id,
    required this.ref,
    required this.color,
    required this.createdAt,
  });

  final int id;
  final VerseRef ref;
  final HighlightColor color;
  final DateTime createdAt;
}

/// Záložka.
class Bookmark {
  const Bookmark({
    required this.id,
    required this.ref,
    required this.createdAt,
    this.translationId,
    this.label,
  });

  final int id;
  final VerseRef ref;
  final String? translationId;
  final String? label;
  final DateTime createdAt;
}

/// Výsledek obnovy ze zálohy (počty nově přidaných / aktualizovaných položek).
class BackupImportResult {
  const BackupImportResult({
    required this.highlights,
    required this.bookmarks,
    required this.notes,
    this.readings = 0,
  });

  final int highlights;
  final int bookmarks;
  final int notes;

  /// Nově doplněné záznamy o přečtených kapitolách.
  final int readings;

  int get total => highlights + bookmarks + notes + readings;
}

/// Chyba: soubor není platná záloha této aplikace.
class InvalidBackupException implements Exception {
  const InvalidBackupException(this.reason);

  final String reason;

  @override
  String toString() => 'InvalidBackupException: $reason';
}

/// Poznámka k verši nebo rozsahu veršů.
class Note {
  const Note({
    required this.id,
    required this.ref,
    required this.verseEnd,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;

  /// Začátek rozsahu (kniha, kapitola, první verš).
  final VerseRef ref;
  final int verseEnd;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;
}
