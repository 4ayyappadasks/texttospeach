import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texttranslator/Google_transalate/Controller/google_controller2.dart';

class Myhomepage22 extends StatelessWidget {
  Myhomepage22({super.key});
  final Languagecontroller = Get.put(Transilator());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text Translator"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(
              () => Languagecontroller.apiload.value
              ? const Center(child: CircularProgressIndicator())
              :  _buildTranslationDisplay(Languagecontroller),
        ),
      ),
    );
  }

  Widget _buildControlButtons(Transilator controller) {
    return Row(
      children: [
        _buildLanguageDropdown(controller.outputlanguage,
          controller.inputlanguage,),
        Spacer(),
        IconButton(   onPressed: () {
          controller.play.value ? controller.pause() : controller.speak();
        }, icon: Icon(controller.play.value ?CupertinoIcons.speaker_slash_fill:CupertinoIcons.speaker_2_fill)),
        IconButton(onPressed: () {
          controller.stop();
        }, icon: Icon(CupertinoIcons.stop_fill)),
      ],);
  }

  Widget _buildSliderSection(
      String label, RxDouble value, double min, double max) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: Obx(
                    () => Slider(
                  value: value.value,
                  min: min,
                  max: max,
                  onChanged: (newValue) async {
                    value.value = newValue;
                    if (Languagecontroller.play.value) {
                      await Languagecontroller.stop();
                      Languagecontroller.initSetting();
                      Languagecontroller.speak();
                    }
                  },
                ),
              ),
            ),
            Obx(
                  () => Text(
                value.value.toStringAsFixed(2),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(Transilator controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLanguageDropdown(
          controller.outputlanguage,
          controller.inputlanguage,
        ),
      ],
    );
  }

  Widget _buildLanguageDropdown(
     RxString selectedLanguage, RxString? inputlanguage) {
    return Obx(
          () => DropdownButton<String>(
        value: selectedLanguage.value,
        items: <Map<String, String>>[
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
        ].map<DropdownMenuItem<String>>((Map<String, String> lang) {
          return DropdownMenuItem<String>(
            value: lang['code'],
            child: Text(lang['name'] ?? ""),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            selectedLanguage.value = value;
            final settings =
                Languagecontroller.languageSettings[value] ??
                    {'pitch': 1.0, 'rate': 1.0};
            Languagecontroller.pitch.value = settings['pitch']!;
            Languagecontroller.speachRate.value = settings['rate']!;
            Languagecontroller.initSetting();
          }
          Languagecontroller.stop();
          Languagecontroller.transalatetext();
        },
      ),
    );
  }

  Widget _buildTranslationDisplay(Transilator controller) {
    return Obx(
          () {
            return Column(
              children: [
                Expanded(
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fixed "Original Text:"
                          const Text(
                            "Original Text:",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          // Scrollable content
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                controller.inputtext.value,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.isTranslating.value)
                            const Center(child: CircularProgressIndicator(color:  Color(0xFF1B6535)))
                          else ...[
                            const Text(
                              "Translated Text:",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Text(
                                  controller.translatedText.value,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            _buildControlButtons(controller)
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
    );
  }
}


/// don't remove this code
// class dummy extends StatelessWidget {
//    dummy({super.key});
//   final Languagecontroller = Get.put(Transilator());
//   @override
//   Widget build(BuildContext context) {
//     Languagecontroller.initTtsHandlers();
//     return Scaffold(
//       appBar: AppBar(
//         forceMaterialTransparency: true,
//         title: const Text("Text Translator"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Obx(
//               () => Languagecontroller.apiload.value
//               ? const Center(child: CircularProgressIndicator())
//               : ListView(
//             children: [
//               _buildTranslationDisplay(Languagecontroller),
//               const SizedBox(height: 20),
//               _buildControlButtons(Languagecontroller),
//               const Divider(height: 40),
//               _buildLanguageSelector(Languagecontroller),
//               // const SizedBox(height: 20),
//               // ElevatedButton(
//               //   onPressed: () {
//               //     Languagecontroller.transalatetext();
//               //     Languagecontroller.inputlanguage.value = Languagecontroller.outputlanguage.value;
//               //   },
//               //   style: ElevatedButton.styleFrom(
//               //     padding: const EdgeInsets.symmetric(
//               //       vertical: 15,
//               //       horizontal: 30,
//               //     ),
//               //     shape: RoundedRectangleBorder(
//               //       borderRadius: BorderRadius.circular(10),
//               //     ),
//               //   ),
//               //   child: const Text(
//               //     "Translate",
//               //     style: TextStyle(fontSize: 16),
//               //   ),
//               // ),
//               const SizedBox(height: 20),
//               const Divider(height: 40),
//               // _buildSliderSection(
//               //   "Pitch",
//               //   Languagecontroller.pitch,
//               //   0.5,
//               //   2.0,
//               // ),
//               _buildSliderSection(
//                 "Speech Rate",
//                 Languagecontroller.speachRate,
//                 0.0,
//                 1.0,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//    Widget _buildControlButtons(Transilator controller) {
//      return Row(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: [
//          Obx(
//                () => ElevatedButton.icon(
//              onPressed: () {
//                controller.play.value ? controller.pause() : controller.speak();
//              },
//              icon: Icon(controller.play.value ? Icons.pause : Icons.volume_up),
//              label: Text(controller.play.value ? "Pause" : "Play"),
//              style: ElevatedButton.styleFrom(
//                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(15),
//                ),
//              ),
//            ),
//          ),
//          ElevatedButton.icon(
//            onPressed: () => controller.stop(),
//            icon: const Icon(Icons.stop),
//            label: const Text("Stop"),
//            style: ElevatedButton.styleFrom(
//              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(15),
//              ),
//            ),
//          ),
//        ],
//      );
//    }
//
//    Widget _buildSliderSection(
//        String label, RxDouble value, double min, double max) {
//      return Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: [
//          Text(
//            label,
//            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//          ),
//          Row(
//            children: [
//              Expanded(
//                child: Obx(
//                      () => Slider(
//                    value: value.value,
//                    min: min,
//                    max: max,
//                    onChanged: (newValue) async {
//                      value.value = newValue;
//                      if (Languagecontroller.play.value) {
//                        await Languagecontroller.stop();
//                        Languagecontroller.initSetting();
//                        Languagecontroller.speak();
//                      }
//                    },
//                  ),
//                ),
//              ),
//              Obx(
//                    () => Text(
//                  value.value.toStringAsFixed(2),
//                  style: const TextStyle(fontSize: 16),
//                ),
//              ),
//            ],
//          ),
//        ],
//      );
//    }
//
//    Widget _buildLanguageSelector(Transilator controller) {
//      return Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: [
//          _buildLanguageDropdown(
//            "Output Language",
//            controller.outputlanguage,
//            controller.inputlanguage,
//          ),
//        ],
//      );
//    }
//
//    Widget _buildLanguageDropdown(
//        String label, RxString selectedLanguage, RxString? inputlanguage) {
//      return Column(
//        children: [
//          Text(
//            label,
//            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//          ),
//          const SizedBox(height: 8),
//          Obx(
//                () => DropdownButton<String>(
//              value: selectedLanguage.value,
//              items: <Map<String, String>>[
//                {'name': 'English', 'code': 'en'},
//                {'name': 'Hindi', 'code': 'hi'},
//                {'name': 'Bengali', 'code': 'bn'},
//                {'name': 'Telugu', 'code': 'te'},
//                {'name': 'Marathi', 'code': 'mr'},
//                {'name': 'Tamil', 'code': 'ta'},
//                {'name': 'Gujarati', 'code': 'gu'},
//                {'name': 'Urdu', 'code': 'ur'},
//                {'name': 'Kannada', 'code': 'kn'},
//                {'name': 'Odia', 'code': 'or'},
//                {'name': 'Malayalam', 'code': 'ml'},
//                {'name': 'Punjabi', 'code': 'pa'},
//                {'name': 'Assamese', 'code': 'as'},
//              ].map<DropdownMenuItem<String>>((Map<String, String> lang) {
//                return DropdownMenuItem<String>(
//                  value: lang['code'],
//                  child: Text(lang['name'] ?? ""),
//                );
//              }).toList(),
//              onChanged: (value) {
//                if (value != null) {
//                  selectedLanguage.value = value;
//                  final settings =
//                      Languagecontroller.languageSettings[value] ??
//                          {'pitch': 1.0, 'rate': 1.0};
//                  Languagecontroller.pitch.value = settings['pitch']!;
//                  Languagecontroller.speachRate.value = settings['rate']!;
//                  Languagecontroller.initSetting();
//                }
//                Languagecontroller.stop();
//                Languagecontroller.transalatetext();
//              },
//            ),
//          ),
//        ],
//      );
//    }
//
//    Widget _buildTranslationDisplay(Transilator controller) {
//      return Obx(
//            () => Card(
//          elevation: 5,
//          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//          color: Colors.white,
//          child: Padding(
//            padding: const EdgeInsets.all(15),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: [
//                const Text(
//                  "Original Text:",
//                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                ),
//                const SizedBox(height: 8),
//                Text(
//                  controller.inputtext.value,
//                  style: const TextStyle(fontSize: 16),
//                ),
//                const Divider(height: 20),
//                if (controller.isTranslating.value)
//                  const Center(child: CircularProgressIndicator())
//                else ...[
//                  const Text(
//                    "Translated Text:",
//                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                  ),
//                  const SizedBox(height: 8),
//                  Text(
//                    controller.translatedText.value,
//                    style: const TextStyle(fontSize: 16),
//                  ),
//                ],
//              ],
//            ),
//          ),
//        ),
//      );
//    }
// }
