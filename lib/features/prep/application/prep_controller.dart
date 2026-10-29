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
    this.passage,
  });

  final int id;
  final PrepBlockKind kind;

  /// Text bloku; u verše komentář.
  final String text;

  /// Biblické místo (u verše) v kanonickém číslování.
  final Passage? passage;

  PrepBlock copyWith({String? text, PrepBlockKind? kind}) => PrepBlock(
    id: id,
    kind: kind ?? this.kind,
    text: text ?? this.text,
    passage: passage,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    if (text.isNotEmpty) 'text': text,
    if (passage case final p?)
      'ref': [p.bookId, p.chapter, p.verse, p.end, p.endChapter],
  };

  static PrepBlock? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final kind = PrepBlockKind.values.asNameMap()[json['kind']];
    if (id is! int || kind == null) return null;
    final text = json['text'];
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
      passage: passage,
    );
  }
}

/// Příprava kázání, biblické hodiny nebo programu.
@immutable
class Prep {
  const Prep({
    required this.id,
    required this.title,
    required this.kind,
    required this.updated,
    this.date,
    this.passage,
    this.blocks = const [],
  });

  /// Čas vytvoření v ms – zároveň jedinečný identifikátor.
  final int id;
  final String title;
  final PrepKind kind;
  final DateTime updated;

  /// Kdy se bude kázat / konat.
  final DateTime? date;

  /// Hlavní biblický text (kanonické číslování).
  final Passage? passage;
  final List<PrepBlock> blocks;

  Prep copyWith({
    String? title,
    PrepKind? kind,
    DateTime? Function()? date,
    Passage? Function()? passage,
    List<PrepBlock>? blocks,
  }) => Prep(
    id: id,
    title: title ?? this.title,
    kind: kind ?? this.kind,
    updated: DateTime.now(),
    date: date == null ? this.date : date(),
    passage: passage == null ? this.passage : passage(),
    blocks: blocks ?? this.blocks,
  );

  /// Počet slov (poznámky, body, otázky…) – pro odhad délky.
  int get words => blocks.fold(
    title.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length,
    (n, b) =>
        n + b.text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'kind': kind.name,
    'updated': updated.millisecondsSinceEpoch,
    if (date != null) 'date': date!.millisecondsSinceEpoch,
    if (passage case final p?)
      'ref': [p.bookId, p.chapter, p.verse, p.end, p.endChapter],
    'blocks': [for (final b in blocks) b.toJson()],
  };

  static Prep? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final title = json['title'];
    if (id is! int || title is! String) return null;
    final updated = json['updated'];
    final date = json['date'];
    final ref = json['ref'];
    final blocks = json['blocks'];
    return Prep(
      id: id,
      title: title,
      kind: PrepKind.values.asNameMap()[json['kind']] ?? PrepKind.other,
      updated: DateTime.fromMillisecondsSinceEpoch(
        updated is int ? updated : id,
      ),
      date: date is int ? DateTime.fromMillisecondsSinceEpoch(date) : null,
      passage: ref is List && ref.length >= 4 && ref.every((e) => e is int)
          ? Passage.fromJson(ref)
          : null,
      blocks: [
        if (blocks is List)
          for (final b in blocks) ?PrepBlock.fromJson(b),
      ],
    );
  }
}

/// Šablony osnov: body, které se vloží do nové přípravy.
const prepTemplates = <PrepKind, List<(PrepBlockKind, String)>>{
  PrepKind.sermon: [
    (PrepBlockKind.heading, 'Úvod – čím zaujmout, o čem to bude'),
    (PrepBlockKind.heading, '1. bod'),
    (PrepBlockKind.heading, '2. bod'),
    (PrepBlockKind.heading, '3. bod'),
    (PrepBlockKind.heading, 'Aplikace – co s tím v pondělí'),
    (PrepBlockKind.heading, 'Závěr a modlitba'),
  ],
  PrepKind.bibleStudy: [
    (PrepBlockKind.heading, 'Úvod a modlitba'),
    (PrepBlockKind.heading, 'Čtení textu'),
    (PrepBlockKind.heading, 'Pozorování – co text říká'),
    (PrepBlockKind.heading, 'Výklad – co to znamená'),
    (PrepBlockKind.heading, 'Otázky do diskuze'),
    (PrepBlockKind.heading, 'Aplikace a modlitba'),
  ],
  PrepKind.youth: [
    (PrepBlockKind.heading, 'Rozehřátí – hra nebo otázka'),
    (PrepBlockKind.heading, 'Příběh / text'),
    (PrepBlockKind.heading, 'Hlavní myšlenka (jedna věta)'),
    (PrepBlockKind.heading, 'Diskuze ve skupinkách'),
    (PrepBlockKind.heading, 'Aktivita'),
    (PrepBlockKind.heading, 'Modlitba'),
  ],
  PrepKind.devotional: [
    (PrepBlockKind.heading, 'Text'),
    (PrepBlockKind.heading, 'Myšlenka'),
    (PrepBlockKind.heading, 'Pro život'),
    (PrepBlockKind.heading, 'Modlitba'),
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
    Passage? passage,
    bool template = true,
  }) {
    final id = _newId(state.map((p) => p.id));
    var blockId = id;
    final prep = Prep(
      id: id,
      title: title,
      kind: kind,
      updated: DateTime.now(),
      passage: passage,
      blocks: [
        if (passage != null)
          PrepBlock(id: blockId++, kind: PrepBlockKind.verse, passage: passage),
        if (template)
          for (final (k, t) in prepTemplates[kind]!)
            PrepBlock(id: blockId++, kind: k, text: t),
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

  /// Přidá blok na konec (nebo za blok [after]).
  PrepBlock addBlock(
    int prepId,
    PrepBlockKind kind, {
    String text = '',
    Passage? passage,
    int? after,
  }) {
    final prep = byId(prepId)!;
    final block = PrepBlock(
      id: _newId(prep.blocks.map((b) => b.id)),
      kind: kind,
      text: text,
      passage: passage,
    );
    final blocks = [...prep.blocks];
    final i = after == null ? -1 : blocks.indexWhere((b) => b.id == after);
    i < 0 ? blocks.add(block) : blocks.insert(i + 1, block);
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
