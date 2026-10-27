import 'dart:convert';

import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';

import '../web_drift_options.dart';
import 'bible_data_missing_exception.dart';
import 'bible_database.dart';

const _dbAsset = 'assets/db/bible.db';
const _manifestAsset = 'assets/db/bible_manifest.json';

/// Webové otevření: SQLite ve WebAssembly.
///
/// Název databáze obsahuje verzi obsahu – nová verze dat se tak uloží jako
/// nová databáze a naplní se z assets (`initializeDatabase` se volá jen
/// tehdy, když databáze v prohlížeči ještě neexistuje).
Future<BibleDatabase> openBibleDatabase() async {
  final String version;
  try {
    final manifest = jsonDecode(await rootBundle.loadString(_manifestAsset));
    version = (manifest as Map<String, Object?>)['content_version']! as String;
  } catch (e) {
    throw BibleDataMissingException(e);
  }

  return BibleDatabase(
    driftDatabase(
      name: 'bible_$version',
      web: DriftWebOptions(
        sqlite3Wasm: webDriftOptions.sqlite3Wasm,
        driftWorker: webDriftOptions.driftWorker,
        initializeDatabase: () async {
          final data = await rootBundle.load(_dbAsset);
          return data.buffer.asUint8List(
            data.offsetInBytes,
            data.lengthInBytes,
          );
        },
      ),
    ),
  );
}

/// Databáze překladů stažených v aplikaci (uložená v prohlížeči).
Future<BibleDatabase> openDownloadsDatabase() async => BibleDatabase(
  driftDatabase(name: 'bible_downloads', web: webDriftOptions),
  downloads: true,
);
