import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texttranslator/Google_transalate/page/page2.dart';

import 'Transilate/page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:
      Myhomepage22()
      // HomeScreen(),
    );
  }
}