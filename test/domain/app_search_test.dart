import 'package:bible_reader/features/search/application/app_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

AppSearchItem item(
  AppHitKind kind,
  String title, {
  String keywords = '',
  String body = '',
}) => AppSearchItem(
  kind: kind,
  title: title,
  subtitle: '',
  icon: Icons.circle,
  keywords: keywords,
  body: body,
  open: (_, _) {},
);

void main() {
  final index = [
    item(AppHitKind.feature, 'Biblické mapy', keywords: 'mapa mapy místa'),
    item(AppHitKind.map, 'Jeruzalém', keywords: 'Jerusalem'),
    item(AppHitKind.map, 'Betlém'),
    item(AppHitKind.topic, 'Strach a odvaha', body: 'Neboj se, Jozue'),
    item(AppHitKind.topic, 'Stánek a chrám', body: 'chrám v Jeruzalémě'),
    item(AppHitKind.readingPlan, 'Evangelia za 40 dní'),
    item(AppHitKind.person, 'Mojžíš', keywords: 'prorok vůdce'),
    item(AppHitKind.route, 'Pavlovy cesty', keywords: 'Antiochie Řím'),
  ];
  String top(String q) => searchApp(index, q).first.item.title;

  test('skloňování a diakritika', () {
    expect(top('Jeruzalémem'), 'Jeruzalém');
    expect(stemCzech('mapy'), stemCzech('mapa'));
    expect(top('jeruzalema'), 'Jeruzalém');
    expect(top('strachu'), 'Strach a odvaha');
  });

  test('záměr: mapa X hledá místa, samotná mapa funkci', () {
    expect(top('mapa Jeruzaléma'), 'Jeruzalém');
    expect(top('chci mapu'), 'Biblické mapy');
    expect(top('plán evangelia'), 'Evangelia za 40 dní');
    expect(top('kdo byl Mojžíš'), 'Mojžíš');
  });

  test('překlep a více slov', () {
    expect(top('Mojžís'), 'Mojžíš');
    expect(top('pavlovy cesty'), 'Pavlovy cesty');
    expect(searchApp(index, 'xyzzy'), isEmpty);
  });
}
