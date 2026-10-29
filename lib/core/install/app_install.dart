import 'package:flutter/foundation.dart';

import 'app_install_stub.dart'
    if (dart.library.js_interop) 'app_install_web.dart'
    as impl;

/// Instalace webové verze jako aplikace (Android, Chrome na počítači).
/// Prohlížeč instalaci nabídne až ve chvíli, kdy ji umí provést; pak
/// [available] přepne na true a aplikace ukáže tlačítko.
abstract class AppInstall {
  static final AppInstall instance = impl.createAppInstall();

  /// Lze nabídnout instalaci (prohlížeč ji připravil).
  ValueListenable<bool> get available;

  /// Otevře systémový dialog instalace; true = uživatel potvrdil.
  Future<bool> install();
}
