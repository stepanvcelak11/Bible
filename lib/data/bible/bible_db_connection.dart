/// Otevření obsahové databáze podle platformy.
///
/// * Android / iOS: `bible_db_connection_native.dart` – zkopíruje DB z assets
///   do úložiště aplikace a otevře ji nativní SQLite.
/// * Web: `bible_db_connection_web.dart` – SQLite ve WebAssembly; obsah se
///   při prvním spuštění naplní z assets a uloží v prohlížeči (OPFS /
///   IndexedDB), takže pak funguje offline.
library;

export 'bible_db_connection_native.dart'
    if (dart.library.js_interop) 'bible_db_connection_web.dart';
