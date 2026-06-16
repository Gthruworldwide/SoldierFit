import 'package:flutter_test/flutter_test.dart';
import 'package:soldierfit/services/season/season_service.dart';

void main() {
  group('Season Service Tests', () {
    late SeasonService seasonService;

    setUp(() {
      seasonService = SeasonService();
    });

    test('Initial season XP should be 0', () {
      expect(seasonService.seasonXP, 0);
    });

    test('Initial season level should be 1', () {
      expect(seasonService.seasonLevel, 1);
    });

    test('Add season XP should increase total XP', () async {
      final initialXP = seasonService.seasonXP;
      await seasonService.addSeasonXP(100);
      expect(seasonService.seasonXP, initialXP + 100);
    });

    test('Season level should increase with XP', () async {
      await seasonService.addSeasonXP(500);
      expect(seasonService.seasonLevel, 2);
    });

    test('Season progress should be between 0 and 1', () {
      seasonService.seasonXP = 250;
      final progress = seasonService.getSeasonProgress();
      expect(progress, greaterThanOrEqualTo(0.0));
      expect(progress, lessThanOrEqualTo(1.0));
    });

    test('XP to next level should calculate correctly', () {
      seasonService.seasonXP = 250;
      expect(seasonService.getXPToNextLevel(), 250);
    });

    test('Level should be unlocked when XP threshold reached', () {
      seasonService.seasonXP = 500;
      expect(seasonService.isLevelUnlocked(2), true);
    });

    test('Level should be locked when XP threshold not reached', () {
      seasonService.seasonXP = 100;
      expect(seasonService.isLevelLocked(2), true);
    });

    test('Season days remaining should be positive', () {
      expect(seasonService.getSeasonDaysRemaining(), greaterThan(0));
    });

    test('Season should be active initially', () {
      expect(seasonService.isSeasonActive(), true);
    });

    test('Reward should be retrievable by level', () {
      final reward = SeasonService.getRewardByLevel(1);
      expect(reward, isNotNull);
      expect(reward?.level, 1);
    });

    test('Season stats should return valid data', () {
      final stats = seasonService.getSeasonStats();
      expect(stats['seasonId'], isNotNull);
      expect(stats['seasonName'], isNotNull);
      expect(stats['currentLevel'], isNotNull);
      expect(stats['seasonXP'], isNotNull);
    });
  });
}
