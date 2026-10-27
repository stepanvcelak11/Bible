import 'speech.dart';

Speech createSpeech() => _NoSpeech();

class _NoSpeech implements Speech {
  @override
  bool get available => false;

  @override
  bool get hasCzechVoice => false;

  @override
  void speak(
    List<String> texts, {
    required double rate,
    required void Function(int index) onStart,
    required void Function() onDone,
  }) {}

  @override
  void pause() {}

  @override
  void resume() {}

  @override
  void stop() {}
}
