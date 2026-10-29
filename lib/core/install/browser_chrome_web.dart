import 'dart:js_interop';

import 'package:flutter/widgets.dart';

@JS('bibleSetThemeColor')
external void _setThemeColor(String color);

void setThemeColor(Color color) {
  final hex = (color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
  try {
    _setThemeColor('#$hex');
  } catch (_) {
    // Starší index.html bez funkce – nic.
  }
}
