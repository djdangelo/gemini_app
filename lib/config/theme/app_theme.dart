import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  final bool isDarkMode;
  static const seedColor = Color(0xFF1E1C36);

  AppTheme({required this.isDarkMode});

  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seedColor,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      listTileTheme: const ListTileThemeData(iconColor: seedColor),
      appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1C36),
          surfaceTintColor: Colors.transparent));

  static setSystemUIOverlarStyle({required bool isDarkMode}) {
    final themeBrightness = isDarkMode ? Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: themeBrightness,
      statusBarIconBrightness: themeBrightness,
      systemNavigationBarIconBrightness: themeBrightness,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
  }
}
