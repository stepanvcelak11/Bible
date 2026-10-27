/// Uložení a otevření studijního balíčku podle platformy.
library;

export 'study_connection_native.dart'
    if (dart.library.js_interop) 'study_connection_web.dart';
