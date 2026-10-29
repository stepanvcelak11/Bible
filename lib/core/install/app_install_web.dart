import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart';

import 'app_install.dart';

AppInstall createAppInstall() => _WebInstall();

@JS('window')
external JSObject get _window;

class _WebInstall implements AppInstall {
  _WebInstall() {
    _window.callMethod(
      'addEventListener'.toJS,
      'bible-install-changed'.toJS,
      ((JSAny _) => _refresh()).toJS,
    );
    _refresh();
  }

  final _available = ValueNotifier(false);

  @override
  ValueListenable<bool> get available => _available;

  void _refresh() {
    final event = _window.getProperty<JSAny?>('bibleInstallEvent'.toJS);
    _available.value = event != null && !event.isUndefinedOrNull;
  }

  @override
  Future<bool> install() async {
    if (!_window.has('bibleInstall')) return false;
    final result = await _window
        .callMethod<JSPromise<JSBoolean>>('bibleInstall'.toJS)
        .toDart;
    _refresh();
    return result.toDart;
  }
}
