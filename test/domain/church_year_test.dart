import 'package:bible_reader/domain/services/church_year.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Velikonoce', () {
    expect(easterSunday(2019), DateTime(2019, 4, 21));
    expect(easterSunday(2024), DateTime(2024, 3, 31));
    expect(easterSunday(2025), DateTime(2025, 4, 20));
    expect(easterSunday(2026), DateTime(2026, 4, 5));
    expect(easterSunday(2027), DateTime(2027, 3, 28));
    expect(easterSunday(2038), DateTime(2038, 4, 25));
  });

  test('1. neděle adventní', () {
    expect(firstAdvent(2023), DateTime(2023, 12, 3));
    expect(firstAdvent(2024), DateTime(2024, 12, 1));
    expect(firstAdvent(2025), DateTime(2025, 11, 30));
    expect(firstAdvent(2026), DateTime(2026, 11, 29));
    expect(firstAdvent(2027), DateTime(2027, 11, 28));
  });

  test('doby a svátky roku 2025/26', () {
    final y = ChurchYear.of(DateTime(2026, 10, 28));
    expect(y.start, DateTime(2025, 11, 30));
    expect(y.end, DateTime(2026, 11, 28));
    expect(y.feasts['ash'], DateTime(2026, 2, 18));
    expect(y.feasts['pentecost'], DateTime(2026, 5, 24));
    expect(y.feasts['ascension'], DateTime(2026, 5, 14));
    expect(y.feasts['baptism'], DateTime(2026, 1, 11));
    expect(y.feasts['lastsunday'], DateTime(2026, 11, 22));
    expect(y.seasonOf(DateTime(2025, 12, 10)), ChurchSeason.advent);
    expect(y.seasonOf(DateTime(2026, 1, 1)), ChurchSeason.christmas);
    expect(y.seasonOf(DateTime(2026, 1, 12)), ChurchSeason.ordinary);
    expect(y.seasonOf(DateTime(2026, 3, 1)), ChurchSeason.lent);
    expect(y.seasonOf(DateTime(2026, 4, 3)), ChurchSeason.holyweek);
    expect(y.seasonOf(DateTime(2026, 4, 5)), ChurchSeason.easter);
    expect(y.seasonOf(DateTime(2026, 5, 24)), ChurchSeason.easter);
    expect(y.seasonOf(DateTime(2026, 10, 28)), ChurchSeason.ordinary);
    // Úseky na sebe navazují bez mezer.
    final p = y.periods;
    for (var i = 1; i < p.length; i++) {
      expect(p[i].$2.difference(p[i - 1].$3).inDays, 1);
    }
    expect(p.first.$2, y.start);
    expect(p.last.$3, y.end);
  });

  test('nejbližší svátek přeskočí do dalšího roku', () {
    expect(nextFeast(DateTime(2026, 10, 28)), (
      'reformation',
      DateTime(2026, 10, 31),
    ));
    expect(nextFeast(DateTime(2026, 11, 23)).$1, 'advent1');
    expect(nextFeast(DateTime(2026, 11, 23)).$2, DateTime(2026, 11, 29));
    expect(nextFeast(DateTime(2026, 4, 5)).$1, 'easter');
  });

  test('nadcházející svátky na rok dopředu', () {
    final list = upcomingFeasts(DateTime(2026, 10, 28));
    expect(list.first, ('reformation', DateTime(2026, 10, 31)));
    expect(list.map((e) => e.$1).toSet().length, list.length);
    expect(list.length, 20);
    expect(list.last.$2.isBefore(DateTime(2027, 10, 28)), isTrue);
    expect(list.map((e) => e.$1), contains('easter'));
  });
}
