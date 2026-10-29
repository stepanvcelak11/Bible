import '../entities/bible_entities.dart';
import 'versification_data.dart';

/// Systém číslování veršů překladu.
///
/// Bible kralická používá anglické (KJV) číslování: nadpisy žalmů jsou
/// součástí verše 1, Jóel má 3 kapitoly, Malachiáš 4… Výjimkou je žalm 22,
/// kde má BKR nadpis jako verš 1 (jako hebrejský text) a hebrejské verše
/// 31–32 spojuje do verše 31 – tabulky to tak převádějí. Moderní české
/// překlady (ČEP, B21, ČSP) číslují podle hebrejského textu.
enum VerseScheme { english, hebrew }

VerseScheme schemeOf(String translationId) =>
    translationId == 'BKR' ? VerseScheme.english : VerseScheme.hebrew;

/// Převod odkazů mezi číslováními. Aplikace ukládá a sdílí odkazy
/// v „kanonickém“ (hebrejském) číslování; převádí se jen na hranici
/// s textem konkrétního překladu.
abstract final class Versification {
  static final _e2h = _Table.parse(engToHebRuns);
  static final _h2e = _Table.parse(hebToEngRuns);

  static VerseRef convert(VerseRef ref, VerseScheme from, VerseScheme to) {
    if (from == to) return ref;
    final table = from == VerseScheme.english ? _e2h : _h2e;
    return table.map(ref);
  }

  /// Odkaz v číslování překladu → kanonický (hebrejský).
  static VerseRef toCanonical(VerseRef ref, String translationId) =>
      convert(ref, schemeOf(translationId), VerseScheme.hebrew);

  /// Kanonický odkaz → číslování překladu.
  static VerseRef fromCanonical(VerseRef ref, String translationId) =>
      convert(ref, VerseScheme.hebrew, schemeOf(translationId));

  /// Odkaz z překladu [from] na stejné místo v překladu [to].
  static VerseRef between(VerseRef ref, String from, String to) =>
      convert(ref, schemeOf(from), schemeOf(to));

  /// Kapitoly v číslování [to], do kterých zasahuje kapitola [chapter]
  /// z číslování [from] (např. BKR Jóel 2 → ČEP Jóel 2 a 3).
  static Set<int> chaptersSpanned(
    int bookId,
    int chapter,
    int verseCount,
    VerseScheme from,
    VerseScheme to,
  ) {
    if (from == to) return {chapter};
    return {
      for (var v = 1; v <= verseCount; v++)
        convert(VerseRef(bookId, chapter, v), from, to).chapter,
    };
  }
}

class _Table {
  _Table(this._runs);

  /// kniha → úseky [kapitola, verš, cílová kapitola, cílový verš, délka].
  final Map<int, List<List<int>>> _runs;

  factory _Table.parse(String data) {
    final runs = <int, List<List<int>>>{};
    for (final item in data.split(';')) {
      if (item.isEmpty) continue;
      final n = item.split(' ').map(int.parse).toList();
      (runs[n[0]] ??= []).add(n.sublist(1));
    }
    return _Table(runs);
  }

  VerseRef map(VerseRef ref) {
    final runs = _runs[ref.bookId];
    if (runs == null) return ref;
    for (final r in runs) {
      if (r[0] == ref.chapter && ref.verse >= r[1] && ref.verse < r[1] + r[4]) {
        return VerseRef(ref.bookId, r[2], r[3] + ref.verse - r[1]);
      }
    }
    return ref;
  }
}
