import 'package:flutter/material.dart';
import '../../global_files.dart';

class AppTheme {
  ThemeData get light => ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Poly',
        textTheme: TextDisplayTheme.lightTextTheme,
        inputDecorationTheme: TextFieldTheme.lightInputDecorationTheme,
        scaffoldBackgroundColor: const Color(0xFFF5F9FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D9DB6),
          primary: const Color(0xFF0D9DB6),
          secondary: const Color(0xFF00C9A7),
          surface: const Color(0xFFF5F9FA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D9DB6),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D9DB6),
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF0D9DB6),
          ),
        ),
        dividerColor: Colors.black,
        cardColor: Colors.grey.withOpacity(0.1),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFE7EEF3),
        ),
        useMaterial3: true,
      );

  ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Poly',
        textTheme: TextDisplayTheme.darkTextTheme,
        inputDecorationTheme: TextFieldTheme.darkInputDecorationTheme,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0D9DB6),
          secondary: Color(0xFF00C9A7),
          surface: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D9DB6),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        dividerColor: Colors.white,
        cardColor: Colors.grey.withOpacity(0.1),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1F1F1F),
        ),
        useMaterial3: true,
      );
}

final AppTheme globalTheme = AppTheme();
