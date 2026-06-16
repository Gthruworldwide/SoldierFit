import 'package:flutter_test/flutter_test.dart';
import 'package:soldierfit/services/ai/user_memory_model.dart';
import 'package:soldierfit/services/ai/adaptive_personality_engine.dart';

void main() {
  group('Adaptive Personality Engine Tests', () {
    test('Should return Elite mode for consistent high performers', () {
      final memory = UserMemoryModel(
        userId: 'test',
        profile: UserProfile(
          rank: 'Captain',
          xp: 5000,
          streak: 10,
          weakAreas: [],
          strongAreas: ['cardio', 'strength'],
          averagePerformance: 0.8,
          totalWorkouts: 20,
        ),
        history: [],
        personalityMode: CoachMode.friendly,
        lastUpdated: DateTime.now(),
      );

      final mode = AdaptivePersonalityEngine.determineMode(memory);
      expect(mode, CoachMode.elite);
    });

    test('Should return Strict mode for inconsistent users', () {
      final memory = UserMemoryModel(
        userId: 'test',
        profile: UserProfile(
          rank: 'Recruit',
          xp: 200,
          streak: 1,
          weakAreas: ['cardio'],
          strongAreas: [],
          averagePerformance: 0.4,
          totalWorkouts: 3,
        ),
        history: [],
        personalityMode: CoachMode.friendly,
        lastUpdated: DateTime.now(),
      );

      final mode = AdaptivePersonalityEngine.determineMode(memory);
      expect(mode, CoachMode.strict);
    });

    test('Should return Friendly mode for beginners', () {
      final memory = UserMemoryModel(
        userId: 'test',
        profile: UserProfile(
          rank: 'Recruit',
          xp: 100,
          streak: 2,
          weakAreas: [],
          strongAreas: [],
          averagePerformance: 0.5,
          totalWorkouts: 2,
        ),
        history: [],
        personalityMode: CoachMode.friendly,
        lastUpdated: DateTime.now(),
      );

      final mode = AdaptivePersonalityEngine.determineMode(memory);
      expect(mode, CoachMode.friendly);
    });

    test('Should return Elite mode for 7+ day streak', () {
      final mode = AdaptivePersonalityEngine.getModeForStreak(7);
      expect(mode, CoachMode.elite);
    });

    test('Should return Friendly mode for low XP', () {
      final mode = AdaptivePersonalityEngine.getModeForXP(200);
      expect(mode, CoachMode.friendly);
    });

    test('Should return Elite mode for high performance', () {
      final mode = AdaptivePersonalityEngine.getModeForPerformance(0.85);
      expect(mode, CoachMode.elite);
    });

    test('Should provide adjustment suggestions for weak users', () {
      final memory = UserMemoryModel(
        userId: 'test',
        profile: UserProfile(
          rank: 'Recruit',
          xp: 100,
          streak: 0,
          weakAreas: ['cardio'],
          strongAreas: [],
          averagePerformance: 0.3,
          totalWorkouts: 2,
        ),
        history: [],
        personalityMode: CoachMode.strict,
        lastUpdated: DateTime.now(),
      );

      final suggestions = AdaptivePersonalityEngine.getModeAdjustmentSuggestions(memory);
      expect(suggestions, isNotNull);
      expect(suggestions['priority'], 'high');
    });
  });
}
