import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/content_entities.dart';

/// Druh přípravy.
enum PrepKind {
  sermon('Kázání'),
  bibleStudy('Biblická hodina'),
  youth('Program pro mládež'),
  devotional('Zamyšlení'),
  other('Jiné');

  const PrepKind(this.label);
  final String label;
}

/// Druh bloku přípravy.
enum PrepBlockKind {
  heading('Bod'),
  note('Poznámka'),
  verse('Verš'),
  question('Otázka'),
  illustration('Ilustrace'),
  idea('Nápad');

  const PrepBlockKind(this.label);
  final String label;
}

/// Jeden blok přípravy: bod osnovy, poznámka, verš (s komentářem), otázka,
/// ilustrace nebo rychlý nápad.
@immutable
class PrepBlock {
  const PrepBlock({
    required this.id,
    required this.kind,
    this.text = '',
    this.body = '',
    this.hint = '',
    this.passage,
    this.withPrevious = false,
    this.place = PrepPlace.auto,
    this.translations = const [],
    this.parallel = false,
    this.frame,
    this.step = 0,
    this.zoom = 1,
  });

  final int id;
  final PrepBlockKind kind;

  /// Text bloku; u verše komentář, u bodu jeho název.
  final String text;

  /// U bodu osnovy: poznámky k bodu (co v něm chci říct).
  final String body;

  /// U bodu ze šablony: nápověda, co do něj patří.
  final String hint;

  /// Biblické místo (u verše) v kanonickém číslování.
  final Passage? passage;

  /// Při kázání ukázat na stejné obrazovce jako předchozí blok.
  final bool withPrevious;

  /// Kde na obrazovce kázání blok stojí (auto = podle rozvržení).
  final PrepPlace place;

  /// U verše: překlady (id); prázdné = hlavní překlad aplikace.
  final List<String> translations;

  /// U verše s více překlady: vedle sebe (jinak pod sebou).
  final bool parallel;

  /// Ručně nastavené místo a velikost na obrazovce kázání (null =
  /// automaticky podle rozvržení).
  final PrepFrame? frame;

  /// Na kolikáté klepnutí se blok na své obrazovce objeví (0 = hned).
  final int step;

  /// Velikost písma bloku při kázání (1 = běžná).
  final double zoom;

  PrepBlock copyWith({
    String? text,
    String? body,
    PrepBlockKind? kind,
    bool? withPrevious,
    PrepPlace? place,
    List<String>? translations,
    bool? parallel,
    PrepFrame? Function()? frame,
    int? step,
    double? zoom,
  }) => PrepBlock(
    id: id,
    kind: kind ?? this.kind,
    text: text ?? this.text,
    body: body ?? this.body,
    hint: hint,
    passage: passage,
    withPrevious: withPrevious ?? this.withPrevious,
    place: place ?? this.place,
    translations: translations ?? this.translations,
    parallel: parallel ?? this.parallel,
    frame: frame == null ? this.frame : frame(),
    step: step ?? this.step,
    zoom: zoom ?? this.zoom,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    if (text.isNotEmpty) 'text': text,
    if (body.isNotEmpty) 'body': body,
    if (hint.isNotEmpty) 'hint': hint,
    if (passage case final p?)
      'ref': [p.bookId, p.chapter, p.verse, p.end, p.endChapter],
    if (withPrevious) 'join': true,
    if (place != PrepPlace.auto) 'place': place.name,
    if (translations.isNotEmpty) 'tr': translations,
    if (parallel) 'par': true,
    if (frame case final f?) 'frame': f.toJson(),
    if (step != 0) 'step': step,
    if (zoom != 1) 'zoom': zoom,
  };

  static PrepBlock? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final kind = PrepBlockKind.values.asNameMap()[json['kind']];
    if (id is! int || kind == null) return null;
    final text = json['text'];
    final body = json['body'];
    final hint = json['hint'];
    final ref = json['ref'];
    Passage? passage;
    if (ref is List && ref.length >= 4 && ref.every((e) => e is int)) {
      passage = Passage.fromJson(ref);
    }
    if (kind == PrepBlockKind.verse && passage == null) return null;
    return PrepBlock(
      id: id,
      kind: kind,
      text: text is String ? text : '',
      body: body is String ? body : '',
      hint: hint is String ? hint : '',
      passage: passage,
      withPrevious: json['join'] == true,
      place: PrepPlace.values.asNameMap()[json['place']] ?? PrepPlace.auto,
      translations: [
        if (json['tr'] case final List<Object?> l)
          for (final t in l)
            if (t is String) t,
      ],
      parallel: json['par'] == true,
      frame: PrepFrame.fromJson(json['frame']),
      step: switch (json['step']) {
        final int n when n >= 0 => n,
        _ => 0,
      },
      zoom: switch (json['zoom']) {
        final num z => z.toDouble().clamp(0.4, 3.0),
        _ => 1.0,
      },
    );
  }
}

