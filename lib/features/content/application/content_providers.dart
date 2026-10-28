import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/services/versification.dart';

Future<Map<String, Object?>> _loadJson(String name) async {
  final bytes = await rootBundle.load('assets/content/$name');
  return jsonDecode(utf8.decode(bytes.buffer.asUint8List()))
      as Map<String, Object?>;
}

/// Verše do situací.
final situationsProvider =
    FutureProvider<(List<SituationGroup>, List<Situation>)>((ref) async {
      final j = await _loadJson('situations.json');
      return (
        [
          for (final g
              in (j['groups']! as List<Object?>).cast<Map<String, Object?>>())
            SituationGroup(g['id'] as String, g['name'] as String),
        ],
        [
          for (final s in j['situations']! as List<Object?>)
            Situation.fromJson(s! as Map<String, Object?>),
        ],
      );
    });

/// Text biblického místa v daném překladu (převod číslování).
final passageTextProvider = FutureProvider.autoDispose
    .family<List<Verse>, (String, Passage)>((ref, key) async {
      final (translationId, p) = key;
      final repo = ref.watch(bibleRepositoryProvider);
      if (p.wholeChapter) {
        final first = Versification.fromCanonical(p.start, translationId);
        return repo.getChapter(translationId, p.bookId, first.chapter);
      }
      final a = Versification.fromCanonical(p.start, translationId);
      final b = Versification.fromCanonical(
        VerseRef(p.bookId, p.endChapter, p.end),
        translationId,
      );
      final verses = <Verse>[];
      for (var c = a.chapter; c <= b.chapter; c++) {
        for (final v in await repo.getChapter(translationId, p.bookId, c)) {
          final after = c > a.chapter || v.number >= a.verse;
          final before = c < b.chapter || v.number <= b.verse;
          if (after && before) verses.add(v);
        }
      }
      return verses;
    });

/// Medailony biblických postav.
final peopleProvider = FutureProvider<List<BiblePerson>>((ref) async {
  final j = await _loadJson('people.json');
  return [
    for (final p
        in (j['people']! as List<Object?>).cast<Map<String, Object?>>())
      BiblePerson.fromJson(p),
  ];
});

/// Harmonie evangelií.
final harmonyProvider = FutureProvider<List<HarmonyPeriod>>((ref) async {
  final j = await _loadJson('harmony.json');
  return [
    for (final p
        in (j['periods']! as List<Object?>).cast<Map<String, Object?>>())
      HarmonyPeriod(p['name']! as String, [
        for (final e
            in (p['events']! as List<Object?>).cast<Map<String, Object?>>())
          HarmonyEvent.fromJson(e),
      ]),
  ];
});

/// Aplikační poznámky.
final notesProvider = FutureProvider<List<AppNote>>((ref) async {
  final j = await _loadJson('notes.json');
  return [
    for (final n in (j['notes']! as List<Object?>).cast<Map<String, Object?>>())
      AppNote.fromJson(n),
  ];
});

/// Tabulky a přehledy.
final tablesProvider = FutureProvider<List<ContentTable>>((ref) async {
  final j = await _loadJson('tables.json');
  return [
    for (final t
        in (j['tables']! as List<Object?>).cast<Map<String, Object?>>())
      ContentTable.fromJson(t),
  ];
});
