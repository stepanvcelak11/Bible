import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Chyba: v balíčku aplikace chybí databáze Bible (nebyl spuštěn
/// `tool/build_bible_db.py`).
class BibleDataMissingException implements Exception {
  const BibleDataMissingException(this.cause);

  final Object cause;

  @override
  String toString() => 'BibleDataMissingException: $cause';
}

/// Zajistí, že v úložišti aplikace leží aktuální kopie obsahové databáze.
///
/// SQLite neumí otevřít soubor přímo z assets, proto se `bible.db` při
/// prvním spuštění (a po každé aktualizaci obsahu) zkopíruje do adresáře
/// aplikace. Rozhoduje `content_version` z `bible_manifest.json` – při
/// běžném startu se tak čte jen malý JSON, žádné megabajty.
///
/// Kopírování je atomické (zápis do `.tmp` + přejmenování), takže ani pád
/// aplikace uprostřed kopírování nezanechá poškozenou databázi.
class BibleDbInstaller {
  BibleDbInstaller({
    AssetBundle? bundle,
    Future<Directory> Function()? baseDirectory,
  }) : _bundle = bundle ?? rootBundle,
       _baseDirectory = baseDirectory ?? getApplicationSupportDirectory;

  static const dbAsset = 'assets/db/bible.db';
  static const manifestAsset = 'assets/db/bible_manifest.json';
  static const _dbFileName = 'bible.db';
  static const _versionFileName = 'bible.db.version';

  final AssetBundle _bundle;
  final Future<Directory> Function() _baseDirectory;

  /// Vrátí soubor připravené databáze; v případě potřeby ji nainstaluje.
  Future<File> ensureInstalled() async {
    final bundledVersion = await _readBundledVersion();

    final dir = Directory(p.join((await _baseDirectory()).path, 'bible'));
    await dir.create(recursive: true);
    final dbFile = File(p.join(dir.path, _dbFileName));
    final versionFile = File(p.join(dir.path, _versionFileName));

    if (await dbFile.exists() && await versionFile.exists()) {
      final installed = (await versionFile.readAsString()).trim();
      if (installed == bundledVersion) return dbFile;
    }

    await _install(dbFile, versionFile, bundledVersion);
    return dbFile;
  }

  Future<String> _readBundledVersion() async {
    try {
      final json = jsonDecode(
        await _bundle.loadString(manifestAsset, cache: false),
      );
      return (json as Map<String, Object?>)['content_version']! as String;
    } catch (e) {
      throw BibleDataMissingException(e);
    }
  }

  Future<void> _install(File dbFile, File versionFile, String version) async {
    final ByteData data;
    try {
      data = await _bundle.load(dbAsset);
    } catch (e) {
      throw BibleDataMissingException(e);
    }

    final tmp = File('${dbFile.path}.tmp');
    await tmp.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
    // Verzi zneplatníme před výměnou souboru: pokud by proces spadl mezi
    // přejmenováním a zápisem verze, příští start instalaci zopakuje.
    if (await versionFile.exists()) await versionFile.delete();
    await tmp.rename(dbFile.path);
    await versionFile.writeAsString(version, flush: true);
  }
}
