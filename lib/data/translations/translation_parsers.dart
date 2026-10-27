import 'dart:async';
import 'dart:convert';

/// Jeden verš rozparsovaného překladu.
class ParsedVerse {
  ParsedVerse(
    this.bookId,
    this.chapter,
    this.verse,
    this.text, {
    this.paragraph = true,
    this.poetry = false,
  });

  final int bookId;
  final int chapter;
  final int verse;
  String text;
  bool paragraph;
  final bool poetry;
}

/// Nadpis oddílu nebo poznámka překladatele navázaná na verš.
typedef ParsedNote = ({int bookId, int chapter, int verse, String text});

/// Výsledek parseru – stejná struktura, jakou ukládá `tool/build_bible_db.py`.
class ParsedTranslation {
  ParsedTranslation(this.verses, this.headings, this.footnotes);

  final List<ParsedVerse> verses;
  final List<ParsedNote> headings;
  final List<ParsedNote> footnotes;
}

/// Chyba: soubor není v podporovaném formátu.
class TranslationFormatException implements Exception {
  const TranslationFormatException(this.message);

  final String message;

  @override
  String toString() => 'TranslationFormatException: $message';
}

/// OSIS kódy knih → id 1–66 (kanonické pořadí).
const osisBookCodes = [
  'Gen', 'Exod', 'Lev', 'Num', 'Deut', 'Josh', 'Judg', 'Ruth', '1Sam', //
  '2Sam', '1Kgs', '2Kgs', '1Chr', '2Chr', 'Ezra', 'Neh', 'Esth', 'Job',
  'Ps', 'Prov', 'Eccl', 'Song', 'Isa', 'Jer', 'Lam', 'Ezek', 'Dan', 'Hos',
  'Joel', 'Amos', 'Obad', 'Jonah', 'Mic', 'Nah', 'Hab', 'Zeph', 'Hag',
  'Zech', 'Mal', 'Matt', 'Mark', 'Luke', 'John', 'Acts', 'Rom', '1Cor',
  '2Cor', 'Gal', 'Eph', 'Phil', 'Col', '1Thess', '2Thess', '1Tim', '2Tim',
  'Titus', 'Phlm', 'Heb', 'Jas', '1Pet', '2Pet', '1John', '2John', '3John',
  'Jude', 'Rev',
];

final _osisToId = {
  for (final (i, code) in osisBookCodes.indexed) code.toLowerCase(): i + 1,
};

/// Anglické názvy knih ve formátu scrollmapper.
const _englishNames = [
  'genesis', 'exodus', 'leviticus', 'numbers', 'deuteronomy', 'joshua', //
  'judges', 'ruth', 'i samuel', 'ii samuel', 'i kings', 'ii kings',
  'i chronicles', 'ii chronicles', 'ezra', 'nehemiah', 'esther', 'job',
  'psalms', 'proverbs', 'ecclesiastes', 'song of solomon', 'isaiah',
  'jeremiah', 'lamentations', 'ezekiel', 'daniel', 'hosea', 'joel', 'amos',
  'obadiah', 'jonah', 'micah', 'nahum', 'habakkuk', 'zephaniah', 'haggai',
  'zechariah', 'malachi', 'matthew', 'mark', 'luke', 'john', 'acts',
  'romans', 'i corinthians', 'ii corinthians', 'galatians', 'ephesians',
  'philippians', 'colossians', 'i thessalonians', 'ii thessalonians',
  'i timothy', 'ii timothy', 'titus', 'philemon', 'hebrews', 'james',
  'i peter', 'ii peter', 'i john', 'ii john', 'iii john', 'jude',
  'revelation of john',
];

final _englishToId = {
  for (final (i, n) in _englishNames.indexed) n: i + 1,
  'revelation': 66,
};

/// Rozpozná formát podle obsahu a rozparsuje ho.
Future<ParsedTranslation> parseTranslation(String content) {
  final head = content.substring(0, content.length.clamp(0, 4000));
  if (head.contains('<osis')) return parseOsis(content);
  if (head.contains('<XMLBIBLE') || head.contains('<BIBLEBOOK')) {
    return parseZefania(content);
  }
  if (head.trimLeft().startsWith('{')) return Future.value(parseJson(content));
  throw const TranslationFormatException('Neznámý formát souboru.');
}