Passage? _passage(Object? ref) =>
    ref is List && ref.length >= 4 && ref.every((e) => e is int)
    ? Passage.fromJson(ref)
    : null;

/// Příprava kázání, biblické hodiny nebo programu.
@immutable
class Prep {
  const Prep({
    required this.id,
    required this.title,
    required this.kind,
    required this.updated,
    this.date,
    this.passages = const [],
    this.blocks = const [],
  });

  /// Čas vytvoření v ms – zároveň jedinečný identifikátor.
  final int id;
  final String title;
  final PrepKind kind;
  final DateTime updated;

  /// Kdy se bude kázat / konat.
  final DateTime? date;

  /// Hlavní biblické texty (kanonické číslování).
  final List<Passage> passages;
  final List<PrepBlock> blocks;

  /// První hlavní text.
  Passage? get passage => passages.firstOrNull;

  Prep copyWith({
    String? title,
    PrepKind? kind,
    DateTime? Function()? date,
    List<Passage>? passages,
    List<PrepBlock>? blocks,
  }) => Prep(
    id: id,
    title: title ?? this.title,
    kind: kind ?? this.kind,
    updated: DateTime.now(),
    date: date == null ? this.date : date(),
    passages: passages ?? this.passages,
    blocks: blocks ?? this.blocks,
  );

  /// Počet slov (poznámky, body, otázky…) – pro odhad délky.
  int get words => blocks.fold(
    title.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length,
    (n, b) =>
        n +
        '${b.text} ${b.body}'
            .split(RegExp(r'\s+'))
            .where((w) => w.isNotEmpty)
            .length,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'kind': kind.name,
    'updated': updated.millisecondsSinceEpoch,
    if (date != null) 'date': date!.millisecondsSinceEpoch,
    if (passages.isNotEmpty)
      'refs': [
        for (final p in passages)
          [p.bookId, p.chapter, p.verse, p.end, p.endChapter],
      ],
    'blocks': [for (final b in blocks) b.toJson()],
  };

  static Prep? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final title = json['title'];
    if (id is! int || title is! String) return null;
    final updated = json['updated'];
    final date = json['date'];
    final refs = json['refs'];
    final blocks = json['blocks'];
    return Prep(
      id: id,
      title: title,
      kind: PrepKind.values.asNameMap()[json['kind']] ?? PrepKind.other,
      updated: DateTime.fromMillisecondsSinceEpoch(
        updated is int ? updated : id,
      ),
      date: date is int ? DateTime.fromMillisecondsSinceEpoch(date) : null,
      passages: [
        // Starší zálohy: jeden hlavní text v 'ref'.
        if (refs is List)
          for (final r in refs) ?_passage(r)
        else
          ?_passage(json['ref']),
      ],
      blocks: [
        if (blocks is List)
          for (final b in blocks) ?PrepBlock.fromJson(b),
      ],
    );
  }
}

/// Ručně nastavený obdélník bloku na obrazovce kázání (zlomky šířky
/// a výšky plochy, 0–1).
@immutable
class PrepFrame {
  const PrepFrame(this.x, this.y, this.w, this.h);

  final double x, y, w, h;

  /// Posune / změní velikost, ale nechá rámeček celý na ploše.
  PrepFrame moved(double dx, double dy) =>
      PrepFrame((x + dx).clamp(0, 1 - w), (y + dy).clamp(0, 1 - h), w, h);

  PrepFrame resized(double dw, double dh) =>
      PrepFrame(x, y, (w + dw).clamp(0.12, 1 - x), (h + dh).clamp(0.08, 1 - y));

  List<double> toJson() => [
    for (final v in [x, y, w, h]) (v * 1000).roundToDouble() / 1000,
  ];

