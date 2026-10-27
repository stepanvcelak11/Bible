/// Chyba: v balíčku aplikace chybí databáze Bible (nebyl spuštěn
/// `tool/build_bible_db.py`).
class BibleDataMissingException implements Exception {
  const BibleDataMissingException(this.cause);

  final Object cause;

  @override
  String toString() => 'BibleDataMissingException: $cause';
}
