import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/map/map_data.dart';
import '../../../domain/entities/study_entities.dart';

/// Interaktivní mapa biblického světa (bez síťových dlaždic – vše offline).
///
/// Ekvidistantní válcová projekce s korekcí délky na 32° s. š. (pro oblast
/// Středomoří a Blízkého východu dostatečně věrná). Posun a přiblížení
/// prsty, kolečkem myši nebo dvojitým klepnutím.
class BibleMapView extends StatefulWidget {
  const BibleMapView({
    super.key,
    required this.data,
    this.route,
    this.focus = const [],
    this.selectedPlaceId,
    this.onPlaceTap,
    this.padding = EdgeInsets.zero,
  });

  final MapData data;

  /// Zvýrazněná trasa (tematická mapa).
  final MapRoute? route;

  /// Zvýrazněná místa (např. místa v kapitole). Mapa se na ně přiblíží.
  final List<BiblePlace> focus;
  final String? selectedPlaceId;
  final ValueChanged<BiblePlace>? onPlaceTap;

  /// Okraje, které zakrývají ovládací prvky (pro výpočet „zobrazit vše“).
  final EdgeInsets padding;

  @override
  State<BibleMapView> createState() => BibleMapViewState();
}

class BibleMapViewState extends State<BibleMapView>
    with SingleTickerProviderStateMixin {
  static const _cosLat = 0.848; // cos(32°)
  static const _minZoom = 6.0; // pixelů na stupeň
  static const _maxZoom = 900.0;

  double _lon = 35.3;
  double _lat = 31.8;
  double _zoom = 60;
  Size _size = Size.zero;

  // Gesta
  double _startZoom = 60;
  Offset _lastFocal = Offset.zero;

  // Animace přesunu
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );
  (double, double, double)? _from;
  (double, double, double)? _to;

  @override
  void initState() {
    super.initState();
    _anim.addListener(() {
      final f = _from, t = _to;
      if (f == null || t == null) return;
      final v = Curves.easeInOutCubic.transform(_anim.value);
      setState(() {
        _lon = f.$1 + (t.$1 - f.$1) * v;
        _lat = f.$2 + (t.$2 - f.$2) * v;
        // Zoom interpolovat logaritmicky (plynulejší dojem).
        _zoom = math.exp(
          math.log(f.$3) + (math.log(t.$3) - math.log(f.$3)) * v,
        );
      });
    });
  }

  @override
  void didUpdateWidget(BibleMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.route?.id != widget.route?.id ||
        oldWidget.focus.map((p) => p.id).join() !=
            widget.focus.map((p) => p.id).join()) {
      WidgetsBinding.instance.addPostFrameCallback((_) => fitContent());
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Offset _project(double lon, double lat) => Offset(
    (lon - _lon) * _zoom * _cosLat + _size.width / 2,
    -(lat - _lat) * _zoom + _size.height / 2,
  );

  (double, double) _unproject(Offset p) => (
    (p.dx - _size.width / 2) / (_zoom * _cosLat) + _lon,
    -(p.dy - _size.height / 2) / _zoom + _lat,
  );

  void _animateTo(double lon, double lat, double zoom) {
    _from = (_lon, _lat, _zoom);
    _to = (lon, lat, zoom.clamp(_minZoom, _maxZoom));
    _anim.forward(from: 0);
  }

  /// Přesune mapu na místo.
  void focusPlace(BiblePlace p, {double? zoom}) =>
      _animateTo(p.lon, p.lat, zoom ?? math.max(_zoom, 180));

  /// Přiblíží mapu tak, aby byla vidět trasa / zvýrazněná místa.
  void fitContent() {
    final pts = [
      if (widget.route != null)
        for (final s in widget.route!.stops) (s.lon, s.lat),
      for (final p in widget.focus) (p.lon, p.lat),
    ];
    if (pts.isEmpty || _size.isEmpty) {
      _animateTo(35.3, 31.8, 60);
      return;
    }
    var (minLon, maxLon) = (pts.first.$1, pts.first.$1);
    var (minLat, maxLat) = (pts.first.$2, pts.first.$2);
    for (final (lon, lat) in pts) {
      minLon = math.min(minLon, lon);
      maxLon = math.max(maxLon, lon);
      minLat = math.min(minLat, lat);
      maxLat = math.max(maxLat, lat);
    }
    final pad = widget.padding;
    final w = _size.width - pad.horizontal - 80;
    final h = _size.height - pad.vertical - 80;
    final spanLon = math.max(maxLon - minLon, 0.3);
    final spanLat = math.max(maxLat - minLat, 0.3);
    final zoom = math.min(w / (spanLon * _cosLat), h / spanLat);
    // Střed posunout o asymetrické okraje (lišty nahoře / karta dole).
    final dy = (pad.top - pad.bottom) / 2 / zoom;
    _animateTo(
      (minLon + maxLon) / 2,
      (minLat + maxLat) / 2 + dy,
      math.min(zoom, 260),
    );
  }

  void _onTapUp(TapUpDetails d) {
    final cb = widget.onPlaceTap;
    if (cb == null) return;
    BiblePlace? best;
    var bestDist = 26.0;
    for (final mp in widget.data.places) {
      final p = mp.place;
      final o = _project(p.lon, p.lat);
      final dist = (o - d.localPosition).distance;
      // Přednost mají významnější místa.
      final weight = dist - math.min(p.verseCount, 100) / 20;
      if (dist < 26 && weight < bestDist) {
        bestDist = weight;
        best = p;
      }
    }
    if (best != null) cb(best);
  }

  void _zoomAt(Offset focal, double factor) {
    final (lon, lat) = _unproject(focal);
    setState(() {
      _zoom = (_zoom * factor).clamp(_minZoom, _maxZoom);
      // Bod pod prstem zůstane na místě.
      final after = _project(lon, lat);
      final delta = after - focal;
      _lon += delta.dx / (_zoom * _cosLat);
      _lat -= delta.dy / _zoom;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final first = _size.isEmpty;
        _size = constraints.biggest;
        if (first) {
          WidgetsBinding.instance.addPostFrameCallback((_) => fitContent());
        }
        return Listener(
          onPointerSignal: (e) {
            if (e is PointerScrollEvent) {
              _zoomAt(e.localPosition, e.scrollDelta.dy > 0 ? 0.85 : 1.18);
            }
          },
          child: GestureDetector(
            onScaleStart: (d) {
              _anim.stop();
              _startZoom = _zoom;
              _lastFocal = d.localFocalPoint;
            },
            onScaleUpdate: (d) {
              setState(() {
                if (d.pointerCount > 1) {
                  final target = (_startZoom * d.scale).clamp(
                    _minZoom,
                    _maxZoom,
                  );
                  final (lon, lat) = _unproject(d.localFocalPoint);
                  _zoom = target;
                  final after = _project(lon, lat);
                  final delta = after - d.localFocalPoint;
                  _lon += delta.dx / (_zoom * _cosLat);
                  _lat -= delta.dy / _zoom;
                }
                final move = d.localFocalPoint - _lastFocal;
                _lon -= move.dx / (_zoom * _cosLat);
                _lat += move.dy / _zoom;
                _lastFocal = d.localFocalPoint;
              });
            },
            onTapUp: _onTapUp,
            onDoubleTapDown: (d) => _lastFocal = d.localPosition,
            onDoubleTap: () => _zoomAt(_lastFocal, 2),
            child: CustomPaint(
              size: Size.infinite,
              painter: _MapPainter(
                data: widget.data,
                centerLon: _lon,
                centerLat: _lat,
                route: widget.route,
                focus: {for (final p in widget.focus) p.id},
                selected: widget.selectedPlaceId,
                project: _project,
                zoom: _zoom,
                palette: palette,
                labelStyle: theme.textTheme.labelSmall!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                isDark: theme.brightness == Brightness.dark,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Obrysy v „světových“ souřadnicích (lon·cos φ₀, −lat) – spočítané jednou,
/// při kreslení se jen transformuje plátno.
class _WorldPaths {
  _WorldPaths(Basemap b)
    : land = [for (final r in b.land) _world(r, close: true)],
      lakes = [for (final r in b.lakes) _world(r, close: true)],
      rivers = [for (final r in b.rivers) _world(r, close: false)];

  final List<Path> land;
  final List<Path> lakes;
  final List<Path> rivers;

  static Path _world(Float32List c, {required bool close}) {
    final path = Path();
    for (var i = 0; i + 1 < c.length; i += 2) {
      final x = c[i] * BibleMapViewState._cosLat;
      final y = -c[i + 1];
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    if (close) path.close();
    return path;
  }

  static final _cache = Expando<_WorldPaths>();
  static _WorldPaths of(MapData d) => _cache[d] ??= _WorldPaths(d.basemap);
}

class _MapPainter extends CustomPainter {
  _MapPainter({
    required this.data,
    required this.centerLon,
    required this.centerLat,
    required this.route,
    required this.focus,
    required this.selected,
    required this.project,
    required this.zoom,
    required this.palette,
    required this.labelStyle,
    required this.isDark,
  });

  final MapData data;
  final double centerLon;
  final double centerLat;
  final MapRoute? route;
  final Set<String> focus;
  final String? selected;
  final Offset Function(double lon, double lat) project;
  final double zoom;
  final AppPalette palette;
  final TextStyle labelStyle;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = palette.water);

    final world = _WorldPaths.of(data);
    canvas.save();
    canvas.translate(
      size.width / 2 - centerLon * BibleMapViewState._cosLat * zoom,
      size.height / 2 + centerLat * zoom,
    );
    canvas.scale(zoom);
    final land = Paint()..color = palette.land;
    final coast = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8 / zoom
      ..color = palette.muted.withValues(alpha: 0.45);
    for (final p in world.land) {
      canvas.drawPath(p, land);
      canvas.drawPath(p, coast);
    }
    final lake = Paint()..color = palette.water;
    for (final p in world.lakes) {
      canvas.drawPath(p, lake);
      canvas.drawPath(p, coast);
    }
    final river = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (zoom > 120 ? 1.6 : 1) / zoom
      ..strokeCap = StrokeCap.round
      ..color = Color.lerp(palette.water, Colors.blueGrey, 0.35)!;
    for (final p in world.rivers) {
      canvas.drawPath(p, river);
    }
    canvas.restore();

    // Místa: velikost podle významu, popisky jen tam, kam se vejdou.
    final occupied = <Rect>[];
    final places = [...data.places]
      ..sort((a, b) {
        final fa = focus.contains(a.place.id) || a.place.id == selected;
        final fb = focus.contains(b.place.id) || b.place.id == selected;
        if (fa != fb) return fa ? -1 : 1;
        return b.place.verseCount.compareTo(a.place.verseCount);
      });
    final routeIds = {
      for (final s in route?.stops ?? const <RouteStop>[]) s.placeId,
    };
    final threshold = zoom < 25
        ? 60
        : zoom < 50
        ? 25
        : zoom < 100
        ? 10
        : zoom < 200
        ? 4
        : 1;
    final dim = route != null || focus.isNotEmpty;

    // Trasa pod body.
    if (route case final r?) {
      final color = Color(r.color);
      final line = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color.withValues(alpha: 0.85);
      final path = Path();
      for (final (i, s) in r.stops.indexed) {
        final o = project(s.lon, s.lat);
        i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
      }
      canvas.drawPath(path, line);
      for (var i = 1; i < r.stops.length; i++) {
        _arrow(
          canvas,
          project(r.stops[i - 1].lon, r.stops[i - 1].lat),
          project(r.stops[i].lon, r.stops[i].lat),
          color,
        );
      }
      final seen = <String>{};
      for (final (i, s) in r.stops.indexed) {
        if (!seen.add(s.placeId)) continue;
        final o = project(s.lon, s.lat);
        canvas.drawCircle(o, 11, Paint()..color = color);
        canvas.drawCircle(
          o,
          11,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.white,
        );
        _text(
          canvas,
          '${i + 1}',
          o,
          const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
          center: true,
        );
        final rect = _label(
          canvas,
          s.name,
          o + const Offset(14, -8),
          labelStyle.copyWith(fontWeight: FontWeight.w700),
          occupied,
          force: true,
        );
        if (rect != null) occupied.add(rect);
      }
    }

    for (final mp in places) {
      final p = mp.place;
      if (routeIds.contains(p.id)) continue;
      final highlighted = focus.contains(p.id) || p.id == selected;
      final o = project(p.lon, p.lat);
      if (o.dx < -40 ||
          o.dy < -40 ||
          o.dx > size.width + 40 ||
          o.dy > size.height + 40) {
        continue;
      }
      final important = p.verseCount >= threshold;
      if (!highlighted && !important && zoom < 120) continue;
      final r = highlighted ? 7.0 : (important ? 3.5 : 2.2);
      final color = highlighted
          ? palette.gold
          : (dim ? palette.muted.withValues(alpha: 0.5) : _typeColor(p.type));
      if (highlighted) {
        canvas.drawCircle(
          o,
          r + 5,
          Paint()..color = palette.gold.withValues(alpha: 0.25),
        );
      }
      canvas.drawCircle(o, r, Paint()..color = color);
      canvas.drawCircle(
        o,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = isDark ? Colors.black54 : Colors.white,
      );
      if (highlighted || important) {
        final rect = _label(
          canvas,
          p.name,
          o + Offset(r + 4, -8),
          labelStyle.copyWith(
            fontWeight: highlighted ? FontWeight.w800 : FontWeight.w500,
            color: dim && !highlighted ? palette.muted : null,
          ),
          occupied,
          force: highlighted,
        );
        if (rect != null) occupied.add(rect);
      }
    }
  }

  Color _typeColor(String? type) => switch (type) {
    'settlement' => const Color(0xFF8A5A1F),
    'region' => const Color(0xFF7C8B5A),
    'river' || 'body of water' || 'spring' => const Color(0xFF3F7CAC),
    'mountain' || 'hill' || 'mountain range' => const Color(0xFF8C6BA8),
    _ => palette.muted,
  };

  void _arrow(Canvas canvas, Offset a, Offset b, Color color) {
    final d = b - a;
    if (d.distance < 40) return;
    final mid = a + d * 0.55;
    final angle = d.direction;
    final path = Path()
      ..moveTo(mid.dx + 7 * math.cos(angle), mid.dy + 7 * math.sin(angle))
      ..lineTo(
        mid.dx + 6 * math.cos(angle + 2.5),
        mid.dy + 6 * math.sin(angle + 2.5),
      )
      ..lineTo(
        mid.dx + 6 * math.cos(angle - 2.5),
        mid.dy + 6 * math.sin(angle - 2.5),
      )
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  Rect? _label(
    Canvas canvas,
    String text,
    Offset at,
    TextStyle style,
    List<Rect> occupied, {
    bool force = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final rect = (at & tp.size).inflate(2);
    if (!force && occupied.any((r) => r.overlaps(rect))) return null;
    // Halo pro čitelnost.
    final halo = TextPainter(
      text: TextSpan(
        text: text,
        style: style.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = palette.land.withValues(alpha: 0.9),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    halo.paint(canvas, at);
    tp.paint(canvas, at);
    return rect;
  }

  void _text(
    Canvas canvas,
    String text,
    Offset at,
    TextStyle style, {
    bool center = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center ? at - Offset(tp.width / 2, tp.height / 2) : at);
  }

  @override
  bool shouldRepaint(_MapPainter old) => true;
}