  static PrepFrame? fromJson(Object? json) {
    if (json is! List || json.length != 4 || json.any((v) => v is! num)) {
      return null;
    }
    final [x, y, w, h] = [for (final v in json) (v as num).toDouble()];
    if (w <= 0 || h <= 0) return null;
    return PrepFrame(x, y, w, h).moved(0, 0);
  }

  @override
  bool operator ==(Object other) =>
      other is PrepFrame &&
      other.x == x &&
      other.y == y &&
      other.w == w &&
      other.h == h;

  @override
  int get hashCode => Object.hash(x, y, w, h);
}

/// Místo bloku na obrazovce kázání.
enum PrepPlace {
  auto('Podle rozvržení'),
  full('Přes celou šířku'),
  left('Vlevo'),
  right('Vpravo');

  const PrepPlace(this.label);
  final String label;
}

/// Rozvržení obrazovky kázání pro bloky bez vlastního místa.
enum PrepLayout {
  stacked('Vše pod sebou'),
  versesLeft('Bible vlevo, poznámky vpravo'),
  versesRight('Poznámky vlevo, Bible vpravo');

  const PrepLayout(this.label);
  final String label;
}

/// Kde blok při daném rozvržení stojí (body osnovy přes celou šířku).
PrepPlace prepPlaceOf(PrepBlock b, PrepLayout layout) {
  if (b.place != PrepPlace.auto) return b.place;
  if (b.kind == PrepBlockKind.heading) return PrepPlace.full;
  final verse = b.passage != null;
  return switch (layout) {
    PrepLayout.stacked => PrepPlace.full,
    PrepLayout.versesLeft => verse ? PrepPlace.left : PrepPlace.right,
    PrepLayout.versesRight => verse ? PrepPlace.right : PrepPlace.left,
  };
}

/// Řádek obrazovky kázání: buď jeden blok přes celou šířku, nebo dva
/// sloupce (levý a pravý). Sloupec bez bloků se nevytváří – pak je
/// řádek přes celou šířku.
typedef PrepRow = ({List<PrepBlock> left, List<PrepBlock> right});

List<PrepRow> prepRows(List<PrepBlock> blocks, PrepLayout layout) {
  final rows = <PrepRow>[];
  PrepRow? open;
  for (final b in blocks) {
    final place = prepPlaceOf(b, layout);
    if (place == PrepPlace.full) {
      open = null;
      rows.add((left: [b], right: const []));
      continue;
    }
    if (open == null) {
      open = (left: <PrepBlock>[], right: <PrepBlock>[]);
      rows.add(open);
    }
    (place == PrepPlace.left ? open.left : open.right).add(b);
  }
  return rows;
}

/// Jak při kázání rozdělit bloky na obrazovky.
enum PrepSlideMode {
  /// Podle nastavení „spolu s předchozím“ u jednotlivých bloků.
  custom,

  /// Každý blok zvlášť.
  single,

  /// Bod osnovy se vším, co pod ním je.
  sections,
}

/// Rozdělí bloky na obrazovky (každá obrazovka = jeden nebo víc bloků).
List<List<PrepBlock>> prepSlides(List<PrepBlock> blocks, PrepSlideMode mode) {
  final out = <List<PrepBlock>>[];
  for (final b in blocks) {
    final join =
        out.isNotEmpty &&
        switch (mode) {
          PrepSlideMode.custom => b.withPrevious,
          PrepSlideMode.single => false,
          PrepSlideMode.sections =>
            b.kind != PrepBlockKind.heading &&
                out.last.first.kind == PrepBlockKind.heading,
        };
    join ? out.last.add(b) : out.add([b]);
  }
  return out;
}

