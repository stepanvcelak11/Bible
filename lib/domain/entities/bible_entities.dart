// Doménové entity – čisté neměnné třídy bez závislosti na Flutteru či Driftu.
// Datová vrstva mapuje řádky databáze na tyto typy, UI pracuje jen s nimi.

/// Starý nebo Nový zákon.
enum Testament {
  oldTestament('OT'),
  newTestament('NT');

  const Testament(this.code);

  /// Kód uložený v databázi.
  final String code;

  static Testament fromCode(String code) =>
      code == 'NT' ? Testament.newTestament : Testament.oldTestament;
}

/// Překlad Bible uložený v offline databázi.
class Translation {
  const Translation({
    required this.id,
    required this.name,
    required this.abbreviation,
    this.year,
    this.license,
    this.description,
    this.downloaded = false,
  });

  /// Stabilní kód překladu (např. `BKR`). Používá se jako klíč všude.
  final String id;

  /// Plný název, např. „Bible kralická“.
  final String name;

  /// Zobrazovaná zkratka, např. „BKR“ nebo „ČSP“.
  final String abbreviation;

  final int? year;
  final String? license;
  final String? description;

  /// Stažený v aplikaci (lze odstranit), ne přibalený.
  final bool downloaded;

  @override
  bool operator ==(Object other) => other is Translation && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Translation($id)';
}

/// Biblická kniha. `id` je kanonické pořadí 1–66 a je shodné ve všech
/// překladech i v uživatelských datech.
class Book {
  const Book({
    required this.id,
    required this.osis,
    required this.name,
    required this.abbreviation,
    required this.testament,
  });

  final int id;
  final String osis;
  final String name;
  final String abbreviation;
  final Testament testament;

  @override
  bool operator ==(Object other) => other is Book && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Odkaz na verš nezávislý na překladu.
///
/// Právě to, že pozice čtení ani uživatelská data neobsahují `translationId`,
/// umožňuje přepnout překlad a zůstat na stejném místě – a mít zvýraznění
/// či poznámky viditelné ve všech překladech.
class VerseRef implements Comparable<VerseRef> {
  const VerseRef(this.bookId, this.chapter, [this.verse = 1])
    : assert(bookId >= 1 && bookId <= 66),
      assert(chapter >= 1),
      assert(verse >= 1);

  final int bookId;
  final int chapter;
  final int verse;

  VerseRef copyWith({int? bookId, int? chapter, int? verse}) => VerseRef(
    bookId ?? this.bookId,
    chapter ?? this.chapter,
    verse ?? this.verse,
  );

  /// Kompaktní textová podoba pro uložení do preferencí: `43:3:16`.
  String encode() => '$bookId:$chapter:$verse';

  static VerseRef? tryDecode(String? value) {
    final parts = value?.split(':');
    if (parts == null || parts.length != 3) return null;
    final numbers = parts.map(int.tryParse).toList();
    if (numbers.contains(null)) return null;
    final [book!, chapter!, verse!] = numbers;
    if (book < 1 || book > 66 || chapter < 1 || verse < 1) return null;
    return VerseRef(book, chapter, verse);
  }

  @override
  int compareTo(VerseRef other) {
    if (bookId != other.bookId) return bookId.compareTo(other.bookId);
    if (chapter != other.chapter) return chapter.compareTo(other.chapter);
    return verse.compareTo(other.verse);
  }

  @override
  bool operator ==(Object other) =>
      other is VerseRef &&
      other.bookId == bookId &&
      other.chapter == chapter &&
      other.verse == verse;

  @override
  int get hashCode => Object.hash(bookId, chapter, verse);

  @override
  String toString() => 'VerseRef(${encode()})';
}

/// Jeden verš konkrétního překladu.
class Verse {
  const Verse({
    required this.translationId,
    required this.ref,
    required this.text,
    this.paragraph = true,
    this.poetry = false,
  });

  final String translationId;
  final VerseRef ref;

  /// Text verše; řádky poezie jsou odděleny `\n`.
  final String text;

  /// Verš začíná nový odstavec.
  final bool paragraph;

  /// Verš je poezie (žalmy, písně) – zobrazuje se po řádcích s odsazením.
  final bool poetry;

  int get number => ref.verse;
}

/// Kapitola jednoho překladu včetně nadpisů oddílů a poznámek překladatelů.
class ChapterText {
  const ChapterText({
    required this.verses,
    this.headings = const {},
    this.footnotes = const {},
  });

  final List<Verse> verses;

  /// Nadpisy zobrazené PŘED veršem s daným číslem.
  final Map<int, List<String>> headings;

  /// Poznámky překladatelů k veršům.
  final Map<int, List<String>> footnotes;
}

/// Řádek srovnávacího (dvousloupcového) zobrazení. Jedna strana může chybět,
/// pokud překlady verše číslují odlišně.
class ParallelVerse {
  const ParallelVerse({required this.number, this.primary, this.secondary});

  final int number;
  final Verse? primary;
  final Verse? secondary;
}

/// Výsledek fulltextového vyhledávání.
class SearchHit {
  const SearchHit({required this.verse, required this.snippet});

  final Verse verse;

  /// Úryvek se zvýrazněnými shodami ohraničenými značkami
  /// [SearchHit.matchStart] a [SearchHit.matchEnd].
  final String snippet;

  static const matchStart = '\u0002';
  static const matchEnd = '\u0003';
}
