import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    useMaterial3: true,
    fontFamily: 'Poppins',
    textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
  );

  // You can add dark mode later too
  static final dark = ThemeData.dark();
}
