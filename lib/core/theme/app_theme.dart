import 'package:flutter/material.dart';

class AppTheme {
  // Military Color Palette
  static const Color primaryDark = Color(0xFF1A1A1A);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color neonGreen = Color(0xFF00FF41);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldBright = Color(0xFFFFD700);
  static const Color militaryGreen = Color(0xFF3B4D3B);
  static const Color tacticalBlack = Color(0xFF0D0D0D);
  static const Color hudGreen = Color(0xFF00FF00);
  static const Color alertRed = Color(0xFFFF4444);
  static const Color warningOrange = Color(0xFFFFA500);
  
  // Iron Dawn Theme (Season 1)
  static const Color ironDark = Color(0xFF2C2C2C);
  static const Color ironMetallic = Color(0xFF4A4A4A);
  static const Color ironRust = Color(0xFF8B4513);
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: neonGreen,
        secondary: gold,
        surface: primaryDark,
        background: tacticalBlack,
        error: alertRed,
      ),
      
      scaffoldBackgroundColor: tacticalBlack,
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        headlineLarge: TextStyle(
          color: neonGreen,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.white60,
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          color: gold,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: tacticalBlack,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: primaryDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: militaryGreen, width: 1),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonGreen,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: neonGreen,
          side: const BorderSide(color: neonGreen, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: primaryDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: militaryGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: militaryGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: neonGreen, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white38),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: neonGreen,
        linearTrackColor: primaryDark,
        circularTrackColor: primaryDark,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: neonGreen,
        size: 24,
      ),
    );
  }
  
  // Iron Dawn Season Theme
  static ThemeData get ironDawnTheme {
    return darkTheme.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: ironMetallic,
        secondary: goldBright,
        surface: ironDark,
        background: tacticalBlack,
      ),
      cardTheme: CardTheme(
        color: ironDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: ironMetallic, width: 2),
        ),
      ),
    );
  }
}

class TextStyles {
  static const TextStyle military = TextStyle(
    fontFamily: 'Roboto',
    letterSpacing: 2,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle hud = TextStyle(
    fontFamily: 'Courier',
    letterSpacing: 1,
    color: AppTheme.hudGreen,
  );
  
  static const TextStyle rank = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppTheme.gold,
    letterSpacing: 3,
  );
  
  static const TextStyle xp = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppTheme.neonGreen,
    letterSpacing: 1,
  );
}