/// Šablony osnov: body (název, nápověda co do bodu patří).
const prepTemplates = <PrepKind, List<(String, String)>>{
  PrepKind.sermon: [
    ('Úvod', 'Čím zaujmout? O čem to dnes bude?'),
    ('1. bod', 'Co text říká? Hlavní myšlenka, verš, vysvětlení.'),
    ('2. bod', 'Další krok myšlenky, příklad, souvislost.'),
    ('3. bod', 'Vyvrcholení, kam to celé míří.'),
    ('Aplikace', 'Co s tím v pondělí? Konkrétní krok pro posluchače.'),
    ('Závěr a modlitba', 'Shrnutí jednou větou, výzva, modlitba.'),
  ],
  PrepKind.bibleStudy: [
    ('Úvod a modlitba', 'Otázka na rozehřátí, modlitba.'),
    ('Čtení textu', 'Kdo čte, v jakém překladu, kontext.'),
    ('Pozorování', 'Co text říká? Kdo, co, kde, kdy?'),
    ('Výklad', 'Co to znamenalo tehdy a co znamená dnes?'),
    ('Otázky do diskuze', 'Otázky, které otevřou rozhovor.'),
    ('Aplikace a modlitba', 'Co si odnést, za co se modlit.'),
  ],
  PrepKind.youth: [
    ('Rozehřátí', 'Hra nebo otázka, která uvede téma.'),
    ('Příběh / text', 'Jak text podat živě?'),
    ('Hlavní myšlenka', 'Jedna věta, kterou si mají zapamatovat.'),
    ('Diskuze ve skupinkách', 'Otázky pro skupinky.'),
    ('Aktivita', 'Co budeme dělat, co je potřeba připravit.'),
    ('Modlitba', 'Jak zakončit.'),
  ],
  PrepKind.devotional: [
    ('Text', 'Proč právě tento text?'),
    ('Myšlenka', 'Co mě v textu oslovilo?'),
    ('Pro život', 'Co to znamená pro nás dnes?'),
    ('Modlitba', 'Krátká modlitba.'),
  ],
  PrepKind.other: [],
};

/// Přípravy (uložené v nastavení zařízení, součást zálohy).
class PrepController extends Notifier<List<Prep>> {
  Timer? _saveTimer;

  @override
  List<Prep> build() {
    ref.onDispose(() => _saveTimer?.cancel());
    final list = <Prep>[];
    for (final s in ref.read(appPreferencesProvider).preps) {
      try {
        final p = Prep.fromJson(jsonDecode(s));
        if (p != null) list.add(p);
      } on FormatException {
        // Poškozená položka se přeskočí.
      }
    }
    return list..sort((a, b) => b.updated.compareTo(a.updated));
  }

  void _set(List<Prep> list, {bool debounce = false}) {
    state = list;
    void save() => ref.read(appPreferencesProvider).setPreps([
      for (final p in state) jsonEncode(p.toJson()),
    ]);
    _saveTimer?.cancel();
    debounce
        ? _saveTimer = Timer(const Duration(milliseconds: 500), save)
        : save();
  }

  int _newId(Iterable<int> taken) {
    var id = DateTime.now().millisecondsSinceEpoch;
    while (taken.contains(id)) {
      id++;
    }
    return id;
  }

  Prep? byId(int id) => state.where((p) => p.id == id).firstOrNull;

  /// Nová příprava; s šablonou osnovy podle druhu.
  Prep create({
    String title = '',
    PrepKind kind = PrepKind.sermon,
    List<Passage> passages = const [],
    bool template = true,
  }) {
    final id = _newId(state.map((p) => p.id));
    var blockId = id;
    final prep = Prep(
      id: id,
      title: title,
      kind: kind,
      updated: DateTime.now(),
      passages: passages,
      blocks: [
        for (final p in passages)
          PrepBlock(id: blockId++, kind: PrepBlockKind.verse, passage: p),
        if (template)
          for (final (t, hint) in prepTemplates[kind]!)
            PrepBlock(
              id: blockId++,
              kind: PrepBlockKind.heading,
              text: t,
              hint: hint,
            ),
      ],
    );
    _set([prep, ...state]);
    return prep;
  }

  void update(Prep prep, {bool debounce = false}) => _set([
    prep,
    for (final p in state)
      if (p.id != prep.id) p,
  ], debounce: debounce);

  void remove(int id) => _set([
    for (final p in state)
      if (p.id != id) p,
  ]);

  /// Přidá blok na konec, za blok [after], nebo na konec bodu osnovy
  /// [section] (před další bod).
  PrepBlock addBlock(
    int prepId,
    PrepBlockKind kind, {
    String text = '',
    String hint = '',
    Passage? passage,
    int? after,
    int? section,
  }) {
    final prep = byId(prepId)!;
    final block = PrepBlock(
      id: _newId(prep.blocks.map((b) => b.id)),
      kind: kind,
      text: text,
      hint: hint,
      passage: passage,
    );
    final blocks = [...prep.blocks];
    var at = blocks.length;
    if (after != null) {
      final i = blocks.indexWhere((b) => b.id == after);
      if (i >= 0) at = i + 1;
    } else if (section != null) {
      final i = blocks.indexWhere((b) => b.id == section);
      if (i >= 0) {
        at = i + 1;
        while (at < blocks.length && blocks[at].kind != PrepBlockKind.heading) {
          at++;
        }
      }
    }
    blocks.insert(at, block);
    update(prep.copyWith(blocks: blocks));
    return block;
  }

