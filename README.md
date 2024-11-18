
# Flutter Translation and Speech App

This Flutter application fetches text data from an API, translates it to the selected language, and allows users to hear the translated text using Text-to-Speech. The app utilizes the following Flutter packages for seamless functionality:

- `get`: State management and navigation.
- `flutter_tts`: Text-to-speech functionality to read the translated text aloud.
- `translator`: Translation service to convert the fetched text into the selected language.
- `http`: To fetch data from the API.

## Features

- **Fetch Text from API**: The app retrieves text data from a remote API.
- **Text Translation**: Translates the fetched text into the language selected by the user.
- **Text-to-Speech**: Uses `flutter_tts` to read the translated text aloud.
- **User-Friendly Interface**: Provides a simple UI to view the original and translated text.
- **Language Selection**: Allows users to choose their preferred language for translation.

## Installation

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/4ayyappadasks/texttospeach
   ```

2. Navigate to the project directory:

   ```bash
   cd flutter-translation-speech-app
   ```

3. Install the necessary dependencies by running:

   ```bash
   flutter pub get
   ```

## Setup

1. **API Setup**: Ensure you have an API that provides text data. You can replace the API endpoint in the app with your own or use a public API.

2. **Permissions**:
    - For Android: Open the `AndroidManifest.xml` and ensure you have the required permissions for internet access and audio.
    - For iOS: Make sure you update the `Info.plist` with the necessary permissions for audio and internet access.

## Usage

1. **Launch the App**: After setting up, run the application using:

   ```bash
   flutter run
   ```

2. **Fetch Text**: The app will fetch text from the API and display it.

3. **Select Language**: Use the language selector to choose the language you want the text to be translated into.

4. **Listen to the Translation**: Press the "Speaker" button to hear the translated text aloud.

## Code Dependencies

Make sure to include the following dependencies in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
  flutter_tts: ^4.2.0
  translator: ^1.0.2
  http: ^1.2.2
```

## Example Code

Here’s a simple example to illustrate how the app works:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: TranslationScreen(),
    );
  }
}

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

```

Images
![image Alt](https://github.com/4ayyappadasks/texttospeach/blob/f07803758bdccac8794e7a137e0cdc6b4b325c12/ss/banner.jpg)