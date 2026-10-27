import 'speech_stub.dart'
    if (dart.library.js_interop) 'speech_web.dart'
    as impl;

/// Hlasové předčítání (syntéza řeči systému – na iPhonu/iPadu české hlasy
/// fungují i offline).
abstract class Speech {
  static final Speech instance = impl.createSpeech();

  /// Zařízení umí předčítat.
  bool get available;

  /// Je k dispozici český hlas (jinak by text četl cizí hlas).
  bool get hasCzechVoice;

  /// Zařadí texty k přečtení. [onStart] se volá se začátkem každého textu
  /// (index), [onDone] po dočtení posledního (ne po [stop]).
  void speak(
    List<String> texts, {
    required double rate,
    required void Function(int index) onStart,
    required void Function() onDone,
  });

  void pause();
  void resume();
  void stop();
}
