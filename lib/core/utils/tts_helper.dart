import 'package:flutter_tts/flutter_tts.dart';

class TtsHelper {
  final FlutterTts _tts = FlutterTts();

  TtsHelper() {
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(0.5); //tezli
    _tts.setPitch(1.0); // balan yo pas ohang
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
