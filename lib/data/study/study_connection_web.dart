import 'dart:typed_data';

import 'package:drift/wasm.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../web_drift_options.dart';
import 'study_database.dart';

/// Na webu leží balíček na stejném webu (GitHub Pages) – relativní cesta.
const studyBaseUrl = 'data/';

Uint8List? _pending;

/// Uloží rozbalený balíček do úložiště prohlížeče (při prvním otevření).
Future<void> storeStudyPack(String version, Uint8List bytes) async {
  _pending = bytes;
  final db = await openStudyPack(version, create: true);
  // Otevření provede zápis do IndexedDB/OPFS; pak ho zase zavřeme.
  await db?.customSelect('SELECT 1').get();
  await db?.close();
  _pending = null;
}

/// Otevře nainstalovaný balíček. Volající zaručuje (přes preference), že
/// verze je nainstalovaná; `create` se používá jen při instalaci.
Future<StudyDatabase?> openStudyPack(
  String version, {
  bool create = false,
}) async {
  return StudyDatabase(
    driftDatabase(
      name: 'study_$version',
      web: DriftWebOptions(
        sqlite3Wasm: webDriftOptions.sqlite3Wasm,
        driftWorker: webDriftOptions.driftWorker,
        initializeDatabase: () => _pending,
      ),
    ),
  );
}

/// Odstraní balíček z prohlížeče.
Future<void> deleteStudyPack(String version) async {
  try {
    final storages = await WasmDatabase.probe(
      sqlite3Uri: webDriftOptions.sqlite3Wasm,
      driftWorkerUri: webDriftOptions.driftWorker,
    );
    for (final (storage, name) in storages.existingDatabases) {
      if (name.startsWith('study_')) {
        await storages.deleteDatabase((storage, name));
      }
    }
  } catch (_) {
    // Nepodařilo se – data zůstanou, ale aplikace je přestane používat.
  }
}
