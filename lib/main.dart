import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texttranslator/Google_transalate/page/page2.dart';
import 'package:texttranslator/test.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFFE1DD72),
          scaffoldBackgroundColor: const Color(0xFFA8C66C),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1B6535),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B6535),
              foregroundColor: Colors.white,
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Color(0xFF1B6535)),
          ),
          dividerColor: const Color(0xFF1B6535),
          sliderTheme: const SliderThemeData(
            activeTrackColor: Color(0xFF1B6535),
            inactiveTrackColor: Color(0xFFA8C66C),
            thumbColor: Color(0xFF1B6535),
          ),
        ),
        home:TranslationScreen()
      // Myhomepage22()
      // HomeScreen(),
    );
  }
}