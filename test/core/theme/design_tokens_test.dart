import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:soldierfit/core/theme/design_tokens.dart';

void main() {
  group('Design Tokens Tests', () {
    test('Background color should be defined', () {
      expect(DS.bg, isNotNull);
      expect(DS.bg, isA<Color>());
    });

    test('Card color should be defined', () {
      expect(DS.card, isNotNull);
      expect(DS.card, isA<Color>());
    });

    test('Gold color should be defined', () {
      expect(DS.gold, isNotNull);
      expect(DS.gold, isA<Color>());
    });

    test('Green color should be defined', () {
      expect(DS.green, isNotNull);
      expect(DS.green, isA<Color>());
    });

    test('Neon green color should be defined', () {
      expect(DS.neonGreen, isNotNull);
      expect(DS.neonGreen, isA<Color>());
    });

    test('Spacing tokens should be positive', () {
      expect(DS.xs, greaterThan(0));
      expect(DS.sm, greaterThan(DS.xs));
      expect(DS.md, greaterThan(DS.sm));
      expect(DS.lg, greaterThan(DS.md));
      expect(DS.xl, greaterThan(DS.lg));
      expect(DS.xxl, greaterThan(DS.xl));
    });

    test('Border radius tokens should be positive', () {
      expect(DS.radiusSm, greaterThan(0));
      expect(DS.radiusMd, greaterThan(DS.radiusSm));
      expect(DS.radiusLg, greaterThan(DS.radiusMd));
      expect(DS.radiusXl, greaterThan(DS.radiusLg));
    });

    test('Shadow glow should not be empty', () {
      expect(DS.shadowGlow, isNotEmpty);
    });

    test('Gold glow should not be empty', () {
      expect(DS.goldGlow, isNotEmpty);
    });

    test('Card shadow should not be empty', () {
      expect(DS.cardShadow, isNotEmpty);
    });

    test('Heading styles should be defined', () {
      expect(DS.heading1, isNotNull);
      expect(DS.heading2, isNotNull);
      expect(DS.heading3, isNotNull);
    });

    test('Body styles should be defined', () {
      expect(DS.bodyLarge, isNotNull);
      expect(DS.bodyMedium, isNotNull);
      expect(DS.bodySmall, isNotNull);
    });

    test('Animation durations should be positive', () {
      expect(DS.animFast.inMilliseconds, greaterThan(0));
      expect(DS.animMedium.inMilliseconds, greaterThan(DS.animFast.inMilliseconds));
      expect(DS.animSlow.inMilliseconds, greaterThan(DS.animMedium.inMilliseconds));
    });

    test('Glassmorphism card should return valid decoration', () {
      final decoration = Glassmorphism.card;
      expect(decoration, isNotNull);
      expect(decoration, isA<BoxDecoration>());
    });

    test('Glassmorphism heavy should return valid decoration', () {
      final decoration = Glassmorphism.heavy;
      expect(decoration, isNotNull);
      expect(decoration, isA<BoxDecoration>());
    });

    test('Glowing node active should return valid decoration', () {
      final decoration = GlowingNode.active();
      expect(decoration, isNotNull);
      expect(decoration, isA<BoxDecoration>());
    });

    test('Glowing node locked should return valid decoration', () {
      final decoration = GlowingNode.locked();
      expect(decoration, isNotNull);
      expect(decoration, isA<BoxDecoration>());
    });

    test('Glowing node completed should return valid decoration', () {
      final decoration = GlowingNode.completed();
      expect(decoration, isNotNull);
      expect(decoration, isA<BoxDecoration>());
    });
  });
}
