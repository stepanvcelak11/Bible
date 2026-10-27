import 'package:drift/drift.dart';

import '../../domain/entities/bible_entities.dart';
import '../../domain/entities/study_entities.dart';
import 'study_database.dart';

/// Číslování veršů překladu ve Starém zákoně.
///
/// Studijní data (původní text) používají HEBREJSKÉ číslování, křížové
/// odkazy a místa ANGLICKÉ (KJV). Ze zdrojů v aplikaci se KJV číslováním
/// řídí jen Kralická (nadpisy žalmů spojuje s 1. veršem), ostatní moderní
/// české překlady číslují podle hebrejského textu.
bool usesEnglishVersification(String translationId) => translationId == 'BKR';

/// Dotazy nad studijním balíčkem.
class StudyRepository {
  StudyRepository(this._db);

  final StudyDatabase _db;

  static const _field = '\u001f';
  static const _word = '\u001e';

  static int _id(int book, int chapter, int verse) =>
      book * 1000000 + chapter * 1000 + verse;

  /// Hebrejské odkazy odpovídající anglickému verši (většinou 1:1).
  Future<List<(int, int)>> _engToHeb(int book, int chapter, int verse) async {
    final rows = await _db
        .customSelect(
          'SELECT heb_chapter, heb_verse FROM vmap WHERE book = ? '
          'AND eng_chapter = ? AND eng_verse IN (?, ?) '
          'ORDER BY eng_verse, heb_chapter, heb_verse',
          variables: [
            Variable.withInt(book),
            Variable.withInt(chapter),
            // Verš 0 = nadpis žalmu v KJV; v Kralické je součástí 1. verše.
            Variable.withInt(verse == 1 ? 0 : verse),
            Variable.withInt(verse),
          ],
        )
        .get();
    final mapped = [
      for (final r in rows)
        (r.read<int>('heb_chapter'), r.read<int>('heb_verse')),
    ];
    return mapped.isEmpty ? [(chapter, verse)] : mapped.toSet().toList();
  }

  /// Anglický (KJV) odkaz pro hebrejsky číslovaný verš.
  Future<(int, int)> _hebToEng(int book, int chapter, int verse) async {
    final row = await _db
        .customSelect(
          'SELECT eng_chapter, eng_verse FROM vmap WHERE book = ? '
          'AND heb_chapter = ? AND heb_verse = ? LIMIT 1',
          variables: [
            Variable.withInt(book),
            Variable.withInt(chapter),
            Variable.withInt(verse),
          ],
        )
        .getSingleOrNull();
    return row == null
        ? (chapter, verse)
        : (row.read<int>('eng_chapter'), row.read<int>('eng_verse'));
  }

  /// Slova původního textu verše v číslování daného překladu.
  Future<List<OriginalWord>> words(VerseRef ref, String translationId) async {
    final refs = ref.bookId <= 39 && usesEnglishVersification(translationId)
        ? await _engToHeb(ref.bookId, ref.chapter, ref.verse)
        : [(ref.chapter, ref.verse)];
    final result = <OriginalWord>[];
    for (final (c, v) in refs) {
      final row = await _db
          .customSelect(
            'SELECT data FROM words WHERE id = ?',
            variables: [Variable.withInt(_id(ref.bookId, c, v))],
          )
          .getSingleOrNull();
      if (row == null) continue;
      for (final w in row.read<String>('data').split(_word)) {
        final f = w.split(_field);
        if (f.length < 5) continue;
        result.add(
          OriginalWord(
            text: f[0],
            transliteration: f[1],
            english: f[2],
            strong: f[3],
            morphology: f[4],
          ),
        );
      }
    }
    return result;
  }

  Future<LexiconEntry?> lexicon(String strong) async {
    final r = await _db
        .customSelect(
          'SELECT * FROM lexicon WHERE strong = ?',
          variables: [Variable.withString(strong)],
        )
        .getSingleOrNull();
    if (r == null) return null;
    return LexiconEntry(
      strong: r.read<String>('strong'),
      lemma: r.read<String>('lemma'),
      transliteration: r.read<String>('translit'),
      glossCs: r.readNullable<String>('gloss_cs'),
      glossEn: r.read<String>('gloss_en'),
      definition: r.read<String>('definition'),
      occurrences: r.read<int>('occurrences'),
      partOfSpeech: r.readNullable<String>('morph'),
    );
  }

  /// České významy pro více slov najednou (pro seznam slov verše).
  Future<Map<String, LexiconEntry>> lexiconMany(
    Iterable<String> strongs,
  ) async {
    final keys = strongs.where((s) => s.isNotEmpty).toSet().toList();
    if (keys.isEmpty) return const {};
    final rows = await _db
        .customSelect(
          'SELECT * FROM lexicon WHERE strong IN '
          '(${List.filled(keys.length, '?').join(',')})',
          variables: [for (final k in keys) Variable.withString(k)],
        )
        .get();
    return {
      for (final r in rows)
        r.read<String>('strong'): LexiconEntry(
          strong: r.read<String>('strong'),
          lemma: r.read<String>('lemma'),
          transliteration: r.read<String>('translit'),
          glossCs: r.readNullable<String>('gloss_cs'),
          glossEn: r.read<String>('gloss_en'),
          definition: r.read<String>('definition'),
          occurrences: r.read<int>('occurrences'),
          partOfSpeech: r.readNullable<String>('morph'),
        ),
    };
  }

  /// Verše, kde se slovo vyskytuje (hebrejské číslování u SZ).
  Future<List<VerseRef>> occurrences(String strong) async {
    final r = await _db
        .customSelect(
          'SELECT refs FROM occurrences WHERE strong = ?',
          variables: [Variable.withString(strong)],
        )
        .getSingleOrNull();
    if (r == null) return const [];
    return [
      for (final code in r.read<String>('refs').split(','))
        if (int.tryParse(code, radix: 36) case final n?)
          VerseRef(
            n ~/ 1000000,
            (n ~/ 1000) % 1000,
            n % 1000 == 0 ? 1 : n % 1000,
          ),
    ];
  }

  /// Souvislosti k verši (seřazené podle síly vazby).
  Future<List<CrossReference>> crossReferences(
    VerseRef ref,
    String translationId,
  ) async {
    var (c, v) = (ref.chapter, ref.verse);
    if (ref.bookId <= 39 && !usesEnglishVersification(translationId)) {
      (c, v) = await _hebToEng(ref.bookId, c, v);
    }
    final rows = await _db
        .customSelect(
          'SELECT * FROM xrefs WHERE book = ? AND chapter = ? AND verse = ? '
          'ORDER BY votes DESC',
          variables: [
            Variable.withInt(ref.bookId),
            Variable.withInt(c),
            Variable.withInt(v),
          ],
        )
        .get();
    final result = <CrossReference>[];
    for (final r in rows) {
      final book = r.read<int>('to_book');
      var tc = r.read<int>('to_chapter');
      var tv = r.read<int>('to_verse');
      var end = r.read<int>('to_verse_end');
      if (book <= 39 && !usesEnglishVersification(translationId)) {
        final mapped = await _engToHeb(book, tc, tv);
        final shift = mapped.last.$2 - tv;
        (tc, tv) = mapped.last;
        end += shift;
      }
      result.add(
        CrossReference(
          target: VerseRef(book, tc, tv < 1 ? 1 : tv),
          endVerse: end < tv ? tv : end,
          votes: r.read<int>('votes'),
        ),
      );
    }
    return result;
  }
}
