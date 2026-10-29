import 'package:flutter/widgets.dart';

import 'browser_chrome_stub.dart'
    if (dart.library.js_interop) 'browser_chrome_web.dart'
    as impl;

/// Barva systémového pruhu nahoře (stavový řádek nainstalované webové
/// aplikace, lišta prohlížeče) – aby splynula s pozadím aplikace.
void setBrowserThemeColor(Color color) => impl.setThemeColor(color);
