import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reference_parser.dart';

/// Druh výsledku chytrého hledání v aplikaci.
enum AppHitKind {
  feature('Funkce aplikace', 'Funkce'),
  map('Místa na mapě', 'Mapa'),
  route('Tematické mapy', 'Trasa'),
  cityPlan('Plány měst a staveb', 'Plán stavby'),
  readingPlan('Plány čtení', 'Plán čtení'),
  course('Studijní kurzy', 'Kurz'),
  lesson('Lekce kurzů', 'Lekce'),
  topic('Biblická témata', 'Téma'),
  situation('Verše do situací', 'Situace'),
  person('Biblické postavy', 'Postava'),
  intro('Úvody ke knihám', 'Úvod ke knize'),
  story('Příběhy a období', 'Příběh'),
  thread('Červené nitě', 'Nit'),
  timeline('Časová osa', 'Časová osa'),
  table('Tabulky a přehledy', 'Tabulka'),
  appNote('Aplikační poznámky', 'Poznámka'),
  harmony('Harmonie evangelií', 'Harmonie'),
  church('Církevní rok', 'Církevní rok'),
  reflection('Zamyšlení ke kapitolám', 'Zamyšlení'),
  inlineNote('Poznámky v textu', 'Poznámka v textu');

  const AppHitKind(this.group, this.label);

  /// Nadpis skupiny výsledků.
  final String group;

  /// Krátký štítek u výsledku.
  final String label;
}

/// Jedna položka indexu: co se zobrazí a kde se hledá.
class AppSearchItem {
  AppSearchItem({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.open,
    String keywords = '',
    String body = '',
    this.color,
    this.boost = 1,
  }) : titleFolded = foldCzech(title),
       _title = _stems(title),
       _keys = _stems(keywords),
       _body = _stems(body);

  final AppHitKind kind;
  final String title;
  final String subtitle;
  final IconData icon;
  final int? color;

  /// Násobek skóre (důležité funkce a hlavní obsah výš).
  final double boost;
  final void Function(BuildContext context, WidgetRef ref) open;

  final String titleFolded;
  final Set<String> _title;
  final Set<String> _keys;
  final Set<String> _body;
}

/// Výsledek: položka a skóre.
typedef AppHit = ({AppSearchItem item, double score});

// --- Zpracování textu ----------------------------------------------------------

/// Slova, která nic nehledají („chci najít mapu Jeruzaléma“).
const _stopwords = {
  'a',
  'i',
  'o',
  'u',
  'v',
  've',
  'na',
  'se',
  'si',
  'je',
  'to',
  'k',
  'ke',
  's',
  'z',
  'ze',
  'do',
  'od',
  'po',
  'pro',
  'pri',
  'za',
  'nad',
  'pod',
  'jak',
  'co',
  'kde',
  'kdo',
  'ktery',
  'ktera',
  'ktere',
  'nebo',
  'ani',
  'chci',
  'chtel',
  'chtela',
  'najdi',
  'najit',
  'hledam',
  'hledat',
  'ukaz',
  'ukazat',
  'mi',
  'me',
  'mne',
  'muj',
  'moje',
  'neco',
  'nejake',
  'nejaky',
  'nejaka',
  'about',
  'the',
  'of',
  'bible',
  'biblicke',
  'biblicky',
  'biblicka',
  'biblickych',
  'otevri',
  'otevrit',
  'zobraz',
  'byl',
  'byla',
  'bylo',
  'jsou',
  'jsem',
  'jako',
  'aby',
  'kdyz',
  'jen',
  'tak',
  'tam',
  'tu',
};

/// Koncovky pro hrubé „odstranění pádu“ (fold bez diakritiky).
const _endings = [
  'ovych',
  'ovymi',
  'ovou',
  'ovym',
  'ove',
  'ovi',
  'ova',
  'ovo',
  'ovy',
  'ami',
  'emi',
  'ach',
  'ich',
  'ych',
  'ymi',
  'ech',
  'ich',
  'eho',
  'emu',
  'ou',
  'um',
  'am',
  'em',
  'ym',
  'im',
  'es',
  'a',
  'e',
  'i',
  'y',
  'u',
  'o',
];

/// Kmen slova: bez diakritiky, malými písmeny, bez běžné koncovky.
String stemCzech(String folded) {
  var w = folded;
  for (final e in _endings) {
    if (w.length - e.length >= (e.length == 1 ? 3 : 4) && w.endsWith(e)) {
      w = w.substring(0, w.length - e.length);
      break;
    }
  }
  return w;
}

final _split = RegExp(r'[^a-z0-9]+');

List<String> _words(String text) => [
  for (final w in foldCzech(text).split(_split))
    if (w.length >= 2) w,
];

Set<String> _stems(String text) => {for (final w in _words(text)) stemCzech(w)};

/// Slova dotazu (bez výplňových slov), jako kmeny.
List<String> queryStems(String query) => [
  for (final w in _words(query))
    if (!_stopwords.contains(w)) stemCzech(w),
];

/// Levenshtein ≤ 1 (překlep: jedno písmeno navíc, chybí, nebo jiné).
bool oneEdit(String a, String b) {
  if ((a.length - b.length).abs() > 1) return false;
  var i = 0, j = 0, edits = 0;
  while (i < a.length && j < b.length) {
    if (a[i] == b[j]) {
      i++;
      j++;
      continue;
    }
    if (++edits > 1) return false;
    if (a.length > b.length) {
      i++;
    } else if (b.length > a.length) {
      j++;
    } else {
      i++;
      j++;
    }
  }
  return edits + (a.length - i) + (b.length - j) <= 1;
}

