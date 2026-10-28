/// Výpočty pro obrazovku „Můj pokrok“: série, odznaky, pokrok po knihách.
library;

/// Nejdelší série po sobě jdoucích dní se čtením.
int longestStreak(Iterable<DateTime> days) {
  final sorted = {
    for (final d in days) DateTime(d.year, d.month, d.day),
  }.toList()..sort();
  var best = 0, run = 0;
  DateTime? prev;
  for (final d in sorted) {
    final next = prev == null
        ? null
        : DateTime(prev.year, prev.month, prev.day + 1);
    run = next == d ? run + 1 : 1;
    if (run > best) best = run;
    prev = d;
  }
  return best;
}

/// Odznak za čtení.
class ReadingBadge {
  const ReadingBadge(
    this.id,
    this.icon,
    this.title,
    this.description,
    this.earned,
  );

  final String id;

  /// Klíč ikony (mapuje se v UI).
  final String icon;
  final String title;
  final String description;
  final bool earned;
}

/// Odznaky podle přečtených kapitol ([read]: kniha → kapitoly),
/// počtu kapitol v knihách ([counts]) a nejdelší série ([streak]).
List<ReadingBadge> computeBadges({
  required Map<int, Set<int>> read,
  required Map<int, int> counts,
  required int streak,
}) {
  final total = read.values.fold<int>(0, (s, c) => s + c.length);
  bool complete(int book) {
    final n = counts[book] ?? 0;
    return n > 0 && (read[book]?.length ?? 0) >= n;
  }

  bool all(int from, int to) {
    for (var b = from; b <= to; b++) {
      if (!complete(b)) return false;
    }
    return true;
  }

  final gospels = [40, 41, 42, 43].where(complete).length;
  return [
    ReadingBadge(
      'first',
      'spark',
      'První krok',
      'Přečtěte první kapitolu',
      total >= 1,
    ),
    ReadingBadge(
      'streak3',
      'flame',
      'Tři dny v řadě',
      'Čtěte 3 dny po sobě',
      streak >= 3,
    ),
    ReadingBadge(
      'streak7',
      'flame',
      'Týden věrnosti',
      'Čtěte 7 dní po sobě',
      streak >= 7,
    ),
    ReadingBadge(
      'streak30',
      'flame',
      'Měsíc s Biblí',
      'Čtěte 30 dní po sobě',
      streak >= 30,
    ),
    ReadingBadge(
      'ch50',
      'book',
      '50 kapitol',
      'Přečtěte 50 různých kapitol',
      total >= 50,
    ),
    ReadingBadge(
      'ch100',
      'book',
      '100 kapitol',
      'Přečtěte 100 různých kapitol',
      total >= 100,
    ),
    ReadingBadge(
      'ch250',
      'book',
      '250 kapitol',
      'Přečtěte 250 různých kapitol',
      total >= 250,
    ),
    ReadingBadge(
      'ch500',
      'book',
      '500 kapitol',
      'Přečtěte 500 různých kapitol',
      total >= 500,
    ),
    ReadingBadge(
      'gospel',
      'cross',
      'Celé evangelium',
      'Přečtěte celé jedno evangelium',
      gospels >= 1,
    ),
    ReadingBadge(
      'gospels',
      'cross',
      'Čtyři evangelia',
      'Přečtěte Matouše, Marka, Lukáše i Jana',
      gospels == 4,
    ),
    ReadingBadge(
      'psalms',
      'music',
      'Kniha Žalmů',
      'Přečtěte všech 150 žalmů',
      complete(19),
    ),
    ReadingBadge(
      'torah',
      'scroll',
      'Tóra',
      'Přečtěte pět knih Mojžíšových',
      all(1, 5),
    ),
    ReadingBadge(
      'nt',
      'star',
      'Nový zákon',
      'Přečtěte celý Nový zákon',
      all(40, 66),
    ),
    ReadingBadge(
      'ot',
      'star',
      'Starý zákon',
      'Přečtěte celý Starý zákon',
      all(1, 39),
    ),
    ReadingBadge(
      'bible',
      'crown',
      'Celá Bible',
      'Přečtěte všech 66 knih',
      all(1, 66),
    ),
  ];
}
