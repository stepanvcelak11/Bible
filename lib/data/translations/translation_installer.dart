import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../bible/bible_database.dart';
import 'translation_parsers.dart';

/// Překlad z katalogu (assets/db/catalog.json, generuje build_bible_db.py).
@immutable
class CatalogTranslation {
  const CatalogTranslation({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.available,
    this.year,
    this.license,
    this.description,
    this.url,
    this.sizeMb,
  });

  factory CatalogTranslation.fromJson(Map<String, Object?> j) =>
      CatalogTranslation(
        id: j['id']! as String,
        name: j['name']! as String,
        abbreviation: j['abbreviation'] as String? ?? j['id']! as String,
        available: j['available'] as bool? ?? true,
        year: j['year'] as int?,
        license: j['license'] as String?,
        description: j['description'] as String?,
        url: j['url'] as String?,
        sizeMb: (j['size_mb'] as num?)?.toDouble(),
      );

  final String id;
  final String name;
  final String abbreviation;

  /// `false` = vydavatel text volně nešíří (jen informativní položka).
  final bool available;
  final int? year;
  final String? license;
  final String? description;
  final String? url;
  final double? sizeMb;
}

/// Fáze instalace pro zobrazení průběhu.
sealed class InstallProgress {
  const InstallProgress();
}

final class Downloading extends InstallProgress {
  const Downloading(this.received, this.total);

  final int received;
  final int? total;

  double? get fraction =>
      total == null || total == 0 ? null : (received / total!).clamp(0, 1);
}

final class Processing extends InstallProgress {
  const Processing();
}

final class Saving extends InstallProgress {
  const Saving();
}

/// Chyba při stahování (síť, server…).
class DownloadException implements Exception {
  const DownloadException(this.message);

  final String message;

  @override
  String toString() => 'DownloadException: $message';
}

/// Stahuje překlady přímo do zařízení a ukládá je do databáze stažených
/// překladů. Text se stahuje od distributora (CrossWire / scrollmapper),
/// takže se chráněné překlady nikdy nešíří přes tuto aplikaci.
class TranslationInstaller {
  TranslationInstaller(this._db, {http.Client? client, AssetBundle? bundle})
    : _client = client ?? http.Client(),
      _bundle = bundle ?? rootBundle;

  final BibleDatabase _db;
  final http.Client _client;
  final AssetBundle _bundle;

  static const catalogAsset = 'assets/db/catalog.json';

  /// Katalog překladů ke stažení (prázdný, pokud v balíčku chybí).
  Future<List<CatalogTranslation>> loadCatalog() async {
    try {
      final json = jsonDecode(
        await _bundle.loadString(catalogAsset),
      ) as Map<String, Object?>;
      return [
        for (final t in json['translations']! as List<Object?>)
          CatalogTranslation.fromJson(t! as Map<String, Object?>),
      ];
    } on FlutterError {
      return const [];
    }
  }

  /// Stáhne, zpracuje a uloží překlad z katalogu.
  Future<void> install(
    CatalogTranslation entry, {
    required int sortOrder,
    void Function(InstallProgress)? onProgress,
  }) async {
    final url = entry.url;
    if (url == null) throw const DownloadException('Překlad nelze stáhnout.');
    final bytes = await _download(Uri.parse(url), onProgress);
    onProgress?.call(const Processing());
    final parsed = await parseTranslation(utf8.decode(bytes));
    onProgress?.call(const Saving());
    await save(
      parsed,
      id: entry.id,
      name: entry.name,
      abbreviation: entry.abbreviation,
      year: entry.year,
      license: entry.license,
      description: entry.description,
      sortOrder: sortOrder,
    );
  }

  /// Import vlastního souboru (OSIS / Zefania / JSON) – např. překlad, který
  /// má uživatel legálně z jiného zdroje.
  Future<int> importFile(
    Uint8List bytes, {
    required String id,
    required String name,
    required String abbreviation,
    required int sortOrder,
    void Function(InstallProgress)? onProgress,
  }) async {
    onProgress?.call(const Processing());
    final parsed = await parseTranslation(
      utf8.decode(bytes, allowMalformed: true),
    );
    if (parsed.verses.isEmpty) {
      throw const TranslationFormatException('Soubor neobsahuje žádné verše.');
    }
    onProgress?.call(const Saving());
    await save(
      parsed,
      id: id,
      name: name,
      abbreviation: abbreviation,
      sortOrder: sortOrder,
    );
    return parsed.verses.length;
  }

