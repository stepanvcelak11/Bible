import '../entities/bible_entities.dart';

/// Formátování biblických odkazů podle české konvence:
/// kapitola a verš oddělené čárkou, rozsah pomlčkou, výčet tečkou –
/// např. „Jan 3,16–18.20“.
abstract final class Citation {
  /// „Jan 3,16“, „Jan 3,16–18“, „Jan 3,1.5–7“.
  static String range(String bookName, int chapter, Iterable<int> verses) {
    final sorted = verses.toSet().toList()..sort();
    if (sorted.isEmpty) return '$bookName $chapter';
    return '$bookName $chapter,${_compress(sorted)}';
  }

  /// „Jan 3,16“
  static String single(String bookName, VerseRef ref) =>
      '$bookName ${ref.chapter},${ref.verse}';

  /// Spojí po sobě jdoucí čísla do rozsahů: [1,2,3,5] → „1–3.5“.
  static String _compress(List<int> sorted) {
    final parts = <String>[];
    var start = sorted.first;
    var prev = start;
    for (final n in sorted.skip(1)) {
      if (n == prev + 1) {
        prev = n;
        continue;
      }
      parts.add(start == prev ? '$start' : '$start–$prev');
      start = prev = n;
    }
    parts.add(start == prev ? '$start' : '$start–$prev');
    return parts.join('.');
  }

  /// Text pro kopírování / sdílení vybraných veršů.
  ///
  /// Jeden verš: „text“ + odkaz. Více veršů: odkaz a pak verše s čísly.
  static String shareText({
    required String bookName,
    required int chapter,
    required List<Verse> verses,
    required String translationAbbreviation,
  }) {
    final sorted = [...verses]..sort((a, b) => a.number.compareTo(b.number));
    final ref = range(bookName, chapter, sorted.map((v) => v.number));
    if (sorted.length == 1) {
      return '„${sorted.single.text}“\n— $ref ($translationAbbreviation)';
    }
    final body = sorted.map((v) => '${v.number} ${v.text}').join('\n');
    return '$ref ($translationAbbreviation)\n$body';
  }
}
