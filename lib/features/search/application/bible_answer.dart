import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/entities/study_entities.dart';
import '../../content/application/content_providers.dart';
import '../../reader/application/glossary.dart';
import '../../study/application/study_providers.dart';
import 'reference_parser.dart';
import 'scene_search.dart';
import 'thought_search.dart';

/// Odkud odpověď čerpá (téma, situace, lekce, kurz, postava, kniha).
enum AnswerSourceKind {
  topic,
  situation,
  lesson,
  course,
  person,
  book,
  note,
  scene,
  glossary,
}

/// Text aplikace, ze kterého se odpověď skládá: odstavce výkladu a verše
/// s popiskem.
@immutable
class AnswerSource {
  const AnswerSource({
    required this.kind,
    required this.id,
    required this.title,
    required this.paragraphs,
    required this.passages,
    required this.priority,
    required this.entity,
  });

  /// Téma / situace / (kurz, lekce) / kurz – pro otevření celého výkladu.
  final Object entity;

  final AnswerSourceKind kind;

  /// `téma`, `situace`, `kurz` nebo `kurz:lekce`.
  final String id;
  final String title;
  final List<String> paragraphs;
  final List<(Passage, String)> passages;

  /// Jak blízko má zdroj k otázce (1 = přímo k ní).
  final double priority;
}

/// Věta výkladu vybraná do odpovědi.
@immutable
class AnswerSentence {
  const AnswerSentence(this.text, this.source);

  final String text;
  final AnswerSource source;
}

/// Verš vybraný do odpovědi a proč (popisek z tématu/lekce).
@immutable
class AnswerVerse {
  const AnswerVerse(this.passage, this.label, this.text);

  final Passage passage;
  final String label;
  final String text;
}

/// Odpověď složená k otázce: krátký výklad z vět, které k otázce sedí
/// nejvíc, verše z Bible a kde číst dál.
@immutable
class BibleAnswer {
  const BibleAnswer({
    required this.question,
    required this.sentences,
    required this.verses,
    required this.sources,
  });

  final String question;
  final List<AnswerSentence> sentences;
  final List<AnswerVerse> verses;
  final List<AnswerSource> sources;
}

final _anaphoric = RegExp(
  r'^(To|Ten|Ta|Tím|Toho|Tomu|Tak|Takže|Proto|Ale|A|Také|Též|Týká|Je|Jsou|'
  r'Má|Mají|Roste|Dává|Ona|On|Oni|Tento|Tato|Toto|Tyto|Takový|Taková|Každý den|Jeho|Její|Jejich|Zde|Tady|Tehdy|Mluví|Říká|Ukazuje|Učí|Nazývá|Popisuje|Bere|Vidí|Zve|Vede|Nese|Dělá|Stojí|Znamená)(?=[\s,])',
);

/// Zkratky, za kterými věta nekončí („př. Kr.“, „např. Jób“).
const _abbrevs = [
  'př. Kr.',
  'po Kr.',
  'např.',
  'tzv.',
  'tj.',
  'sv.',
  'kap.',
  'r.',
  'stol.',
];

String _protect(String t) {
  // „1. Samuelova“, „2. Petrův“: číslo knihy, ne konec věty.
  var r = t.replaceAllMapped(
    RegExp(r'\b([1-3])\. (?=[A-ZÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ])'),
    (m) => '${m[1]}\u2024\u00a0',
  );
  for (final a in _abbrevs) {
    r = r.replaceAll(a, a.replaceAll('.', '\u2024').replaceAll(' ', '\u00a0'));
  }
  return r;
}

String _unprotect(String t) =>
    t.replaceAll('\u2024', '.').replaceAll('\u00a0', ' ');

/// Skrytá slova pro hledání (⟨…⟩) se v odpovědi nezobrazují.
String _visible(String t) => t.replaceAll(RegExp(r'⟨[^⟩]*⟩'), '');

final _sentenceEnd = RegExp(r'(?<=[.!?…])\s+(?=[A-ZÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ„])');