// --- Sdílené pomůcky -----------------------------------------------------------

final _ws = RegExp(r'\s+');
final _spaceAfterOpen = RegExp(r'([(\[„]) +');
final _spaceBeforeClose = RegExp(r' +([)\],.;:!?“])');

/// Sjednotí mezery, zachová zalomení řádků poezie (`\n`).
String cleanText(String text) => text
    .split('\n')
    .map((l) => l.replaceAll(_ws, ' ').trim())
    .where((l) => l.isNotEmpty)
    .join('\n');

/// Opraví mezery rozbité formátováním XML: „( země)“ → „(země)“.
String fixSpacing(String text) => text
    .replaceAllMapped(_spaceAfterOpen, (m) => m[1]!)
    .replaceAllMapped(_spaceBeforeClose, (m) => m[1]!);

final _entity = RegExp(r'&(#x[0-9a-fA-F]+|#[0-9]+|[a-zA-Z]+);');
const _named = {'amp': '&', 'lt': '<', 'gt': '>', 'quot': '"', 'apos': "'"};

String _unescape(String s) {
  if (!s.contains('&')) return s;
  return s.replaceAllMapped(_entity, (m) {
    final e = m[1]!;
    if (e.startsWith('#x')) {
      return String.fromCharCode(int.parse(e.substring(2), radix: 16));
    }
    if (e.startsWith('#')) {
      return String.fromCharCode(int.parse(e.substring(1)));
    }
    return _named[e] ?? m[0]!;
  });
}

final _token = RegExp(r'<[^>]+>|[^<]+');
final _tag = RegExp(r'^<\s*(/?)\s*([A-Za-z]+)([^>]*?)(/?)\s*>$');
final _attr = RegExp(r'([A-Za-z]+)="([^"]*)"');

/// Kolik tokenů zpracovat, než se vrátí řízení UI (web nemá isolates).
const _yieldEvery = 40000;

ParsedTranslation _finish(
  List<ParsedVerse> raw,
  List<ParsedNote> headings,
  List<ParsedNote> footnotes,
) {
  // Spojit duplicity, vyčistit text, seřadit kanonicky.
  final byRef = <int, ParsedVerse>{};
  for (final v in raw) {
    final text = fixSpacing(cleanText(v.text));
    if (text.isEmpty || v.verse < 1) continue;
    final key = (v.bookId * 1000 + v.chapter) * 1000 + v.verse;
    final existing = byRef[key];
    if (existing != null) {
      existing.text = '${existing.text} $text';
    } else {
      byRef[key] = v..text = text;
    }
  }
  final verses = byRef.values.toList()
    ..sort(
      (a, b) =>
          ((a.bookId * 1000 + a.chapter) * 1000 + a.verse) -
          ((b.bookId * 1000 + b.chapter) * 1000 + b.verse),
    );
  // Zdroj bez skutečných odstavců → verš po verši.
  if (verses.where((v) => v.paragraph).length < verses.length * 0.10) {
    for (final v in verses) {
      v.paragraph = true;
    }
  }
  return ParsedTranslation(verses, headings, footnotes);
}

// --- OSIS ------------------------------------------------------------------------

const _skipTitleTypes = {'main', 'chapter', 'runningHead', 'acrostic'};

