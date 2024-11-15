import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/controller.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TextController textController = Get.put(TextController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter TTS with GetX'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _displayTextSection(),
            _dropdownLanguageSelector(),
            _buttonSection(),
            _sliderSection(),
          ],
        ),
      ),
    );
  }

  Widget _displayTextSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        textController.textToTranslate.value,
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _dropdownLanguageSelector() {
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
        value: textController.selectedLanguage.value,
        items: textController.languages
            .map((lang) => DropdownMenuItem(
          value: lang['code'],
          child: Text(lang['name']??""),
        ))
            .toList(),
        onChanged: (value) => textController.setLanguage(value!),
      ),
    ));
  }

  Widget _buttonSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(Colors.green, Icons.play_arrow, 'PLAY', textController.speak),
          _buildButton(Colors.red, Icons.stop, 'STOP', textController.stop),
          _buildButton(Colors.orange, Icons.translate, 'TRANSLATE', textController.translateAndSpeak),
        ],
      ),
    );
  }

  Widget _buildButton(Color color, IconData icon, String label, Function onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          color: color,
          onPressed: () => onPressed(),
        ),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }

  Widget _sliderSection() {
    return Column(
      children: [
        Obx(() => Slider(
          value: textController.volume.value,
          onChanged: textController.setVolume,
          min: 0.0,
          max: 1.0,
          divisions: 100,
          label: "Volume: ${textController.volume.value.toStringAsFixed(1)}",
        )),
        Obx(() => Slider(
          value: textController.pitch.value,
          onChanged: textController.setPitch,
          min: 0.5,
          max: 2.0,
          divisions: 100,
          label: "Pitch: ${textController.pitch.value.toStringAsFixed(1)}",
        )),
        Obx(() => Slider(
          value: textController.rate.value,
          onChanged: textController.setRate,
          min: 0.0,
          max: 1.0,
          divisions: 100,
          label: "Rate: ${textController.rate.value.toStringAsFixed(1)}",
        )),
      ],
    );
  }
}