/// Vyskládá odpověď na [query] ze [sources]. [verseText] dává text verše
/// (podle překladu), aby se verše daly porovnat s otázkou.
///
/// Nic se nevymýšlí: věty jsou z výkladů aplikace a verše z Bible.
/// Přizpůsobí se ale otázce – vybere věty a verše, které obsahují
/// nejvíc jejích slov (vzácná slova váží víc), a zachová pestrost zdrojů.
BibleAnswer? composeAnswer({
  required String query,
  required String question,
  required List<AnswerSource> sources,
  required String Function(Passage) verseText,
  int maxSentences = 3,
  int maxVerses = 4,
}) {
  if (sources.isEmpty) return null;
  final q = meaningStems(query).toList();

  // Věty ze všech zdrojů a jejich kmeny.
  final sentences = <(String, AnswerSource, Set<String>, int, bool)>[];
  for (final s in sources) {
    var pos = 0;
    for (final p in s.paragraphs) {
      var first = true;
      for (final t in _protect(p).split(_sentenceEnd)) {
        final text = _unprotect(t.trim());
        if (text.length < 25) continue;
        // Věta, která sama obstojí: první v odstavci a nezačíná odkazem
        // na předchozí („To…“, „Proto…“, „Týká se…“).
        final standalone = first && !_anaphoric.hasMatch(text);
        sentences.add((text, s, meaningStems(text), pos++, standalone));
        first = false;
      }
    }
  }
  // Vzácnost slova mezi kandidáty: „zlo“ v textu o zlu rozhoduje víc
  // než „Bůh“, které je skoro všude.
  double idf(String stem, Iterable<Set<String>> docs) {
    var df = 0, n = 0;
    for (final d in docs) {
      n++;
      if (d.any((s) => stemMatch(stem, s) > 0)) df++;
    }
    return math.log(1 + (n + 1) / (df + 1));
  }

  final sentIdf = {for (final w in q) w: idf(w, sentences.map((s) => s.$3))};
  double overlap(Set<String> stems, Map<String, double> weights) {
    var sum = 0.0;
    for (final w in q) {
      var best = 0.0;
      for (final s in stems) {
        best = math.max(best, stemMatch(w, s));
        if (best == 1) break;
      }
      sum += best * (weights[w] ?? 1);
    }
    return sum;
  }

  final scored = [
    for (final (text, src, stems, pos, standalone) in sentences)
      (
        text,
        src,
        pos,
        overlap(stems, sentIdf),
        overlap(stems, sentIdf) +
            (standalone ? 0.5 : 0) +
            src.priority * 1.6 -
            // Úvodní věty výkladu bývají nejsrozumitelnější.
            math.min(pos, 6) * 0.06,
      ),
  ]..sort((a, b) => b.$5.compareTo(a.$5));

  final picked = <AnswerSentence>[];
  var firstPos = -1;
  final perSource = <AnswerSource, int>{};
  for (final (text, src, pos, relevance, _) in scored) {
    if (picked.length >= maxSentences) break;
    // Věta navazující na předchozí („Týká se všech…“) bez ní nedává smysl.
    if (_anaphoric.hasMatch(text)) continue;
    // První věta může být úvodem nejbližšího zdroje, další už musí
    // s otázkou opravdu souviset.
    if (picked.isNotEmpty &&
        relevance <= 0 &&
        !(picked.length == 1 &&
            src == picked.first.source &&
            pos == firstPos + 1)) {
      continue;
    }
    if ((perSource[src] ?? 0) >= 2) continue;
    // Ne dvě skoro stejné věty.
    final stems = meaningStems(text);
    if (picked.any((p) {
      final o = meaningStems(p.text).intersection(stems).length;
      return o > stems.length * 0.6;
    })) {
      continue;
    }
    if (picked.isEmpty) firstPos = pos;
    picked.add(AnswerSentence(_visible(text), src));
    perSource[src] = (perSource[src] ?? 0) + 1;
  }

  // Verše: popisek i text verše porovnat s otázkou.
  final candidates = <(Passage, String, AnswerSource)>[];
  final seen = <Passage>{};
  for (final s in sources) {
    for (final (p, label) in s.passages) {
      if (seen.add(p)) candidates.add((p, label, s));
    }
  }
  final verseStems = {
    for (final (p, label, _) in candidates)
      p: {...meaningStems(label), ...meaningStems(verseText(p))},
  };
  final verseIdf = {for (final w in q) w: idf(w, verseStems.values)};
  final rankedVerses = [
    for (final (i, (p, label, src)) in candidates.indexed)
      (
        p,
        label,
        overlap(verseStems[p]!, verseIdf) +
            src.priority * 1.2 -
            // Pořadí ve zdroji: autoři dávají nejdůležitější místa dopředu.
            math.min(i, 12) * 0.03,
      ),
  ]..sort((a, b) => b.$3.compareTo(a.$3));
  final verses = <AnswerVerse>[];
  final books = <int, int>{};
  for (final (p, label, _) in rankedVerses) {
    if (verses.length >= maxVerses) break;
    if ((books[p.bookId] ?? 0) >= 1 && rankedVerses.length > maxVerses * 2) {
      continue;
    }
    final text = verseText(p);
    if (text.isEmpty) continue;
    verses.add(AnswerVerse(p, label, text));
    books[p.bookId] = (books[p.bookId] ?? 0) + 1;
  }

  if (picked.isEmpty && verses.isEmpty) return null;
  return BibleAnswer(
    question: question,
    sentences: picked,
    verses: verses,
    sources: sources,
  );
}

