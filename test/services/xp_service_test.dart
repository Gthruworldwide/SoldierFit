import 'package:flutter_test/flutter_test.dart';
import 'package:soldierfit/services/xp/xp_service.dart';

void main() {
  group('XP Service Tests', () {
    late XPService xpService;

    setUp(() {
      xpService = XPService();
    });

    test('Initial XP should be 0', () {
      expect(xpService.totalXP, 0);
    });

    test('Initial streak should be 0', () {
      expect(xpService.streak, 0);
    });

    test('Initial multiplier should be 1.0', () {
      expect(xpService.multiplier, 1.0);
    });

    test('Add workout XP should increase total XP', () async {
      final initialXP = xpService.totalXP;
      await xpService.addWorkoutXP();
      expect(xpService.totalXP, greaterThan(initialXP));
    });

    test('Add mission XP should increase total XP', () async {
      final initialXP = xpService.totalXP;
      await xpService.addMissionXP(100);
      expect(xpService.totalXP, initialXP + 100);
    });

    test('Streak bonus should apply correctly', () async {
      xpService.updateStreak(7);
      final multiplier = xpService.multiplier;
      expect(multiplier, greaterThan(1.0));
    });

    test('Level calculation should be correct', () {
      xpService.totalXP = 500;
      expect(xpService.level, 1);
      
      xpService.totalXP = 1500;
      expect(xpService.level, 2);
    });

    test('XP to next level calculation should be correct', () {
      xpService.totalXP = 500;
      expect(xpService.getXPToNextLevel(), 500);
    });

    test('Level progress should be between 0 and 1', () {
      xpService.totalXP = 750;
      final progress = xpService.getLevelProgress();
      expect(progress, greaterThanOrEqualTo(0.0));
      expect(progress, lessThanOrEqualTo(1.0));
    });
  });
}
