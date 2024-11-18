import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  String originalText = "";
  String translatedText = "";
  String targetLanguage = "ml";
  var pitch = 1.0;
  var speechRate = 0.6;
  final translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    fetchData();
    initTTSSettings();
  }

  Future<void> initTTSSettings() async {
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(speechRate);
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/c/b5c4-a125-4d3b-866d'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        String fetchedText = jsonResponse['data']['text'];
        setState(() {
          originalText = fetchedText;
        });
        translateText(fetchedText, targetLanguage);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> translateText(String text, String targetLanguage) async {
    try {
      var translation = await translator.translate(text, to: targetLanguage);
      setState(() {
        translatedText = translation.text;
      });
    } catch (e) {
      print('Error translating text: $e');
    }
  }


  Future<void> speakText(String text) async {
    try {
      await flutterTts.setLanguage(targetLanguage);
      await flutterTts.speak(text);
    } catch (e) {
      print('Error during speech synthesis: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translation and Speech App')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Original Text:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(originalText.isEmpty ? 'Loading...' : originalText, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                const Text('Translated Text:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(translatedText.isEmpty ? 'Translating...' : translatedText, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: translatedText.isNotEmpty ? () => speakText(translatedText) : null,
                  child: const Text('Speak Translation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
