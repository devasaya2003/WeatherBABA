import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheather_baba/pages/weather_page.dart';
import 'package:wheather_baba/themes/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create:(context) => ThemeProvider(),
      child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: WeatherPage(),
    );
  }
}
