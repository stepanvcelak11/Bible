import 'package:drift_flutter/drift_flutter.dart';

/// Soubory SQLite pro web (připraví tool/build_web.sh) – leží vedle
/// index.html. Na Androidu/iOS se nepoužívají.
final webDriftOptions = DriftWebOptions(
  sqlite3Wasm: Uri.parse('sqlite3.wasm'),
  driftWorker: Uri.parse('drift_worker.js'),
);