/// Vypadá dotaz jako otázka („proč…“, „jak…“, „co je…“, „…?“)?
bool looksLikeQuestion(String text) {
  final t = foldCzech(text.trim());
  if (t.endsWith('?')) return true;
  return RegExp(
    r'^(proc|jak|jaky|jaka|jake|jakou|jakym|co|kdo|koho|komu|kde|kdy|kam|'
    r'odkud|cim|ceho|kolik|ktery|ktera|ktere|kterou|existuje|existujou|'
    r'je|jsou|muze|muzu|smi|smim|plati|opravdu|skutecne|'
    r'potrebuju|potrebuji)\b',
  ).hasMatch(t);
}

final _tokenSplit = RegExp(r'[^a-z0-9]+');

List<String> _queryTokens(String text) => [
  for (final w in foldCzech(text).split(_tokenSplit))
    if (w.isNotEmpty) w,
];

/// Odpovídá slovo dotazu jménu (i v jiném pádě: „Mojžíše“, „Pavlovi“,
/// „Jóbovi“)?
bool _nameMatches(String token, String name) {
  if (name.length < 3) return token == name;
  final forms = {
    name,
    // Pavel → Pavla, Samuel → Samuela: e mizí před koncovkou.
    if (RegExp(r'e[lrnk]$').hasMatch(name) && name.length >= 5)
      '${name.substring(0, name.length - 2)}${name[name.length - 1]}',
    // Jidáš → Jidáše, Mojžíš → Mojžíše; Marie → Marii.
    if (name.endsWith('e') && name.length >= 4)
      name.substring(0, name.length - 1),
  };
  for (final f in forms) {
    if (token == f) return true;
    if (token.startsWith(f) && token.length - f.length <= 4) {
      final rest = token.substring(f.length);
      // Koncovky pádů a přivlastnění, ne jiné slovo („Eva“ ≠ „evangelium“).
      if (RegExp(
        r'^(a|e|i|u|y|o|ovi|em|ou|ou|ova|ovo|ovy|uv|ovu|ove|'
        r'ovych|ovym|ech|um|ami|ich|im)$',
      ).hasMatch(rest)) {
        return true;
      }
    }
  }
  return false;
}

