import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController text = TextEditingController();
  double volume=.5;
  String language='English';
  String selectedLanguage='en-US';

  bool isPlaying = false;
  final speech=FlutterTts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VoiceUp',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        maxLength: null,
                        maxLines: null,
                        controller: text,
                        decoration: InputDecoration(
                          hintText: 'Type or paste text to convert to speech',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButton<String>(
                        value: language,
                        onChanged: (newLang) async {
                          setState(() {
                            language=newLang!;
                          });

                          switch(language){
                            case 'English':
                              setState(() {
                                selectedLanguage='en-US';
                              });
                              break;
                            case 'Spanish':
                              setState(() {
                                selectedLanguage='es-ES';
                              });
                              break;
                            case 'French':
                              setState(() {
                                selectedLanguage='fr-FR';
                              });
                              break;

                          }
                        },
                        items: ['English', 'Spanish', 'French'].map((language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                      ),
                      Slider(
                        value: volume,
                        thumbColor: Colors.redAccent,
                        activeColor: Colors.blue,
                        onChanged: (newVolume) {
                          setState(() {
                            volume=newVolume;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildButton(Icons.play_arrow, 'Play', Colors.green,
                          () async {
                        if(isPlaying){
                          await speech.pause();
                        }else{
                          await speech.setLanguage(selectedLanguage);
                          await speech.setVolume(volume);
                          await speech.speak(text.text);

                        }
                        setState(() {
                          isPlaying=!isPlaying;
                        });
                        speech.setCompletionHandler(() {
                          setState(() {
                            isPlaying=!isPlaying;
                          });
                          print("sdfdfgdfgdfg");
                        });
                      }, isPlaying),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildButton(
                      Icons.stop, 'Stop', Colors.red, () async {
                    speech.stop();
                    setState(() {
                      isPlaying=false;
                    });
                  }, false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, Color color,
      VoidCallback onPressed, bool isPlay) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(
              isPlay ? Icons.pause : icon,
              color: isPlay ? Colors.orange : Colors.white,
            ),
            const SizedBox(width: 5.0),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}