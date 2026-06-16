import 'package:flutter/material.dart';

class DS {
  // Color Tokens
  static const Color bg = Color(0xFF0B1F14);
  static const Color card = Color(0xFF121A14);
  static const Color gold = Color(0xFFD4AF37);
  static const Color green = Color(0xFF2E5A3D);
  static const Color neonGreen = Color(0xFF00FF41);
  static const Color militaryGreen = Color(0xFF3B4D3B);
  static const Color tacticalBlack = Color(0xFF0D0D0D);
  static const Color hudGreen = Color(0xFF00FF00);
  static const Color ironDark = Color(0xFF2C2C2C);
  static const Color ironMetallic = Color(0xFF4A4A4A);
  static const Color ironRust = Color(0xFF8B4513);
  static const Color goldBright = Color(0xFFFFD700);
  static const Color alertRed = Color(0xFFFF4444);
  static const Color warningOrange = Color(0xFFFFA500);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1A1A1A);
  
  // Spacing Tokens
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  
  // Border Radius Tokens
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  
  // Shadow Tokens
  static List<BoxShadow> get shadowGlow => [
    BoxShadow(
      color: neonGreen.withOpacity(0.3),
      blurRadius: 12,
      spreadRadius: 2,
    ),
  ];
  
  static List<BoxShadow> get goldGlow => [
    BoxShadow(
      color: gold.withOpacity(0.4),
      blurRadius: 16,
      spreadRadius: 2,
    ),
  ];
  
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  // Typography Tokens
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    color: Colors.white,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
    color: Colors.white,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    color: Colors.white,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: Colors.white70,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: Colors.white60,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: Colors.white54,
  );
  
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
    color: neonGreen,
  );
  
  static const TextStyle military = TextStyle(
    fontFamily: 'Roboto',
    letterSpacing: 2,
    fontWeight: FontWeight.bold,
  );
  
  // Border Tokens
  static const double borderThin = 1.0;
  static const double borderMedium = 2.0;
  static const double borderThick = 3.0;
  
  // Opacity Tokens
  static const double opacityHidden = 0.0;
  static const double opacityFaded = 0.3;
  static const double opacitySemi = 0.6;
  static const double opacityVisible = 1.0;
  
  // Animation Duration Tokens
  static const Duration animFast = Duration(milliseconds: 180);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 700);
  static const Duration animExtraSlow = Duration(milliseconds: 1200);
  
  // Z-Index Tokens
  static const int zBase = 0;
  static const int zElevated = 10;
  static const int zModal = 100;
  static const int zOverlay = 1000;
}

class Glassmorphism {
  static BoxDecoration get card {
    return BoxDecoration(
      color: DS.card.withOpacity(0.8),
      borderRadius: BorderRadius.circular(DS.radiusMd),
      border: Border.all(
        color: DS.green.withOpacity(0.3),
        width: DS.borderThin,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
  
  static BoxDecoration get heavy {
    return BoxDecoration(
      color: DS.card.withOpacity(0.9),
      borderRadius: BorderRadius.circular(DS.radiusLg),
      border: Border.all(
        color: DS.gold.withOpacity(0.4),
        width: DS.borderMedium,
      ),
      boxShadow: DS.goldGlow,
    );
  }
  
  static BoxDecoration get light {
    return BoxDecoration(
      color: DS.card.withOpacity(0.6),
      borderRadius: BorderRadius.circular(DS.radiusSm),
      border: Border.all(
        color: DS.neonGreen.withOpacity(0.2),
        width: DS.borderThin,
      ),
    );
  }
}

class GlowingNode {
  static BoxDecoration active({Color color = DS.neonGreen}) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: color.withOpacity(0.2),
      border: Border.all(
        color: color,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.5),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      ],
    );
  }
  
  static BoxDecoration locked() {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.black.withOpacity(0.5),
      border: Border.all(
        color: Colors.grey.withOpacity(0.3),
        width: 1,
      ),
    );
  }
  
  static BoxDecoration completed({Color color = DS.gold}) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: color.withOpacity(0.3),
      border: Border.all(
        color: color,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.6),
          blurRadius: 16,
          spreadRadius: 3,
        ),
      ],
    );
  }
}