/// Proudové zpracování OSIS XML (moduly CrossWire/SWORD) – stejný
/// algoritmus jako `parse_osis` v tool/build_bible_db.py.
Future<ParsedTranslation> parseOsis(String text) async {
  final verses = <ParsedVerse>[];
  final headings = <ParsedNote>[];
  final footnotes = <ParsedNote>[];

  ParsedVerse? cur;
  StringBuffer buf = StringBuffer();
  var paraPending = true;
  var lgDepth = 0;
  var noteDepth = 0;
  var noteBuf = StringBuffer();
  var titleDepth = 0;
  var titleBuf = StringBuffer();
  var titleSkip = false;
  var pendingTitles = <String>[];
  var inHeader = false;
  var count = 0;

  void end() {
    final v = cur;
    if (v != null) {
      v.text = buf.toString();
      verses.add(v);
    }
    cur = null;
  }

  void start(String osisId) {
    final ref = osisId.split(RegExp(r'\s+')).first.split('.');
    final book = ref.length == 3 ? _osisToId[ref[0].toLowerCase()] : null;
    final ch = ref.length == 3 ? int.tryParse(ref[1]) : null;
    final vs = ref.length == 3 ? int.tryParse(ref[2]) : null;
    if (book == null || ch == null || vs == null) {
      cur = null; // deuterokanonické knihy apod.
      return;
    }
    cur = ParsedVerse(
      book,
      ch,
      vs,
      '',
      paragraph: paraPending,
      poetry: lgDepth > 0,
    );
    buf = StringBuffer();
    paraPending = false;
    for (final t in pendingTitles) {
      headings.add((bookId: book, chapter: ch, verse: vs, text: t));
    }
    pendingTitles = [];
  }

  for (final m in _token.allMatches(text)) {
    if (++count % _yieldEvery == 0) await Future<void>.delayed(Duration.zero);
    final tok = m[0]!;
    if (!tok.startsWith('<')) {
      if (inHeader) continue;
      final chunk = _unescape(tok).replaceAll(_ws, ' ');
      if (noteDepth > 0) {
        noteBuf.write(chunk);
      } else if (titleDepth > 0) {
        titleBuf.write(chunk);
      } else if (cur != null) {
        buf.write(chunk);
      }
      continue;
    }
    if (tok.startsWith('<?') || tok.startsWith('<!')) continue;
    final t = _tag.firstMatch(tok);
    if (t == null) continue;
    final closing = t[1]!.isNotEmpty;
    final name = t[2]!;
    final selfClosing = t[4]!.isNotEmpty;
    final attrs = {for (final a in _attr.allMatches(t[3]!)) a[1]!: a[2]!};

    if (name == 'header') {
      inHeader = !closing && !selfClosing;
      continue;
    }
    if (inHeader) continue;
    if (name == 'hi' && closing) {
      // „<hi>adam</hi>zní“ – formátování XML spolklo mezeru za značkou.
      final next = m.end < text.length ? text[m.end] : '';
      if (RegExp(r'[\p{L}\p{N}]', unicode: true).hasMatch(next)) {
        (noteDepth > 0 ? noteBuf : (titleDepth > 0 ? titleBuf : buf)).write(
          ' ',
        );
      }
      continue;
    }
    if (name == 'note') {
      if (selfClosing) continue;
      if (!closing) {
        if (++noteDepth == 1) noteBuf = StringBuffer();
      } else if (--noteDepth == 0 && cur != null) {
        final note = fixSpacing(cleanText(noteBuf.toString()));
        if (note.isNotEmpty) {
          footnotes.add((
            bookId: cur!.bookId,
            chapter: cur!.chapter,
            verse: cur!.verse,
            text: note,
          ));
        }
      }
      continue;
    }
    if (noteDepth > 0) continue;
    if (name == 'title') {
      if (selfClosing) continue;
      if (!closing) {
        if (++titleDepth == 1) {
          titleBuf = StringBuffer();
          titleSkip = _skipTitleTypes.contains(attrs['type']);
        }
      } else if (--titleDepth == 0 && !titleSkip) {
        final title = cleanText(titleBuf.toString());
        if (title.isNotEmpty) pendingTitles.add(title);
      }
      continue;
    }
    if (titleDepth > 0) continue;
    switch (name) {
      case 'verse':
        if (closing || attrs.containsKey('eID')) {
          end();
        } else if (attrs['osisID'] case final id?) {
          end();
          start(id);
        }
      case 'p' || 'lg':
        if (!closing && !selfClosing) {
          if (name == 'lg') lgDepth++;
          paraPending = true;
        } else if (closing) {
          if (name == 'lg' && lgDepth > 0) lgDepth--;
          paraPending = true;
          if (cur != null) buf.write('\n');
        }
      case 'l':
        if (closing && cur != null) buf.write('\n');
      case 'lb':
        if (cur != null) buf.write('\n');
      case 'chapter' || 'div':
        if (closing || selfClosing) paraPending = true;
    }
  }
  end();
  return _finish(verses, headings, footnotes);
}

