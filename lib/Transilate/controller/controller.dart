import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

class TextController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final GoogleTranslator translator = GoogleTranslator();

  var volume = 0.5.obs;
  var pitch = 1.0.obs;
  var rate = 0.5.obs;
  var selectedLanguage = 'ml'.obs;
  var textToTranslate =
      "Dr Tomas Streyer looked around the control room at his team of scientists and engineers. He was pretending to be calm, but he was both excited and terrified. The next few minutes would be the starting point of years more research towards understanding the secrets of how the universe began.\n\nHe looked out of the window at the beautiful blue summer sky and took a deep breath.\n\n'Ready,' he said, and pressed the first button, bringing to life the complicated computers and machines around them.\n\n'Set,' he said, and pressed the second button, switching on the huge particle accelerator that lay in a huge underground laboratory, deep beneath the towns and fields of Switzerland."
          .obs;

  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Hindi', 'code': 'hi'},
    {'name': 'Bengali', 'code': 'bn'},
    {'name': 'Telugu', 'code': 'te'},
    {'name': 'Marathi', 'code': 'mr'},
    {'name': 'Tamil', 'code': 'ta'},
    {'name': 'Gujarati', 'code': 'gu'},
    {'name': 'Urdu', 'code': 'ur'},
    {'name': 'Kannada', 'code': 'kn'},
    {'name': 'Odia', 'code': 'or'},
    {'name': 'Malayalam', 'code': 'ml'},
    {'name': 'Punjabi', 'code': 'pa'},
    {'name': 'Assamese', 'code': 'as'},
    {'name': 'Maithili', 'code': 'mai'},
    {'name': 'Santali', 'code': 'sat'},
    // Add other languages here as needed
  ];


  @override
  void onInit() {
    super.onInit();
    _initializeTts();
  }

  void _initializeTts() {
    flutterTts.setStartHandler(() {
      print("TTS Playing");
    });
    flutterTts.setCompletionHandler(() {
      print("TTS Complete");
    });
    flutterTts.setCancelHandler(() {
      print("TTS Canceled");
    });
  }

  void setLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
  }

  void setVolume(double newVolume) {
    volume.value = newVolume;
  }

  void setPitch(double newPitch) {
    pitch.value = newPitch;
  }

  void setRate(double newRate) {
    rate.value = newRate;
  }

  Future<void> speak() async {
    await flutterTts.setVolume(volume.value);
    await flutterTts.setSpeechRate(rate.value);
    await flutterTts.setPitch(pitch.value);
    await flutterTts.speak(textToTranslate.value);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  Future<void> translateAndSpeak() async {
    var translation = await translator.translate(
      textToTranslate.value,
      from: 'en',
      to: selectedLanguage.value,
    );
    textToTranslate.value = translation.text;
    await speak();
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
