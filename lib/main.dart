import 'package:calendrier_fruits_et_legumes/pages/home_page.dart';
import 'package:calendrier_fruits_et_legumes/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      initialRoute: '/',
      routes: <String, WidgetBuilder> {
        '/': (_) => const HomePage(),
      },
    );
  }
}
