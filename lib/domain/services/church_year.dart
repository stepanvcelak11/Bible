/// Výpočet církevního roku: data svátků a liturgické doby.
library;

/// Datum velikonoční neděle (gregoriánský kalendář, anonymní algoritmus).
DateTime easterSunday(int year) {
  final a = year % 19;
  final b = year ~/ 100;
  final c = year % 100;
  final d = b ~/ 4;
  final e = b % 4;
  final f = (b + 8) ~/ 25;
  final g = (b - f + 1) ~/ 3;
  final h = (19 * a + b - d - g + 15) % 30;
  final i = c ~/ 4;
  final k = c % 4;
  final l = (32 + 2 * e + 2 * i - h - k) % 7;
  final m = (a + 11 * h + 22 * l) ~/ 451;
  final month = (h + l - 7 * m + 114) ~/ 31;
  final day = (h + l - 7 * m + 114) % 31 + 1;
  return DateTime(year, month, day);
}

DateTime _plus(DateTime d, int days) => DateTime(d.year, d.month, d.day + days);

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// 1. neděle adventní v daném roce (čtvrtá neděle před Vánocemi).
DateTime firstAdvent(int year) {
  final christmas = DateTime(year, 12, 25);
  // Poslední neděle před Božím hodem (DateTime.sunday == 7).
  final lastSunday = _plus(christmas, -christmas.weekday);
  return _plus(lastSunday, -21);
}

/// Liturgická doba.
enum ChurchSeason { advent, christmas, ordinary, lent, holyweek, easter }

/// Jeden církevní rok – od 1. neděle adventní do soboty před další.
class ChurchYear {
  ChurchYear._(this.startYear)
    : start = firstAdvent(startYear),
      end = _plus(firstAdvent(startYear + 1), -1),
      easter = easterSunday(startYear + 1);

  /// Církevní rok, do kterého patří [day].
  factory ChurchYear.of(DateTime day) {
    final d = _dateOnly(day);
    return ChurchYear._(d.isBefore(firstAdvent(d.year)) ? d.year - 1 : d.year);
  }

  /// Kalendářní rok, ve kterém církevní rok začíná.
  final int startYear;
  final DateTime start;
  final DateTime end;
  final DateTime easter;

  int get _y => startYear + 1;

  /// Křest Páně: první neděle po 6. lednu.
  DateTime get baptism {
    final epiphany = DateTime(_y, 1, 6);
    return _plus(epiphany, 7 - epiphany.weekday % 7);
  }

  DateTime get ashWednesday => _plus(easter, -46);
  DateTime get palmSunday => _plus(easter, -7);
  DateTime get pentecost => _plus(easter, 49);

  /// Data svátků podle id (shodných s obsahem `church_year.json`).
  Map<String, DateTime> get feasts => {
    'advent1': start,
    'christmas': DateTime(startYear, 12, 25),
    'epiphany': DateTime(_y, 1, 6),
    'baptism': baptism,
    'presentation': DateTime(_y, 2, 2),
    'ash': ashWednesday,
    'palm': palmSunday,
    'thursday': _plus(easter, -3),
    'friday': _plus(easter, -2),
    'saturday': _plus(easter, -1),
    'easter': easter,
    'ascension': _plus(easter, 39),
    'pentecost': pentecost,
    'trinity': _plus(easter, 56),
    'cyrilmethod': DateTime(_y, 7, 5),
    'hus': DateTime(_y, 7, 6),
    'reformation': DateTime(_y, 10, 31),
    'allsaints': DateTime(_y, 11, 1),
    'allsouls': DateTime(_y, 11, 2),
    'lastsunday': _plus(end, -6),
  };

  /// Úseky roku v pořadí: (doba, první den, poslední den).
  List<(ChurchSeason, DateTime, DateTime)> get periods => [
    (ChurchSeason.advent, start, DateTime(startYear, 12, 24)),
    (ChurchSeason.christmas, DateTime(startYear, 12, 25), baptism),
    (ChurchSeason.ordinary, _plus(baptism, 1), _plus(ashWednesday, -1)),
    (ChurchSeason.lent, ashWednesday, _plus(palmSunday, -1)),
    (ChurchSeason.holyweek, palmSunday, _plus(easter, -1)),
    (ChurchSeason.easter, easter, pentecost),
    (ChurchSeason.ordinary, _plus(pentecost, 1), end),
  ];

  int get lengthInDays => end.difference(start).inDays + 1;

  /// Liturgická doba pro [day] (musí ležet v tomto roce).
  ChurchSeason seasonOf(DateTime day) {
    final d = _dateOnly(day);
    for (final (s, from, to) in periods) {
      if (!d.isBefore(from) && !d.isAfter(to)) return s;
    }
    return ChurchSeason.ordinary;
  }

  /// Podíl uplynulého roku (0–1) pro den [day].
  double fractionOf(DateTime day) =>
      (_dateOnly(day).difference(start).inDays + 0.5) / lengthInDays;
}

/// Nejbližší svátek dnes nebo později: (id, datum). Hledá i v dalším
/// církevním roce.
(String, DateTime) nextFeast(DateTime day) {
  final d = _dateOnly(day);
  final year = ChurchYear.of(d);
  for (final y in [year, ChurchYear.of(_plus(year.end, 1))]) {
    final sorted = y.feasts.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    for (final e in sorted) {
      if (!e.value.isBefore(d)) return (e.key, e.value);
    }
  }
  throw StateError('unreachable');
}

/// Svátky od [day] na dalších dvanáct měsíců (přes přelom církevního
/// roku), seřazené podle data.
List<(String, DateTime)> upcomingFeasts(DateTime day) {
  final d = _dateOnly(day);
  final limit = DateTime(d.year + 1, d.month, d.day);
  final year = ChurchYear.of(d);
  return [
    for (final y in [year, ChurchYear.of(_plus(year.end, 1))])
      for (final e in y.feasts.entries)
        if (!e.value.isBefore(d) && e.value.isBefore(limit)) (e.key, e.value),
  ]..sort((a, b) => a.$2.compareTo(b.$2));
}
