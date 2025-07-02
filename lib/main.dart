import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:project_with_gimini/view/screen/gimini_screen.dart';

const apiKey = "AIzaSyCGuk4NBdYIvrKeGDQtcPDBgVnFsHitiTU";

void main() {
  Gemini.init(apiKey: apiKey);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: GiminiScreen());
  }
}