  Future<Uint8List> _download(
    Uri uri,
    void Function(InstallProgress)? onProgress,
  ) async {
    final http.StreamedResponse response;
    try {
      response = await _client.send(http.Request('GET', uri));
    } catch (e) {
      throw DownloadException('Nelze se připojit ($e).');
    }
    if (response.statusCode != 200) {
      throw DownloadException(
        'Server odpověděl chybou ${response.statusCode}.',
      );
    }
    final total = response.contentLength;
    final builder = BytesBuilder(copy: false);
    var lastReport = 0;
    await for (final chunk in response.stream) {
      builder.add(chunk);
      // Hlásit průběh nejvýš po ~1 %, ať se zbytečně nepřekresluje.
      if (builder.length - lastReport > 100000) {
        lastReport = builder.length;
        onProgress?.call(Downloading(builder.length, total));
      }
    }
    onProgress?.call(Downloading(builder.length, total));
    return builder.takeBytes();
  }

  /// Uloží rozparsovaný překlad (nahradí případnou starší verzi).
  Future<void> save(
    ParsedTranslation parsed, {
    required String id,
    required String name,
    required String abbreviation,
    int? year,
    String? license,
    String? description,
    required int sortOrder,
  }) async {
    await remove(id);
    await _db.transaction(() async {
      await _db
          .into(_db.translations)
          .insert(
            TranslationsCompanion.insert(
              id: id,
              name: name,
              abbreviation: abbreviation,
              year: Value(year),
              license: Value(license),
              description: Value(description),
              sortOrder: Value(sortOrder),
              verseCount: Value(parsed.verses.length),
            ),
          );
      await _db.batch((b) {
        b.insertAll(_db.verses, [
          for (final v in parsed.verses)
            VersesCompanion.insert(
              translationId: id,
              bookId: v.bookId,
              chapter: v.chapter,
              verse: v.verse,
              text$: v.text,
              paragraph: Value(v.paragraph ? 1 : 0),
              poetry: Value(v.poetry ? 1 : 0),
            ),
        ]);
        for (final (table, items) in [
          ('headings', parsed.headings),
          ('footnotes', parsed.footnotes),
        ]) {
          final counters = <(int, int, int), int>{};
          for (final n in items) {
            final key = (n.bookId, n.chapter, n.verse);
            final ord = counters[key] ?? 0;
            counters[key] = ord + 1;
            b.customStatement(
              'INSERT OR IGNORE INTO $table '
              '(translation_id, book_id, chapter, verse, ord, text) '
              'VALUES (?, ?, ?, ?, ?, ?)',
              [id, n.bookId, n.chapter, n.verse, ord, n.text],
            );
          }
        }
      });
      await _db.customStatement(
        'INSERT INTO chapters (translation_id, book_id, chapter, verse_count) '
        'SELECT translation_id, book_id, chapter, MAX(verse) FROM verses '
        'WHERE translation_id = ? GROUP BY book_id, chapter',
        [id],
      );
      // Fulltext jen pro nový překlad (ostatní zůstávají beze změny).
      await _db.customStatement(
        'INSERT INTO verses_fts (rowid, text) '
        'SELECT id, text FROM verses WHERE translation_id = ?',
        [id],
      );
    });
  }

  /// Odstraní stažený překlad včetně fulltextového indexu.
  Future<void> remove(String id) => _db.transaction(() async {
    // External-content FTS: záznamy je nutné odebrat explicitně.
    await _db.customStatement(
      'INSERT INTO verses_fts (verses_fts, rowid, text) '
      "SELECT 'delete', id, text FROM verses WHERE translation_id = ?",
      [id],
    );
    for (final table in [
      'verses',
      'chapters',
      'headings',
      'footnotes',
      'translations',
    ]) {
      await _db.customStatement(
        'DELETE FROM $table WHERE ${table == 'translations' ? 'id' : 'translation_id'} = ?',
        [id],
      );
    }
  });
}
