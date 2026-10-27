import '../../../domain/entities/bible_entities.dart';

/// Položka seznamu čtečky.
sealed class ReaderBlock {
  const ReaderBlock();

  /// Čísla veršů, které blok zobrazuje (prázdné u nadpisu).
  List<int> get verseNumbers;
}

/// Nadpis oddílu („Stvoření světa“).
final class HeadingBlock extends ReaderBlock {
  const HeadingBlock(this.text);

  final String text;

  @override
  List<int> get verseNumbers => const [];
}

/// Odstavec – jeden nebo více veršů sázených za sebou (nebo jeden verš
/// v režimu „verš po verši“). Poezie má verše po řádcích s odsazením.
final class ParagraphBlock extends ReaderBlock {
  const ParagraphBlock(this.verses, {this.poetry = false});

  final List<Verse> verses;
  final bool poetry;

  @override
  List<int> get verseNumbers => [for (final v in verses) v.number];
}

/// Rozdělí kapitolu na nadpisy a odstavce.
///
/// * [paragraphs] = `true`: verše se slévají do odstavců podle zdroje
///   (B21 má odstavce, ČEP/BKR ne → každý verš zůstane samostatně).
/// * Nadpis oddílu vždy začíná nový odstavec.
/// * Verše poezie tvoří vlastní bloky (každý verš = sloka).
List<ReaderBlock> buildReaderBlocks(
  ChapterText chapter, {
  required bool paragraphs,
}) {
  final blocks = <ReaderBlock>[];
  var current = <Verse>[];

  void flush() {
    if (current.isNotEmpty) {
      blocks.add(ParagraphBlock(current));
      current = [];
    }
  }

  for (final verse in chapter.verses) {
    final headings = chapter.headings[verse.number];
    if (headings != null) {
      flush();
      for (final h in headings) {
        blocks.add(HeadingBlock(h));
      }
    }
    if (verse.poetry) {
      flush();
      blocks.add(ParagraphBlock([verse], poetry: true));
      continue;
    }
    if (!paragraphs || verse.paragraph) flush();
    current.add(verse);
  }
  flush();
  return blocks;
}
