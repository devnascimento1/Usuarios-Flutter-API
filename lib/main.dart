import 'package:flutter/material.dart';
import 'package:listausuarios/pages/homePage.dart';
import 'package:listausuarios/src/shared/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MaterialTheme(Typography.blackCupertino).light(),
       // Tema escuro
      darkTheme: MaterialTheme(Typography.blackCupertino).dark(),
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}