/// Postava, o které se dotaz ptá (nejdelší shoda jména vyhrává: „Jan
/// Křtitel“ před „Jan“).
BiblePerson? findPerson(String text, List<BiblePerson> people) {
  final tokens = _queryTokens(text);
  BiblePerson? best;
  var bestLen = 0;
  var bestPos = 1 << 20;
  for (final p in people) {
    final parts = [
      for (final w in foldCzech(p.name).split(_tokenSplit))
        if (w.length >= 2) w,
    ];
    if (parts.isEmpty) continue;
    final pos = tokens.indexWhere((t) => _nameMatches(t, parts.first));
    if (pos < 0) continue;
    final extra = parts
        .skip(1)
        .where((w) => tokens.any((t) => _nameMatches(t, w)));
    final len = parts.first.length + extra.fold<int>(0, (a, w) => a + w.length);
    // Kdo je v dotazu dřív, je podmět („proč Jidáš zradil Ježíše“).
    if (pos < bestPos || (pos == bestPos && len > bestLen)) {
      best = p;
      bestLen = len;
      bestPos = pos;
    }
  }
  return best;
}

const _bookWords = {
  'kniha',
  'knihy',
  'knize',
  'knihu',
  'knihou',
  'list',
  'listu',
  'listy',
  'evangelium',
  'evangelia',
  'evangeliu',
  'epistola',
};

/// Kniha, na kterou se dotaz ptá („o čem je kniha Rút“, „kdo napsal
/// Římanům“). Vrací (id knihy, zda je v dotazu slovo „kniha/list…“).
(int, bool)? findBook(String text, List<Book> books) {
  final tokens = _queryTokens(text);
  final explicit = tokens.any(_bookWords.contains);
  final digits = tokens.where((t) => RegExp(r'^[1-3]$').hasMatch(t)).toSet();
  int? best;
  var bestLen = 0;
  for (final b in books) {
    final words = [
      for (final w in foldCzech(b.name).split(_tokenSplit))
        if (w.isNotEmpty) w,
    ];
    final number = words.isNotEmpty && RegExp(r'^[1-3]$').hasMatch(words.first)
        ? words.first
        : null;
    final names = [
      for (final w in words)
        if (!RegExp(r'^[0-9]+$').hasMatch(w) && w != 'apostolu') w,
    ];
    if (names.isEmpty) continue;
    final all = names.every((w) => tokens.any((t) => _nameMatches(t, w)));
    // „Zjevení“ stačí i bez „Janovo“, „Skutky“ bez „apoštolů“.
    final firstOnly =
        !all &&
        names.length > 1 &&
        names.first.length >= 5 &&
        tokens.any((t) => _nameMatches(t, names.first));
    if (!all && !firstOnly) continue;
    if (number != null && digits.isNotEmpty && !digits.contains(number)) {
      continue;
    }
    final len = names.fold<int>(0, (a, w) => a + w.length);
    if (len > bestLen) {
      best = b.id;
      bestLen = len;
    }
  }
  return best == null ? null : (best, explicit);
}

AnswerSource personSource(BiblePerson p, double priority) => AnswerSource(
  kind: AnswerSourceKind.person,
  id: p.id,
  title: p.name,
  entity: p,
  priority: priority,
  paragraphs: [
    '${p.name}⟨kdo byl⟩ – ${p.role}.',
    if (p.where.isNotEmpty) 'Kde žil a působil: ${p.where}.',
    if (p.occupation.isNotEmpty)
      'Povolání⟨čím se živil zabýval práce⟩: ${p.occupation}.',
    if (p.relatives.isNotEmpty)
      'Rodina⟨příbuzní otec matka rodiče sourozenci bratr sestra manželka manžel syn dcera děti⟩: ${p.relatives}.',
    for (final s in p.strengths) 'Silná stránka⟨úspěch⟩: $s.',
    for (final s in p.weaknesses) 'Slabá stránka⟨chyba selhání hřích⟩: $s.',
    for (final s in p.lessons) 'Poučení pro nás: $s',
  ].map((t) => t.replaceAll('..', '.')).toList(),
  passages: [
    (p.key, 'Klíčové místo'),
    for (final st in p.story) (st, 'Příběh'),
  ],
);

