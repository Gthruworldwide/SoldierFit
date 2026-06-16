import 'user_memory_model.dart';

class AdaptivePersonalityEngine {
  static CoachMode determineMode(UserMemoryModel userMemory) {
    final profile = userMemory.profile;
    final history = userMemory.history;

    // Elite Mode: Consistent high performers (7+ day streak, good performance)
    if (profile.streak >= 7 && profile.averagePerformance >= 0.7) {
      return CoachMode.elite;
    }

    // Strict Mode: Inconsistent or struggling users
    if (_isInconsistent(profile, history) || profile.streak < 3) {
      return CoachMode.strict;
    }

    // Friendly Mode: Beginners or steady performers
    if (profile.xp < 300 || profile.totalWorkouts < 5) {
      return CoachMode.friendly;
    }

    // Default to friendly for moderate users
    return CoachMode.friendly;
  }

  static bool _isInconsistent(UserProfile profile, List<WorkoutHistory> history) {
    if (history.length < 3) return false;

    final recentWorkouts = history.take(5).toList();
    final poorPerformanceCount = recentWorkouts
        .where((w) => w.performance == 'poor' || w.performance == 'average')
        .length;

    // If 60%+ of recent workouts are poor/average, they need strict mode
    return poorPerformanceCount / recentWorkouts.length >= 0.6;
  }

  static CoachMode getModeForStreak(int streak) {
    if (streak >= 7) return CoachMode.elite;
    if (streak >= 3) return CoachMode.friendly;
    return CoachMode.strict;
  }

  static CoachMode getModeForXP(int xp) {
    if (xp < 300) return CoachMode.friendly;
    if (xp < 1000) return CoachMode.strict;
    return CoachMode.elite;
  }

  static CoachMode getModeForPerformance(double averagePerformance) {
    if (averagePerformance >= 0.8) return CoachMode.elite;
    if (averagePerformance >= 0.6) return CoachMode.friendly;
    return CoachMode.strict;
  }

  static String getModeTransitionReason(
    CoachMode oldMode,
    CoachMode newMode,
    UserMemoryModel userMemory,
  ) {
    if (oldMode == newMode) return 'No change needed';

    final profile = userMemory.profile;

    switch (newMode) {
      case CoachMode.elite:
        if (profile.streak >= 7) {
          return 'Promoted to Elite mode due to exceptional ${profile.streak}-day streak';
        }
        return 'Promoted to Elite mode for outstanding performance consistency';
      case CoachMode.strict:
        if (profile.streak < 3) {
          return 'Switched to Strict mode to rebuild consistency (streak: ${profile.streak})';
        }
        return 'Switched to Strict mode for performance improvement focus';
      case CoachMode.friendly:
        if (profile.xp < 300) {
          return 'Using Friendly mode for beginner guidance';
        }
        return 'Using Friendly mode for steady progress support';
    }
  }

  static Map<String, dynamic> getModeAdjustmentSuggestions(
    UserMemoryModel userMemory,
  ) {
    final profile = userMemory.profile;
    final suggestions = <String, dynamic>{};

    // Streak-based suggestions
    if (profile.streak == 0) {
      suggestions['priority'] = 'high';
      suggestions['action'] = 'restart_streak';
      suggestions['message'] = 'Immediate action needed: Start a new workout today';
    } else if (profile.streak < 3) {
      suggestions['priority'] = 'medium';
      suggestions['action'] = 'build_consistency';
      suggestions['message'] = 'Focus on consistency: Aim for 3+ day streak';
    }

    // Performance-based suggestions
    if (profile.averagePerformance < 0.5) {
      suggestions['priority'] = 'high';
      suggestions['action'] = 'improve_technique';
      suggestions['message'] = 'Technique improvement needed: Focus on form';
    }

    // Weak area suggestions
    if (profile.weakAreas.isNotEmpty) {
      suggestions['focus_areas'] = profile.weakAreas;
      suggestions['suggested_workouts'] = _getSuggestedWorkouts(profile.weakAreas);
    }

    return suggestions;
  }

  static List<String> _getSuggestedWorkouts(List<String> weakAreas) {
    final suggestions = <String>[];

    for (final area in weakAreas) {
      switch (area.toLowerCase()) {
        case 'cardio':
          suggestions.addAll(['Running', 'Jumping Jacks', 'Burpees']);
          break;
        case 'strength':
          suggestions.addAll(['Pushups', 'Squats', 'Plank']);
          break;
        case 'endurance':
          suggestions.addAll(['Long Run', 'Circuit Training', 'HIIT']);
          break;
        case 'flexibility':
          suggestions.addAll(['Stretching', 'Yoga', 'Dynamic Warm-up']);
          break;
        default:
          suggestions.add('Mixed Training');
      }
    }

    return suggestions;
  }
}
