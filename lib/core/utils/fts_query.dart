/// Převede uživatelský vstup na bezpečný dotaz pro SQLite FTS5.
///
/// * Diakritiku i velikost písmen řeší přímo tokenizer FTS5
///   (`unicode61 remove_diacritics 2`), takže "laska" najde "láska".
/// * Každé slovo se hledá jako předpona (`slovo*`) – čeština je silně
///   flektivní, "milost" tak najde i "milosti", "milostí", "milostivý".
/// * Text v uvozovkách se hledá jako přesná fráze: `"chléb života"`.
/// * Speciální znaky syntaxe FTS5 (`AND`, `*`, `:`, `^`, závorky…) se
///   neinterpretují – vstup se tokenizuje a každý token se uzavře do
///   uvozovek, takže neplatný dotaz nikdy nevyhodí výjimku.
///
/// Vrací `null`, pokud dotaz neobsahuje žádné hledatelné slovo.
String? buildFtsQuery(String input) {
  final parts = <String>[];

  // Fráze v uvozovkách (rovné i české „…“).
  final phrase = RegExp(r'["„“]([^"„“]+)["„“]');
  for (final match in phrase.allMatches(input)) {
    final words = _words(match.group(1)!);
    if (words.isNotEmpty) parts.add('"${words.join(' ')}"');
  }
  for (final word in _words(input.replaceAll(phrase, ' '))) {
    parts.add('"$word"*');
  }

  return parts.isEmpty ? null : parts.join(' ');
}

/// Rozdělí text na slova (písmena a číslice libovolné abecedy).
List<String> _words(String text) => RegExp(
  r'[\p{L}\p{N}]+',
  unicode: true,
).allMatches(text).map((m) => m.group(0)!).toList();