// --- Zefania XML -----------------------------------------------------------------

/// Zefania XML: `<BIBLEBOOK bnumber><CHAPTER cnumber><VERS vnumber>`.
Future<ParsedTranslation> parseZefania(String text) async {
  final verses = <ParsedVerse>[];
  int? book;
  int? chapter;
  ParsedVerse? cur;
  var buf = StringBuffer();
  var skipDepth = 0; // NOTE, ...
  var count = 0;

  for (final m in _token.allMatches(text)) {
    if (++count % _yieldEvery == 0) await Future<void>.delayed(Duration.zero);
    final tok = m[0]!;
    if (!tok.startsWith('<')) {
      if (cur != null && skipDepth == 0) {
        buf.write(_unescape(tok).replaceAll(_ws, ' '));
      }
      continue;
    }
    final t = _tag.firstMatch(tok);
    if (t == null) continue;
    final closing = t[1]!.isNotEmpty;
    final name = t[2]!.toUpperCase();
    final selfClosing = t[4]!.isNotEmpty;
    final attrs = {
      for (final a in _attr.allMatches(t[3]!)) a[1]!.toLowerCase(): a[2]!,
    };
    switch (name) {
      case 'BIBLEBOOK' when !closing:
        final n = int.tryParse(attrs['bnumber'] ?? '');
        book = n != null && n >= 1 && n <= 66 ? n : null;
      case 'CHAPTER' when !closing:
        chapter = int.tryParse(attrs['cnumber'] ?? '');
      case 'VERS':
        if (!closing && !selfClosing) {
          final v = int.tryParse(attrs['vnumber'] ?? '');
          if (book != null && chapter != null && v != null) {
            cur = ParsedVerse(book, chapter, v, '');
            buf = StringBuffer();
          }
        } else if (closing && cur != null) {
          verses.add(cur..text = buf.toString());
          cur = null;
        }
      case 'NOTE' || 'DIV' || 'CAPTION':
        if (!selfClosing) skipDepth += closing ? -1 : 1;
    }
  }
  return _finish(verses, const [], const []);
}

// --- JSON ------------------------------------------------------------------------

/// JSON: formát scrollmapper (`books[].chapters[].verses[]`) nebo „flat“
/// (`verses: [{book, chapter, verse, text}]`).
ParsedTranslation parseJson(String text) {
  final data = jsonDecode(text);
  if (data is! Map<String, Object?>) {
    throw const TranslationFormatException('Neočekávaná struktura JSON.');
  }
  final verses = <ParsedVerse>[];
  if (data['books'] case final List<Object?> books) {
    for (final (index, b) in books.indexed) {
      final book = b! as Map<String, Object?>;
      final name = (book['name'] as String? ?? '').toLowerCase();
      final id =
          _englishToId[name] ??
          _osisToId[name] ??
          (books.length == 66 ? index + 1 : null);
      if (id == null) continue;
      for (final c in book['chapters']! as List<Object?>) {
        final chapter = c! as Map<String, Object?>;
        final ch = (chapter['chapter']! as num).toInt();
        for (final v in chapter['verses']! as List<Object?>) {
          final verse = v! as Map<String, Object?>;
          verses.add(
            ParsedVerse(
              id,
              ch,
              (verse['verse']! as num).toInt(),
              verse['text']! as String,
            ),
          );
        }
      }
    }
  } else if (data['verses'] case final List<Object?> list) {
    for (final v in list) {
      final row = v! as Map<String, Object?>;
      final b = row['book'];
      final id = b is num
          ? b.toInt()
          : _osisToId[(b as String? ?? '').toLowerCase()];
      if (id == null || id < 1 || id > 66) continue;
      verses.add(
        ParsedVerse(
          id,
          (row['chapter']! as num).toInt(),
          (row['verse']! as num).toInt(),
          row['text']! as String,
        ),
      );
    }
  } else {
    throw const TranslationFormatException('JSON neobsahuje verše.');
  }
  return _finish(verses, const [], const []);
}