AnswerSource bookSource(Book b, BookIntro i, double priority) {
  final keys = <(Passage, String)>[];
  for (final k in i.keyVerses) {
    final m = RegExp(r'^(\d+):(\d+)(?:-(\d+))?$').firstMatch(k.trim());
    if (m == null) continue;
    final v = int.parse(m[2]!);
    keys.add((
      Passage(b.id, int.parse(m[1]!), v, int.tryParse(m[3] ?? '') ?? v),
      'Klíčový verš',
    ));
  }
  return AnswerSource(
    kind: AnswerSourceKind.book,
    id: '${b.id}',
    title: b.name,
    entity: (b.id, i),
    priority: priority,
    paragraphs: [
      'O čem je kniha ${b.name}: ${i.theme}',
      i.summary,
      if (i.author.isNotEmpty) 'Autor⟨kdo napsal⟩: ${i.author}.',
      if (i.date.isNotEmpty) 'Doba vzniku⟨kdy vznikla napsána⟩: ${i.date}.',
      if (i.recipients.isNotEmpty)
        'Pro koho⟨komu určena napsána adresáti⟩: ${i.recipients}',
      if (i.purpose.isNotEmpty) 'Proč vznikla⟨účel smysl⟩: ${i.purpose}',
      if (i.setting.isNotEmpty) i.setting,
      if (i.background.isNotEmpty) i.background,
      for (final t in i.themes) '${t.title}: ${t.text}',
      if (i.connection.isNotEmpty) i.connection,
      if (i.howToRead.isNotEmpty) 'Jak ji číst: ${i.howToRead}',
    ].map((t) => t.replaceAll('..', '.')).toList(),
    passages: keys,
  );
}

/// Zdroje odpovědi: cíle nalezené velké otázky ([question]) a témata
/// a situace rozpoznaných pojmů ([concepts]).
List<AnswerSource> answerSources({
  required String text,
  required BigQuestion? question,
  required List<ThoughtConcept> concepts,
  required List<BibleTopic> topics,
  required List<Situation> situations,
  required List<StudyCourse> courses,
}) {
  final sources = <AnswerSource>[];
  if (question == null && concepts.isEmpty) return const [];
  // U pocitů („jsem na dně“) odpovídáme jen tehdy, když je to otázka
  // nebo přímo sedí některá z velkých otázek.
  if (question == null && !looksLikeQuestion(text)) return const [];

  final ids = <String>{};
  void add(String target, double priority) {
    if (!ids.add(target)) return;
    final kind = target.substring(0, 1);
    final id = target.substring(2);
    switch (kind) {
      case 't':
        for (final t in topics.where((t) => t.id == id)) {
          sources.add(
            AnswerSource(
              kind: AnswerSourceKind.topic,
              entity: t,
              id: t.id,
              title: t.title,
              paragraphs: [t.summary, ...t.deeper],
              passages: [
                for (var i = 0; i < t.passages.length; i++)
                  (t.passages[i], t.labels[i]),
              ],
              priority: priority,
            ),
          );
        }
      case 's':
        for (final s in situations.where((s) => s.id == id)) {
          sources.add(
            AnswerSource(
              kind: AnswerSourceKind.situation,
              entity: s,
              id: s.id,
              title: s.title,
              paragraphs: [s.intro, ...s.thoughts],
              passages: [for (final p in s.passages) (p, s.title)],
              priority: priority,
            ),
          );
        }
      case 'l':
        final [cid, n] = id.split(':');
        for (final c in courses.where((c) => c.id == cid)) {
          final l = c.lessons[int.parse(n)];
          sources.add(
            AnswerSource(
              kind: AnswerSourceKind.lesson,
              entity: (c, l),
              id: id,
              title: l.title,
              paragraphs: l.text,
              passages: [
                for (var i = 0; i < l.passages.length; i++)
                  (l.passages[i], l.labels[i]),
              ],
              priority: priority,
            ),
          );
        }
      case 'c':
        for (final c in courses.where((c) => c.id == id)) {
          sources.add(
            AnswerSource(
              kind: AnswerSourceKind.course,
              entity: c,
              id: c.id,
              title: c.title,
              paragraphs: [c.intro, ...c.lessons.first.text],
              passages: [
                for (final l in c.lessons.take(3))
                  for (var i = 0; i < l.passages.length; i++)
                    (l.passages[i], l.labels[i]),
              ],
              priority: priority,
            ),
          );
        }
    }
  }

  if (question != null) {
    for (final (i, t) in question.targets.indexed) {
      add(t, 1 - i * 0.12);
    }
  }
  // Velká otázka má vybrané zdroje; pojmy by přidaly šum („stát se
  // křesťanem“ ≠ stát a politika).
  for (final c
      in question == null ? concepts.take(4) : const <ThoughtConcept>[]) {
    for (final link in c.links) {
      if (link.startsWith('t:') || link.startsWith('s:')) {
        add(link, question == null ? 0.8 : 0.4);
      }
    }
  }
  return sources;
}

