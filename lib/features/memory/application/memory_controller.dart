import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/versification.dart';
import '../../translations/application/translation_controller.dart';

/// Verš (nebo úsek veršů jedné kapitoly) k učení nazpaměť.
///
/// [start] je v kanonickém číslování, [end] = poslední verš úseku.
/// [level] 0–[maxLevel]: kolik slov se při procvičování skryje;
/// [maxLevel] = naučeno.
@immutable
class MemoryVerse {
  const MemoryVerse(this.start, this.end, [this.level = 0]);

  static const maxLevel = 5;

  final VerseRef start;
  final int end;
  final int level;

  bool get learned => level >= maxLevel;

  MemoryVerse withLevel(int level) =>
      MemoryVerse(start, end, level.clamp(0, maxLevel));

  bool sameAs(MemoryVerse o) => o.start == start && o.end == end;

  String encode() => '${start.encode()}-$end|$level';

  static MemoryVerse? tryDecode(String s) {
    final m = RegExp(r'^(\d+:\d+:\d+)-(\d+)\|(\d+)$').firstMatch(s);
    final ref = VerseRef.tryDecode(m?.group(1));
    if (m == null || ref == null) return null;
    return MemoryVerse(ref, int.parse(m.group(2)!), int.parse(m.group(3)!));
  }
}

class MemoryController extends Notifier<List<MemoryVerse>> {
  @override
  List<MemoryVerse> build() => [
    for (final s in ref.read(appPreferencesProvider).memoryVerses)
      ?MemoryVerse.tryDecode(s),
  ];

  void _set(List<MemoryVerse> list) {
    state = list;
    ref.read(appPreferencesProvider).setMemoryVerses([
      for (final m in list) m.encode(),
    ]);
  }

  /// Přidá úsek (pokud tam ještě není). Vrací `false`, když už existuje.
  bool add(MemoryVerse verse) {
    if (state.any(verse.sameAs)) return false;
    _set([verse, ...state]);
    return true;
  }

  /// Pro zálohu: zakódovaný seznam.
  List<String> exportList() => [for (final m in state) m.encode()];

  /// Ze zálohy: doplní chybějící verše (stávající pokrok zůstává).
  /// Vrací počet nově přidaných.
  int importList(Object? json) {
    if (json is! List) return 0;
    var added = 0;
    final list = [...state];
    for (final item in json) {
      final m = item is String ? MemoryVerse.tryDecode(item) : null;
      if (m == null || list.any(m.sameAs)) continue;
      list.add(m);
      added++;
    }
    if (added > 0) _set(list);
    return added;
  }

  void remove(MemoryVerse verse) => _set([
    for (final m in state)
      if (!m.sameAs(verse)) m,
  ]);

  void setLevel(MemoryVerse verse, int level) =>
      _set([for (final m in state) m.sameAs(verse) ? m.withLevel(level) : m]);
}

final memoryProvider = NotifierProvider<MemoryController, List<MemoryVerse>>(
  MemoryController.new,
);

/// Text úseku v hlavním překladu.
final memoryTextProvider = FutureProvider.autoDispose
    .family<String, MemoryVerse>((ref, m) async {
      final translationId = ref.watch(
        translationControllerProvider.select((s) => s.primaryId),
      );
      final repo = ref.watch(bibleRepositoryProvider);
      final from = Versification.fromCanonical(m.start, translationId);
      final to = Versification.fromCanonical(
        VerseRef(m.start.bookId, m.start.chapter, m.end),
        translationId,
      );
      final last = to.chapter == from.chapter ? to.verse : from.verse;
      final parts = <String>[];
      for (var v = from.verse; v <= last; v++) {
        final verse = await repo.getVerse(
          translationId,
          VerseRef(from.bookId, from.chapter, v),
        );
        if (verse != null) parts.add(verse.text.replaceAll('\n', ' '));
      }
      return parts.join(' ');
    });
