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

  PrepBlock copyWith({String? text, String? body, PrepBlockKind? kind}) =>
      PrepBlock(
        id: id,
        kind: kind ?? this.kind,
        text: text ?? this.text,
        body: body ?? this.body,
        hint: hint,
        passage: passage,
      );

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    if (text.isNotEmpty) 'text': text,
    if (body.isNotEmpty) 'body': body,
    if (hint.isNotEmpty) 'hint': hint,
    if (passage case final p?)
      'ref': [p.bookId, p.chapter, p.verse, p.end, p.endChapter],
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

final prepProvider = NotifierProvider<PrepController, List<Prep>>(
  PrepController.new,
);
