import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'speech.dart';

Speech createSpeech() => _WebSpeech();

@JS('speechSynthesis')
external _Synthesis get _synthesis;

extension type _Synthesis(JSObject _) implements JSObject {
  external void speak(_Utterance utterance);
  external void cancel();
  external void pause();
  external void resume();
  external JSArray<_Voice> getVoices();
}

@JS('SpeechSynthesisUtterance')
extension type _Utterance._(JSObject _) implements JSObject {
  external factory _Utterance(String text);
  external set lang(String value);
  external set rate(double value);
  external set voice(_Voice? value);
  external set onstart(JSFunction? value);
  external set onend(JSFunction? value);
  external set onerror(JSFunction? value);
}

extension type _Voice(JSObject _) implements JSObject {
  external String get lang;
  external String get name;
  external bool get localService;
}

class _WebSpeech implements Speech {
  /// Generace fronty – zastavené čtení už nesmí volat zpětná volání.
  var _generation = 0;

  /// Odkazy na promluvy, aby je prohlížeč neuvolnil před koncem (Chrome).
  final _queue = <_Utterance>[];

  @override
  bool get available =>
      globalContext.has('speechSynthesis') &&
      globalContext.has('SpeechSynthesisUtterance');

  _Voice? get _czechVoice {
    if (!available) return null;
    final voices = _synthesis.getVoices().toDart;
    final czech = voices.where((v) => v.lang.toLowerCase().startsWith('cs'));
    // Přednost má hlas v zařízení (funguje bez internetu).
    return czech.where((v) => v.localService).firstOrNull ?? czech.firstOrNull;
  }

  @override
  bool get hasCzechVoice => _czechVoice != null;

  @override
  void speak(
    List<String> texts, {
    required double rate,
    required void Function(int index) onStart,
    required void Function() onDone,
  }) {
    if (!available || texts.isEmpty) return;
    stop();
    final generation = ++_generation;
    final voice = _czechVoice;
    for (final (i, text) in texts.indexed) {
      final u = _Utterance(text)
        ..lang = 'cs-CZ'
        ..rate = rate
        ..voice = voice
        ..onstart = (JSAny? _) {
          if (generation == _generation) onStart(i);
        }.toJS;
      if (i == texts.length - 1) {
        u.onend = (JSAny? _) {
          if (generation == _generation) onDone();
        }.toJS;
      }
      _queue.add(u);
      _synthesis.speak(u);
    }
  }

  @override
  void pause() {
    if (available) _synthesis.pause();
  }

  @override
  void resume() {
    if (available) _synthesis.resume();
  }

  @override
  void stop() {
    _generation++;
    _queue.clear();
    if (available) _synthesis.cancel();
  }
}
