import '../../../domain/entities/bible_entities.dart';

const _from = 'áčďéěíňóřšťúůýžäöüÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ';
const _to = 'acdeeinorstuuyzaouACDEEINORSTUUYZ';

/// Malá písmena bez diakritiky: „Žalmy“ → „zalmy“.
String foldCzech(String s) {
  final b = StringBuffer();
  for (final rune in s.runes) {
    final ch = String.fromCharCode(rune);
    final i = _from.indexOf(ch);
    b.write(i >= 0 ? _to[i] : ch);
  }
  return b.toString().toLowerCase();
}

/// Běžné české a mezinárodní zkratky knih navíc k názvům a zkratkám ČEP.
const _aliases = {
  'gen': 1,
  'gn': 1,
  'ex': 2,
  'exo': 2,
  'lv': 3,
  'lev': 3,
  'nu': 4,
  'num': 4,
  'dt': 5,
  'deut': 5,
  'joz': 6,
  'jozue': 6,
  'sd': 7,
  'soud': 7,
  'rut': 8,
  'rt': 8,
  'kral': 11,
  'par': 13,
  'ezd': 15,
  'neh': 16,
  'est': 17,
  'job': 18,
  'jb': 18,
  'zalm': 19,
  'zalmy': 19,
  'z': 19,
  'zl': 19,
  'ps': 19,
  'pr': 20,
  'pris': 20,
  'prislovi': 20,
  'kaz': 21,
  'pis': 22,
  'iz': 23,
  'izaias': 23,
  'jer': 24,
  'jr': 24,
  'pl': 25,
  'plac': 25,
  'ez': 26,
  'ezech': 26,
  'dan': 27,
  'da': 27,
  'oz': 28,
  'jl': 29,
  'joel': 29,
  'am': 30,
  'amos': 30,
  'abd': 31,
  'jon': 32,
  'mi': 33,
  'mich': 33,
  'na': 34,
  'nah': 34,
  'abk': 35,
  'hab': 35,
  'sf': 36,
  'sof': 36,
  'ag': 37,
  'za': 38,
  'zach': 38,
  'mal': 39,
  'mt': 40,
  'mat': 40,
  'matous': 40,
  'mk': 41,
  'mar': 41,
  'marek': 41,
  'l': 42,
  'lk': 42,
  'luk': 42,
  'lukas': 42,
  'j': 43,
  'jn': 43,
  'jan': 43,
  'sk': 44,
  'skutky': 44,
  'r': 45,
  'rim': 45,
  'rimanum': 45,
  'kor': 46,
  'gal': 48,
  'ga': 48,
  'ef': 49,
  'fp': 50,
  'flp': 50,
  'fil': 50,
  'ko': 51,
  'kol': 51,
  'te': 52,
  'tes': 52,
  'tim': 54,
  'tm': 54,
  'tt': 56,
  'tit': 56,
  'fm': 57,
  'flm': 57,
  'zd': 58,
  'zid': 58,
  'zidum': 58,
  'jk': 59,
  'jak': 59,
  'jakub': 59,
  'pt': 60,
  'petr': 60,
  'ju': 65,
  'jud': 65,
  'zj': 66,
  'zjev': 66,
  'zjeveni': 66,
  'apok': 66,
};

/// Knihy s čísly (1S, 2Kr, 1K…), kde alias bez čísla ukazuje na 1. knihu.
const _numbered = {
  'sam': 9,
  's': 9,
  'samuel': 9,
  'samuelova': 9,
  'kr': 11,
  'kralovska': 11,
  'kral': 11,
  'pa': 13,
  'par': 13,
  'paralipomenon': 13,
  'k': 46,
  'kor': 46,
  'korintskym': 46,
  'te': 52,
  'tes': 52,
  'tesalonickym': 52,
  'tm': 54,
  'tim': 54,
  'timoteovi': 54,
  'pt': 60,
  'petr': 60,
  'petruv': 60,
  'j': 62,
  'jn': 62,
  'jan': 62,
  'januv': 62,
};

String _key(String s) => foldCzech(s).replaceAll(RegExp(r'[\s.]'), '');

int? _resolveBook(String token, List<Book> books) {
  final t = _key(token);
  if (t.isEmpty) return null;
  // „1kor“, „2 Sam“…
  final m = RegExp(r'^([1-3])([a-z]+)$').firstMatch(t);
  if (m != null) {
    final n = int.parse(m[1]!);
    final base = _numbered[m[2]];
    if (base != null) {
      final id = base + n - 1;
      // 1–3 Janův (62–64), 1–2 ostatní.
      if (base == 62 ? n <= 3 : n <= 2) return id;
    }
  }
  for (final b in books) {
    if (_key(b.abbreviation) == t || _key(b.name) == t || _key(b.osis) == t) {
      return b.id;
    }
  }
  if (_aliases[t] case final id?) return id;
  if (t.length >= 3) {
    for (final b in books) {
      if (_key(b.name).startsWith(t)) return b.id;
    }
  }
  return null;
}

/// Rozpozná biblický odkaz: „J 3,16“, „jan 3:16“, „1 Kor 13“, „Žalm 23“,
/// „gn1“. Vyžaduje číslo kapitoly; bez něj vrací `null`.
VerseRef? parseReference(String input, List<Book> books) {
  final m = RegExp(
    r'^\s*([1-3]?\s*\.?\s*[^\d\s,.:]+(?:\s+[^\d\s,.:]+)?)\s*(\d{1,3})(?:\s*[,:.]\s*(\d{1,3}))?',
  ).firstMatch(input.trim());
  if (m == null) return null;
  final book = _resolveBook(m[1]!, books);
  if (book == null) return null;
  final chapter = int.parse(m[2]!);
  final verse = int.tryParse(m[3] ?? '') ?? 1;
  if (chapter < 1 || verse < 1) return null;
  return VerseRef(book, chapter, verse);
}

/// Odpovídá kniha hledanému textu (bez diakritiky)?
bool bookMatches(Book book, String folded) {
  final q = folded.replaceAll(RegExp(r'[\s.]'), '');
  if (q.isEmpty) return true;
  if (_key(book.name).contains(q) || _key(book.abbreviation).startsWith(q)) {
    return true;
  }
  return _resolveBook(q, [book]) == book.id;
}
