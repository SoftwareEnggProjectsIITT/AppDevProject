import 'package:flutter_tts/flutter_tts.dart';


class Tts {

  Tts({required this.text});
  final String text;
  final FlutterTts flutterTts = FlutterTts();

  Future<void> speak() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.7);
    await flutterTts.speak(text);
  }

  get fTts {
    return flutterTts;
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }
}