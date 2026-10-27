// Web worker Driftu pro webovou verzi aplikace.
// Kompiluje se do build/web/drift_worker.js skriptem tool/build_web.sh,
// takže verze vždy odpovídá balíčku drift v pubspec.lock.
import 'package:drift/wasm.dart';

void main() => WasmDatabase.workerMainForOpen();
