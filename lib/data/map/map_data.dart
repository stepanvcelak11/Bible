import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../../domain/entities/bible_entities.dart';
import '../../domain/entities/study_entities.dart';

/// Podklad mapy (Natural Earth): obrysy pevniny, jezer a řek jako ploché
/// seznamy [lon, lat, lon, lat, …].
class Basemap {
  const Basemap({
    required this.land,
    required this.lakes,
    required this.rivers,
  });

  final List<Float32List> land;
  final List<Float32List> lakes;
  final List<Float32List> rivers;
}

/// Místo z přibaleného seznamu včetně veršů, kde se zmiňuje.
class MapPlace {
  const MapPlace(this.place, this._refs);

  final BiblePlace place;
  final String _refs;

  List<VerseRef> get verses => [
    for (final code in _refs.split(','))
      if (int.tryParse(code, radix: 36) case final n?)
        VerseRef(
          n ~/ 1000000,
          (n ~/ 1000) % 1000,
          n % 1000 == 0 ? 1 : n % 1000,
        ),
  ];

  bool mentionedIn(int book, int chapter) {
    final prefix = (book * 1000000 + chapter * 1000);
    for (final code in _refs.split(',')) {
      final n = int.tryParse(code, radix: 36);
      if (n != null && n >= prefix && n < prefix + 1000) return true;
    }
    return false;
  }
}

/// Všechna data map (přibalená v aplikaci – fungují offline bez balíčku).
class MapData {
  const MapData({
    required this.basemap,
    required this.places,
    required this.routes,
  });

  final Basemap basemap;
  final List<MapPlace> places;
  final List<MapRoute> routes;

  static Future<MapData> load([AssetBundle? bundle]) async {
    final b = bundle ?? rootBundle;
    final base = jsonDecode(
      await b.loadString('assets/map/basemap.json'),
    ) as Map<String, Object?>;
    List<Float32List> lines(String key) => [
      for (final l in base[key]! as List<Object?>)
        Float32List.fromList([
          for (final v in l! as List<Object?>) (v! as num).toDouble(),
        ]),
    ];
    final data = jsonDecode(
      await b.loadString('assets/map/places.json'),
    ) as Map<String, Object?>;
    return MapData(
      basemap: Basemap(
        land: lines('land'),
        lakes: lines('lakes'),
        rivers: lines('rivers'),
      ),
      places: [
        for (final p in data['places']! as List<Object?>)
          if (p case [
            final String id,
            final String name,
            final String nameEn,
            final String type,
            final num lon,
            final num lat,
            final String refs,
          ])
            MapPlace(
              BiblePlace(
                id: id,
                name: name,
                nameEn: nameEn,
                type: type.isEmpty ? null : type,
                lon: lon.toDouble(),
                lat: lat.toDouble(),
                verseCount: refs.isEmpty ? 0 : refs.split(',').length,
              ),
              refs,
            ),
      ],
      routes: [
        for (final r in data['routes']! as List<Object?>)
          if (r case {
            'id': final String id,
            'name': final String name,
            'description': final String description,
            'color': final String color,
            'stops': final List<Object?> stops,
          })
            MapRoute(
              id: id,
              name: name,
              description: description,
              color: int.parse('FF${color.substring(1)}', radix: 16),
              stops: [
                for (final s in stops)
                  if (s case {
                    'id': final String pid,
                    'name': final String sname,
                    'lon': final num lon,
                    'lat': final num lat,
                  })
                    RouteStop(
                      placeId: pid,
                      name: sname,
                      lon: lon.toDouble(),
                      lat: lat.toDouble(),
                    ),
              ],
            ),
      ],
    );
  }
}