/// Velká otázka, na kterou se dotaz ptá. U dotazu, který nevypadá jako
/// otázka („smysl života“), musí sedět skoro všechna slova – pocit jako
/// „mám radost“ nemá dostat výklad.
BigQuestion? pickQuestion(StemIndex<BigQuestion> index, String text) =>
    pickQuestionHit(index, text)?.item;

/// Jako [pickQuestion], i s tím, jak dobře otázka sedí.
StemHit<BigQuestion>? pickQuestionHit(
  StemIndex<BigQuestion> index,
  String text,
) {
  final m = index
      .search(text, limit: 2)
      // Krizová otázka jen přes jednoznačné fráze (viz _crisis).
      .where((h) => h.item.title != crisisQuestion)
      .toList();
  if (m.isEmpty) return null;
  final words = meaningStems(text).length;
  if (m.first.coverage < 0.6) return null;
  if (!looksLikeQuestion(text) && (words < 2 || m.first.coverage < 0.8)) {
    return null;
  }
  return m.first;
}

/// Rámec „co Bible říká o…“, „podle Bible“ nic neurčuje – jinak by
/// každá taková otázka vedla na téma Boží slovo.
String stripBibleFrame(String text) => text
    .replaceAll(
      RegExp(
        r'(co|jak)\s+(ne)?(říká|rika|píše|pise|učí|uci|mluví|mluvi)\s+'
        r'(bible|bibli|písmo|pismo)(\s+o|\s+na)?\s+|'
        r'(co|jak)\s+(bible|písmo|pismo)\s+(ne)?(říká|rika|píše|pise|učí|'
        r'uci|mluví|mluvi)(\s+o|\s+na)?\s+|podle\s+bible|v\s+bibli',
        caseSensitive: false,
      ),
      ' ',
    )
    .trim();

final _factual = RegExp(
  r'^(kdo|kde|kdy|kolik|ktery|ktera|ktere|kterou|jak se jmenoval|'
  r'jak se jmenovala|co udelal|co udelala|co se stalo|kam|odkud|cim)\b',
);

const crisisQuestion = 'Co když už nechci žít?';

final _crisis = RegExp(
  r'(nechci|nechce se mi|uz nechci) (uz )?(zit|byt nazivu)|chci umrit|'
  r'sebevra|zabit se|zabiju se|skoncit (se )?(se )?(vsim|zivot)',
);

final _defining = RegExp(
  r'^(co je|co jsou|co byl|co byla|co bylo|co byli|kdo byl|kdo byli|'
  r'kdo jsou|co znamena|co to je|co je to)\b',
);

