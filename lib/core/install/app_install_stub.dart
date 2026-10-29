import 'package:flutter/foundation.dart';

import 'app_install.dart';

AppInstall createAppInstall() => _NoInstall();

class _NoInstall implements AppInstall {
  @override
  final ValueListenable<bool> available = ValueNotifier(false);

  @override
  Future<bool> install() async => false;
}
