import 'package:flutter/foundation.dart';

import 'bible_entities.dart';

/// Biblické místo: verš, rozsah veršů nebo celá kapitola (verse == 0),
/// v kanonickém (hebrejském) číslování.
@immutable
class Passage {
  const Passage(this.bookId, this.chapter, this.verse, this.end);

  factory Passage.fromJson(Object? json) {
    final l = (json! as List<Object?>).cast<int>();
    return Passage(l[0], l[1], l[2], l.length > 3 ? l[3] : l[2]);
  }

  final int bookId;
  final int chapter;

  /// 0 = celá kapitola.
  final int verse;
  final int end;

  bool get wholeChapter => verse == 0;

  VerseRef get start => VerseRef(bookId, chapter, verse == 0 ? 1 : verse);

  /// „Ž 34,19“, „Fp 4,6–7“, „Gn 12“.
  String label(String bookAbbreviation) => wholeChapter
      ? '$bookAbbreviation $chapter'
      : end > verse
      ? '$bookAbbreviation $chapter,$verse–$end'
      : '$bookAbbreviation $chapter,$verse';
}

List<Passage> parsePassages(Object? json) => [
  for (final p in (json as List<Object?>? ?? const [])) Passage.fromJson(p),
];

/// Skupina situací („Pocity“…).
class SituationGroup {
  const SituationGroup(this.id, this.name);

  final String id;
  final String name;
}

/// Verše do životní situace.
class Situation {
  const Situation({
    required this.id,
    required this.group,
    required this.icon,
    required this.title,
    required this.intro,
    required this.passages,
  });

  factory Situation.fromJson(Map<String, Object?> j) => Situation(
    id: j['id']! as String,
    group: j['group']! as String,
    icon: j['icon']! as String,
    title: j['title']! as String,
    intro: j['intro']! as String,
    passages: parsePassages(j['refs']),
  );

  final String id;
  final String group;
  final String icon;
  final String title;
  final String intro;
  final List<Passage> passages;
}