  void updateBlock(int prepId, PrepBlock block) {
    final prep = byId(prepId);
    if (prep == null) return;
    update(
      prep.copyWith(
        blocks: [for (final b in prep.blocks) b.id == block.id ? block : b],
      ),
      debounce: true,
    );
  }

  /// Uloží několik bloků najednou (např. rozvržení celé obrazovky).
  void updateBlocks(int prepId, List<PrepBlock> changed) {
    final prep = byId(prepId);
    if (prep == null) return;
    final changedById = {for (final b in changed) b.id: b};
    update(
      prep.copyWith(
        blocks: [for (final b in prep.blocks) changedById[b.id] ?? b],
      ),
      debounce: true,
    );
  }

  void removeBlock(int prepId, int blockId) {
    final prep = byId(prepId);
    if (prep == null) return;
    update(
      prep.copyWith(
        blocks: [
          for (final b in prep.blocks)
            if (b.id != blockId) b,
        ],
      ),
    );
  }

  void moveBlock(int prepId, int from, int to) {
    final prep = byId(prepId);
    if (prep == null) return;
    final blocks = [...prep.blocks];
    // [to] je už upravený o odebranou položku (onReorderItem).
    final b = blocks.removeAt(from);
    blocks.insert(to.clamp(0, blocks.length), b);
    update(prep.copyWith(blocks: blocks));
  }

  /// Načte přípravu z jiného zařízení. [replace] = nahradí stejnou
  /// přípravu v tomto zařízení (stejné id); jinak se uloží jako nová kopie.
  Prep importPrep(Prep prep, {required bool replace}) {
    final Prep saved;
    if (replace) {
      saved = prep;
    } else {
      final id = _newId(state.map((p) => p.id));
      saved = Prep(
        id: id,
        title: byId(prep.id) == null
            ? prep.title
            : '${prep.title} ($_copyLabel)'.trim(),
        kind: prep.kind,
        updated: DateTime.now(),
        date: prep.date,
        passages: prep.passages,
        blocks: prep.blocks,
      );
    }
    _set([
      saved,
      for (final p in state)
        if (p.id != saved.id) p,
    ]);
    return saved;
  }

  static const _copyLabel = 'kopie';

  List<Map<String, Object?>> exportList() => [
    for (final p in state) p.toJson(),
  ];

  /// Ze zálohy: doplní přípravy, které tu ještě nejsou. Vrací počet nových.
  int importList(Object? json) {
    if (json is! List) return 0;
    final list = [...state];
    var added = 0;
    for (final item in json) {
      final p = Prep.fromJson(item);
      if (p == null || list.any((e) => e.id == p.id)) continue;
      list.add(p);
      added++;
    }
    if (added > 0) {
      _set(list..sort((a, b) => b.updated.compareTo(a.updated)));
    }
    return added;
  }
}

/// Soubor s jednou přípravou pro přenos na jiné zařízení.
Map<String, Object?> prepFileJson(Prep prep) => {
  'type': prepFileType,
  'version': 1,
  'prep': prep.toJson(),
};

const prepFileType = 'bible-prep';

/// Přípravy ze souboru: buď soubor jedné přípravy, nebo celá záloha
/// aplikace (vezmou se z ní přípravy). Neplatný soubor = prázdný seznam.
List<Prep> parsePrepFile(Object? json) {
  if (json is! Map) return const [];
  if (json['type'] == prepFileType) {
    return [?Prep.fromJson(json['prep'])];
  }
  if (json['preps'] case final List<Object?> list) {
    return [for (final p in list) ?Prep.fromJson(p)];
  }
  // Holá příprava (např. ručně uložený JSON).
  return [?Prep.fromJson(json)];
}

final prepProvider = NotifierProvider<PrepController, List<Prep>>(
  PrepController.new,
);