/// Celý plán odpovědi: nadpis a zdroje, ze kterých se skládá.
///
/// Pořadí přesnosti: věcná otázka na příběh („kdo zabil Goliáše“) →
/// pojem ze slovníčku („kdo byli farizeové“) → vlastní výklad otázky
/// → postava či kniha → velká otázka → rozpoznané pojmy.
({String title, List<AnswerSource> sources})? planAnswer({
  required String text,
  required StemIndex<BigQuestion> questions,
  required ConceptLexicon lexicon,
  required StemIndex<BibleScene> scenes,
  required List<BibleTopic> topics,
  required List<Situation> situations,
  required List<StudyCourse> courses,
  required List<BiblePerson> people,
  required List<Book> books,
  required Map<int, BookIntro> intros,
}) {
  final t = stripBibleFrame(text);
  if (t.isEmpty) return null;
  final folded = foldCzech(t);
  final isQuestion = looksLikeQuestion(text);
  final questionHit = pickQuestionHit(questions, t);
  var question = questionHit?.item;
  final person = findPerson(t, people);
  final book = findBook(t, books);

  // Ptá-li se dotaz na konkrétní postavu či knihu, obecná otázka platí
  // jen tehdy, když o ní mluví („Kdo byl apoštol Pavel?“), jinak by
  // „otec Jana Křtitele“ vedl na Trojici.
  if (question != null && (person != null || book != null)) {
    final names = {
      if (person != null) ...meaningStems(person.name),
      if (book != null) ...meaningStems(books[book.$1 - 1].name),
    };
    final q = question;
    if (names.isNotEmpty &&
        !names.any((n) => q.stems.any((s) => stemMatch(n, s) > 0))) {
      question = null;
    }
  }

  final sources = <AnswerSource>[];

  // Věcná otázka na příběh: odpověď je přímo verš příběhu.
  // Krize: jednoznačné fráze vždy vedou na odpověď s linkami pomoci.
  if (_crisis.hasMatch(folded)) {
    question =
        questions.items.where((q) => q.title == crisisQuestion).firstOrNull ??
        question;
  }

  // Věcná otázka na příběh, ne jen jméno („kdo byl Mojžíš“ je otázka na
  // postavu, „kdo zabil Goliáše“ na příběh).
  final nameStems = {
    if (person != null) ...meaningStems(person.name),
    if (book != null) ...meaningStems(books[book.$1 - 1].name),
  };
  final otherWords = meaningStems(t)
      .where((w) => !nameStems.any((n) => stemMatch(w, n) > 0));
  final scene = scenes.search(t, limit: 1);
  // Když dotaz jmenuje postavu, musí ji obsahovat i příběh („kdy žil
  // David“ ≠ Metuzalém, který „žil nejdéle“).
  final sceneFits =
      scene.isNotEmpty &&
      (nameStems.isEmpty ||
          nameStems.any(
            (n) => scene.first.item.stems.any((s) => stemMatch(n, s) > 0),
          ));
  if (otherWords.isNotEmpty &&
      sceneFits &&
      ((_factual.hasMatch(folded) && scene.first.coverage >= 0.6) ||
          (isQuestion && question == null && scene.first.coverage >= 0.85))) {
    final sc = scene.first.item;
    final b = books.length >= sc.passage.bookId
        ? books[sc.passage.bookId - 1].name
        : '';
    sources.add(
      AnswerSource(
        kind: AnswerSourceKind.scene,
        id: sc.title,
        title: sc.title,
        entity: sc,
        priority: 1.4,
        paragraphs: [
          'Odpověď najdete v příběhu „${sc.title}“ '
              '(${sc.passage.label(b)}).',
        ],
        passages: [(sc.passage, sc.title)],
      ),
    );
  }

  // Věcná otázka na příběh: obecná otázka jen tehdy, když sedí úplně
  // („nejmoudřejší král“ ≠ „Co je Boží království?“).
  if (sources.isNotEmpty &&
      question != null &&
      question.text.isEmpty &&
      (questionHit?.coverage ?? 0) < 0.95) {
    question = null;
  }

  // Pojem ze slovníčku: farizeové, denár, sabat…
  final words = meaningStems(t).length;
  if (_defining.hasMatch(folded) || (question == null && words <= 2)) {
    for (final e in glossaryFor(t, bookId: 40).take(2)) {
      sources.add(
        AnswerSource(
          kind: AnswerSourceKind.glossary,
          id: e.title,
          title: e.title,
          entity: e,
          priority: 1.3,
          paragraphs: ['${e.title}: ${e.text}'],
          passages: const [],
        ),
      );
    }
  }

  // Vlastní výklad otázky (alkohol, šikana…).
  if (question != null && question.text.isNotEmpty) {
    sources.add(
      AnswerSource(
        kind: AnswerSourceKind.note,
        id: question.title,
        title: question.title,
        entity: question,
        priority: 1.25,
        paragraphs: question.text,
        passages: question.read,
      ),
    );
  }

  // Postava nebo kniha.
  final bookFirst =
      book != null && (book.$2 || person == null) && intros[book.$1] != null;
  final top = question == null ? 1.0 : 0.5;
  if (bookFirst) {
    sources.add(bookSource(books[book.$1 - 1], intros[book.$1]!, top));
  }
  if (person != null) {
    sources.add(personSource(person, bookFirst ? top * 0.6 : top));
  }

  if (question != null || (sources.isEmpty && isQuestion)) {
    sources.addAll(
      answerSources(
        text: t,
        question: question,
        concepts: lexicon.detect(t),
        topics: topics,
        situations: situations,
        courses: courses,
      ),
    );
  }
  if (sources.isEmpty) return null;

  final first = sources.first;
  final title =
      (first.kind == AnswerSourceKind.scene ? null : question?.title) ??
      (isQuestion
          ? _asQuestion(text)
          : switch (first.kind) {
              AnswerSourceKind.person => 'Kdo byl ${first.title}?',
              AnswerSourceKind.book => 'O čem je kniha ${first.title}?',
              AnswerSourceKind.glossary => 'Co je ${first.title}?',
              _ => _asQuestion(text),
            });
  return (title: title, sources: sources);
}