/// Jak dobře slovo dotazu [q] sedí na množinu kmenů: 1 = přesně,
/// 0.75 = začátek slova, 0.55 = překlep, 0 = nic.
double _matchIn(String q, Set<String> words, {bool fuzzy = true}) {
  if (words.contains(q)) return 1;
  var best = 0.0;
  for (final w in words) {
    if (q.length >= 3 && w.startsWith(q)) {
      best = 0.75;
    } else if (w.length >= 4 && q.startsWith(w)) {
      if (best < 0.7) best = 0.7;
    } else if (fuzzy && q.length >= 5 && best < 0.55 && oneEdit(q, w)) {
      best = 0.55;
    }
    if (best >= 0.75) break;
  }
  return best;
}

// --- Záměr ---------------------------------------------------------------------

/// Slova, která říkají, co člověk hledá („mapa Jeruzaléma“ → místa na
/// mapě). Tvary se převedou na kmeny.
const _intentWords = <(List<String>, Set<AppHitKind>)>[
  (
    ['mapa', 'mapu', 'mape', 'mapy', 'map', 'mapka', 'mapku'],
    {AppHitKind.map, AppHitKind.route, AppHitKind.cityPlan},
  ),
  (['misto', 'mista', 'mist', 'lokalita'], {AppHitKind.map}),
  (['trasa', 'trasu', 'trasy'], {AppHitKind.route}),
  (
    ['plan', 'plany', 'planu', 'planem'],
    {AppHitKind.readingPlan, AppHitKind.cityPlan},
  ),
  (['kurz', 'kurzu', 'kurzy'], {AppHitKind.course, AppHitKind.lesson}),
  (['lekce', 'lekci'], {AppHitKind.lesson, AppHitKind.course}),
  (['tema', 'temata', 'tematu'], {AppHitKind.topic}),
  (['postava', 'postavu', 'postavy', 'osobnost'], {AppHitKind.person}),
  (['uvod', 'uvodu', 'uvody'], {AppHitKind.intro}),
  (['zamysleni'], {AppHitKind.reflection}),
  (
    ['poznamka', 'poznamku', 'poznamky', 'vysvetleni'],
    {AppHitKind.inlineNote, AppHitKind.appNote},
  ),
  (['tabulka', 'tabulku', 'tabulky'], {AppHitKind.table}),
  (['pribeh', 'pribehy', 'pribehu'], {AppHitKind.story}),
  (['nit', 'nite', 'niti'], {AppHitKind.thread}),
  (['situace'], {AppHitKind.situation}),
  (['svatek', 'svatky', 'svatku'], {AppHitKind.church}),
];

final Map<String, Set<AppHitKind>> _intents = {
  for (final (words, kinds) in _intentWords)
    for (final w in words) stemCzech(w): kinds,
};

/// Rozpozná záměr: (druhy výsledků, zbytek dotazu). Bez záměru `null`.
(Set<AppHitKind>, List<String>)? detectIntent(List<String> stems) {
  for (final (i, s) in stems.indexed) {
    final kinds = _intents[s];
    if (kinds != null) {
      return (kinds, [...stems.take(i), ...stems.skip(i + 1)]);
    }
  }
  return null;
}

// --- Hledání -------------------------------------------------------------------

/// Seřazené výsledky pro dotaz [query] (prázdný seznam pro krátký dotaz).
List<AppHit> searchApp(List<AppSearchItem> index, String query) {
  final all = queryStems(query);
  if (all.isEmpty) return const [];
  final intent = detectIntent(all);
  // „mapa“ samotná: funkce Mapy; „mapa Jeruzaléma“: hledat Jeruzalém
  // mezi místy (a trochu níž i jinde).
  final stems = intent == null || intent.$2.isEmpty ? all : intent.$2;
  final folded = foldCzech(query.trim());
  final hits = <AppHit>[];
  for (final item in index) {
    var score = 0.0;
    var matched = 0;
    for (final q in stems) {
      final t = _matchIn(q, item._title);
      final k = t >= 1 ? 0.0 : _matchIn(q, item._keys);
      final b = t >= 0.75 || k >= 0.75
          ? 0.0
          : _matchIn(q, item._body, fuzzy: false);
      final s = [t * 10, k * 6, b * 2.5].reduce((a, c) => a > c ? a : c);
      if (s > 0) matched++;
      score += s;
    }
    // Všechna slova musí sedět; u delšího dotazu stačí většina.
    final need = stems.length <= 2 ? stems.length : (stems.length * 0.6).ceil();
    if (matched < need || score == 0) continue;
    score = score / stems.length;
    if (item.titleFolded == folded) {
      score += 12;
    } else if (folded.length >= 4 && item.titleFolded.contains(folded)) {
      score += 6;
    }
    if (intent != null) {
      if (intent.$1.contains(item.kind)) {
        score = score * 1.8 + 4;
      } else if (intent.$2.isNotEmpty) {
        score *= 0.6;
      }
    }
    hits.add((item: item, score: score * item.boost));
  }
  hits.sort((a, b) => b.score.compareTo(a.score));
  return hits;
}
