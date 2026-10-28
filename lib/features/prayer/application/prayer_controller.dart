import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';

/// Modlitba ze seznamu: prosba, za kterou se modlím, a případně záznam,
/// jak byla vyslyšena.
@immutable
class Prayer {
  const Prayer({
    required this.id,
    required this.text,
    required this.created,
    this.answered,
    this.answer = '',
    this.prayed = 0,
  });

  /// Čas vytvoření v ms – zároveň jedinečný identifikátor.
  final int id;
  final String text;
  final DateTime created;

  /// Kdy byla modlitba označena jako vyslyšená (`null` = stále se modlím).
  final DateTime? answered;

  /// Krátký záznam, jak byla vyslyšena.
  final String answer;

  /// Kolikrát jsem se za ni pomodlil(a).
  final int prayed;

  bool get isAnswered => answered != null;

  Prayer copyWith({
    String? text,
    DateTime? Function()? answered,
    String? answer,
    int? prayed,
  }) => Prayer(
    id: id,
    text: text ?? this.text,
    created: created,
    answered: answered == null ? this.answered : answered(),
    answer: answer ?? this.answer,
    prayed: prayed ?? this.prayed,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'text': text,
    'created': created.millisecondsSinceEpoch,
    if (answered != null) 'answered': answered!.millisecondsSinceEpoch,
    if (answer.isNotEmpty) 'answer': answer,
    if (prayed > 0) 'prayed': prayed,
  };

  static Prayer? fromJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final text = json['text'];
    final created = json['created'];
    if (id is! int || text is! String || created is! int) return null;
    if (text.trim().isEmpty) return null;
    final answered = json['answered'];
    final answer = json['answer'];
    final prayed = json['prayed'];
    return Prayer(
      id: id,
      text: text,
      created: DateTime.fromMillisecondsSinceEpoch(created),
      answered: answered is int
          ? DateTime.fromMillisecondsSinceEpoch(answered)
          : null,
      answer: answer is String ? answer : '',
      prayed: prayed is int && prayed > 0 ? prayed : 0,
    );
  }
}

/// Modlitební seznam (uložený v nastavení zařízení, součást zálohy).
class PrayerController extends Notifier<List<Prayer>> {
  @override
  List<Prayer> build() {
    final list = <Prayer>[];
    for (final s in ref.read(appPreferencesProvider).prayers) {
      try {
        final p = Prayer.fromJson(jsonDecode(s));
        if (p != null) list.add(p);
      } on FormatException {
        // Poškozená položka se přeskočí.
      }
    }
    return list;
  }

  void _set(List<Prayer> list) {
    state = list;
    ref.read(appPreferencesProvider).setPrayers([
      for (final p in list) jsonEncode(p.toJson()),
    ]);
  }

  Prayer add(String text, {DateTime? now}) {
    final created = now ?? DateTime.now();
    var id = created.millisecondsSinceEpoch;
    while (state.any((p) => p.id == id)) {
      id++;
    }
    final prayer = Prayer(id: id, text: text.trim(), created: created);
    _set([prayer, ...state]);
    return prayer;
  }

  void replace(Prayer prayer) =>
      _set([for (final p in state) p.id == prayer.id ? prayer : p]);

  void remove(int id) => _set([
    for (final p in state)
      if (p.id != id) p,
  ]);

  /// Vrátí smazanou modlitbu zpět na její místo (podle data vytvoření).
  void restore(Prayer prayer) {
    if (state.any((p) => p.id == prayer.id)) return;
    _set([...state, prayer]..sort((a, b) => b.created.compareTo(a.created)));
  }

  void markPrayed(int id) => _set([
    for (final p in state) p.id == id ? p.copyWith(prayed: p.prayed + 1) : p,
  ]);

  void setAnswered(int id, {required bool answered, String? answer}) => _set([
    for (final p in state)
      if (p.id == id)
        p.copyWith(
          answered: () => answered ? (p.answered ?? DateTime.now()) : null,
          answer: answer,
        )
      else
        p,
  ]);

  /// Pro zálohu.
  List<Map<String, Object?>> exportList() => [
    for (final p in state) p.toJson(),
  ];

  /// Ze zálohy: doplní modlitby, které tu ještě nejsou. Vrací počet nových.
  int importList(Object? json) {
    if (json is! List) return 0;
    final list = [...state];
    var added = 0;
    for (final item in json) {
      final p = Prayer.fromJson(item);
      if (p == null || list.any((e) => e.id == p.id)) continue;
      list.add(p);
      added++;
    }
    if (added > 0) {
      _set(list..sort((a, b) => b.created.compareTo(a.created)));
    }
    return added;
  }
}

final prayerProvider = NotifierProvider<PrayerController, List<Prayer>>(
  PrayerController.new,
);