typedef AnswerQuery = ({String text, String translationId});

/// Odpověď z Bible na otázku či myšlenku: zdroje z rejstříku velkých
/// otázek a z rozpoznaných pojmů, z nich se vybere, co sedí nejvíc.
final bibleAnswerProvider = FutureProvider.autoDispose
    .family<BibleAnswer?, AnswerQuery>((ref, q) async {
      final questions = await ref.watch(questionIndexProvider.future);
      final lexicon = await ref.watch(conceptLexiconProvider.future);
      final (_, topics) = await ref.watch(topicsProvider.future);
      final (_, situations) = await ref.watch(situationsProvider.future);
      final courses = await ref.watch(coursesProvider.future);

      final people = await ref.watch(peopleProvider.future);
      final intros = await ref.watch(bookIntrosProvider.future);
      final scenes = await ref.watch(sceneIndexProvider.future);
      final books = ref.watch(booksProvider);
      final plan = planAnswer(
        text: q.text,
        questions: questions,
        lexicon: lexicon,
        scenes: scenes,
        topics: topics,
        situations: situations,
        courses: courses,
        people: people,
        books: books,
        intros: intros,
      );
      if (plan == null) return null;
      final sources = plan.sources;
      if (sources.isEmpty) return null;

      // Texty kandidátních veršů v hlavním překladu.
      final texts = <Passage, String>{};
      final all = {
        for (final s in sources)
          for (final (p, _) in s.passages) p,
      };
      await Future.wait([
        for (final p in all)
          ref
              .watch(passageTextProvider((q.translationId, p)).future)
              .then(
                (vs) => texts[p] = vs
                    .take(4)
                    .map((v) => v.text.replaceAll('\n', ' '))
                    .join(' '),
              ),
      ]);

      return composeAnswer(
        query: stripBibleFrame(q.text),
        question: plan.title,
        sources: sources,
        verseText: (p) => texts[p] ?? '',
      );
    });

String _asQuestion(String text) {
  var t = text.trim();
  if (t.isEmpty) return t;
  t = t[0].toUpperCase() + t.substring(1);
  return t.endsWith('?') ? t : '$t?';
}
