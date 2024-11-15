import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'package:texttranslator/Google_transalate/model/model.dart';

class Transilator extends GetxController {
  var pitch = 1.0.obs;
  var speachRate = 1.0.obs;
  var inputtext = "".obs;
  var translatedText = "".obs;
  var inputlanguage = "en".obs;
  var outputlanguage = "hi".obs;
  var apiload = false.obs;
  var play = false.obs;
  var isTranslating = false.obs;
  Language? languagemodel;
  FlutterTts flutterTts = FlutterTts();
  GoogleTranslator googleTranslator = GoogleTranslator();

  final Map<String, Map<String, double>> languageSettings = {
    'en': {'pitch': 1.0, 'rate': 0.5},
    'hi': {'pitch': 1.2, 'rate': 0.6},
    'bn': {'pitch': 1.1, 'rate': 0.5},
    'te': {'pitch': 1.0, 'rate': 0.55},
    'mr': {'pitch': 1.1, 'rate': 0.5},
    'ta': {'pitch': 1.0, 'rate': 0.6},
    'gu': {'pitch': 1.2, 'rate': 0.5},
    'ur': {'pitch': 1.0, 'rate': 0.55},
    'kn': {'pitch': 1.1, 'rate': 0.6},
    'or': {'pitch': 1.0, 'rate': 0.5},
    'ml': {'pitch': 1.1, 'rate': 0.55},
    'pa': {'pitch': 1.0, 'rate': 0.5},
    'as': {'pitch': 1.2, 'rate': 0.6},
  };

  @override
  void onInit() {
    super.onInit();
    _initTtsHandlers();
    Apicall();
  }

  void _initTtsHandlers() {
    flutterTts.setCompletionHandler(() {
      play.value = false;
    });

    flutterTts.setCancelHandler(() {
      play.value = false;
    });

    flutterTts.setErrorHandler((msg) {
      play.value = false;
      if (kDebugMode) {
        print("TTS Error: $msg");
      }
    });
  }

  void initSetting() async {
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(pitch.value);
    await flutterTts.setSpeechRate(speachRate.value);
    await flutterTts.setLanguage(outputlanguage.value);
  }

  void speak() async {
    initSetting();
    String textToSpeak = translatedText.value.isNotEmpty
        ? translatedText.value
        : inputtext.value;

    await flutterTts.speak(textToSpeak);
    play.value = true;
  }

  void stop() async {
    await flutterTts.stop();
    play.value = false;
  }

  void pause() async {
    await flutterTts.pause();
    play.value = false;
  }

  void transalatetext() async {
    isTranslating.value = true;
    try {
      final translated = await googleTranslator.translate(
        inputtext.value,
        from: inputlanguage.value,
        to: outputlanguage.value,
      );
      translatedText.value = translated.text;
    } catch (e) {
      translatedText.value = "Error during translation: $e";
    } finally {
      isTranslating.value = false;
    }
  }

  void Apicall() async {
    try {
      apiload.value = true;
      var response = await http.get(Uri.parse("https://dummyjson.com/c/b5c4-a125-4d3b-866d"));
      if (response.statusCode == 200) {
        languagemodel = languageFromJson(response.body);
        inputtext.value = languagemodel?.data.text ?? "";
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      throw Exception("API call error: $e");
    } finally {
      apiload.value = false;
    }
  }
}
