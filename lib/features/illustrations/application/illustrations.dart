import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/versification.dart';

/// Jednoduchá čárová kresba k místu v Bibli (vlastní kresby aplikace).
///
/// Kresba je uložená jako tahy „M x y l dx dy …“ v plátně [width] × [height];
/// stejná pro všechny překlady, odkaz je v kanonickém číslování.
class Illustration {
  Illustration({
    required this.ref,
    required this.caption,
    required this.width,
    required this.height,
    required this.data,
  });

  factory Illustration.fromJson(Map<String, Object?> j) {
    final r = (j['r']! as List).cast<int>();
    return Illustration(
      ref: VerseRef(r[0], r[1], r[2]),
      caption: j['t']! as String,
      width: (j['w']! as num).toDouble(),
      height: (j['h']! as num).toDouble(),
      data: j['d']! as String,
    );
  }

  final VerseRef ref;
  final String caption;
  final double width;
  final double height;
  final String data;

  /// Tahy jako cesta – hladké oblouky, ostré rohy zůstanou ostré.
  late final Path path = parseSketch(data);
}

/// Převede „M x y l dx dy dx dy … M …“ na cestu. Body lomené čáry se
/// spojí kvadratickými oblouky přes středy úseků; kde čára prudce zatáčí
/// (roh domu, cimbuří), vede rovně do bodu.
Path parseSketch(String data) {
  final path = Path();
  for (final stroke in data.split('M')) {
    if (stroke.trim().isEmpty) continue;
    final parts = stroke.split('l');
    final start = parts[0].trim().split(' ');
    var x = double.parse(start[0]);
    var y = double.parse(start[1]);
    final pts = <Offset>[Offset(x, y)];
    if (parts.length > 1) {
      final nums = parts[1].trim().split(' ');
      for (var i = 0; i + 1 < nums.length; i += 2) {
        x += double.parse(nums[i]);
        y += double.parse(nums[i + 1]);
        pts.add(Offset(x, y));
      }
    }
    path.moveTo(pts[0].dx, pts[0].dy);
    var cur = pts[0];
    for (var i = 1; i < pts.length; i++) {
      final p = pts[i];
      if (i == pts.length - 1) {
        path.lineTo(p.dx, p.dy);
        break;
      }
      final n = pts[i + 1];
      final a1 = (p - cur).direction;
      final a2 = (n - p).direction;
      var turn = (a2 - a1).abs();
      if (turn > 3.14159) turn = 6.28318 - turn;
      if (turn > 0.7) {
        path.lineTo(p.dx, p.dy);
        cur = p;
      } else {
        final m = Offset((p.dx + n.dx) / 2, (p.dy + n.dy) / 2);
        path.quadraticBezierTo(p.dx, p.dy, m.dx, m.dy);
        cur = m;
      }
    }
  }
  return path;
}

final illustrationsProvider = FutureProvider<List<Illustration>>((ref) async {
  final bytes = await rootBundle.load('assets/content/illustrations.json');
  final j =
      jsonDecode(utf8.decode(bytes.buffer.asUint8List()))
          as Map<String, Object?>;
  return [
    for (final i in j['items']! as List)
      Illustration.fromJson(i as Map<String, Object?>),
  ];
});

/// Ilustrace v kapitole překladu: číslo verše (v číslování překladu) →
/// kresby u něj.
final chapterIllustrationsProvider =
    Provider.family<Map<int, List<Illustration>>, (String, int, int)>((
      ref,
      key,
    ) {
      final (translationId, bookId, chapter) = key;
      final all = ref.watch(illustrationsProvider).value;
      if (all == null) return const {};
      final out = <int, List<Illustration>>{};
      for (final il in all) {
        if (il.ref.bookId != bookId) continue;
        final r = Versification.fromCanonical(il.ref, translationId);
        if (r.chapter != chapter) continue;
        (out[r.verse] ??= []).add(il);
      }
      return out;
    });
