import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/versification.dart';

/// Druh krátké poznámky v textu.
enum InlineNoteKind {
  /// Dobový kontext – co to znamenalo tehdy.
  context('c'),

  /// Zajímavost – slovo, zvyk, souvislost.
  curio('z'),

  /// Pro život – jak text uplatnit dnes.
  life('l'),

  /// Význam – vysvětlení těžšího místa.
  meaning('m');

  const InlineNoteKind(this.code);

  final String code;

  static InlineNoteKind of(String code) =>
      values.firstWhere((k) => k.code == code, orElse: () => meaning);
}

/// Krátká poznámka aplikace k verši (vlastní text, kanonické číslování).
class InlineNote {
  const InlineNote({
    required this.ref,
    required this.kind,
    required this.title,
    required this.text,
  });

  final VerseRef ref;
  final InlineNoteKind kind;
  final String title;
  final String text;
}

/// Poznámky jedné knihy podle kapitol (kanonické číslování).
///
/// Soubor `assets/content/chapter_notes/<kniha>.json`:
/// `{"<kapitola>": [[verš, "druh", "nadpis", "text"], …], …}`.
final bookInlineNotesProvider = FutureProvider.family<List<InlineNote>, int>((
  ref,
  bookId,
) async {
  final String raw;
  try {
    raw = await rootBundle.loadString(
      'assets/content/chapter_notes/${bookId.toString().padLeft(2, '0')}.json',
    );
  } on Object {
    return const [];
  }
  final j = jsonDecode(raw) as Map<String, Object?>;
  return [
    for (final MapEntry(:key, :value) in j.entries)
      for (final n in (value! as List<Object?>).cast<List<Object?>>())
        InlineNote(
          ref: VerseRef(bookId, int.parse(key), n[0]! as int),
          kind: InlineNoteKind.of(n[1]! as String),
          title: n[2]! as String,
          text: n[3]! as String,
        ),
  ];
});

/// Poznámky kapitoly v číslování zvoleného překladu: verš → poznámky.
final chapterInlineNotesProvider =
    Provider.family<Map<int, List<InlineNote>>, (String, int, int)>((ref, key) {
      final (translationId, bookId, chapter) = key;
      final all = ref.watch(bookInlineNotesProvider(bookId)).value;
      if (all == null) return const {};
      final out = <int, List<InlineNote>>{};
      for (final n in all) {
        final r = Versification.fromCanonical(n.ref, translationId);
        if (r.chapter != chapter) continue;
        (out[r.verse] ??= []).add(n);
      }
      return out;
    });
