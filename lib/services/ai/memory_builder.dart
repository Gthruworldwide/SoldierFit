import 'user_memory_model.dart';

class MemoryBuilder {
  static String buildContext(UserMemoryModel userMemory) {
    final profile = userMemory.profile;
    final history = userMemory.history;
    final recentHistory = history.isNotEmpty ? history.last : null;

    return '''
User Profile:
- Rank: ${profile.rank}
- Total XP: ${profile.xp}
- Current Streak: ${profile.streak} days
- Total Workouts: ${profile.totalWorkouts}
- Average Performance: ${(profile.averagePerformance * 100).toStringAsFixed(0)}%

Performance Analysis:
- Weak Areas: ${profile.weakAreas.join(', ')}
- Strong Areas: ${profile.strongAreas.join(', ')}

Recent Activity:
${recentHistory != null ? '''
- Last Workout: ${recentHistory.workoutType}
- Performance: ${recentHistory.performance}
- Duration: ${recentHistory.duration} minutes
- XP Earned: ${recentHistory.xpEarned}
- Date: ${recentHistory.date}
''' : 'No recent workout data'}

Current Coaching Mode: ${userMemory.personalityMode.displayName}
''';
  }

  static String buildPerformanceInsight(UserMemoryModel userMemory) {
    final profile = userMemory.profile;
    final history = userMemory.history;

    if (history.isEmpty) {
      return 'No workout history available for analysis.';
    }

    final recentWorkouts = history.take(5).toList();
    final excellentCount = recentWorkouts.where((w) => w.performance == 'excellent').length;
    final goodCount = recentWorkouts.where((w) => w.performance == 'good').length;
    final poorCount = recentWorkouts.where((w) => w.performance == 'poor').length;

    return '''
Recent Performance Summary (Last 5 workouts):
- Excellent: $excellentCount
- Good: $goodCount
- Poor: $poorCount

Performance Trend: ${_getPerformanceTrend(recentWorkouts)}
Areas for Improvement: ${profile.weakAreas.isNotEmpty ? profile.weakAreas.join(', ') : 'None identified'}
Strengths to Maintain: ${profile.strongAreas.isNotEmpty ? profile.strongAreas.join(', ') : 'Continue current approach'}
''';
  }

  static String _getPerformanceTrend(List<WorkoutHistory> workouts) {
    if (workouts.length < 2) return 'Insufficient data';

    final recent = workouts.take(3).toList();
    final earlier = workouts.skip(3).take(2).toList();

    if (earlier.isEmpty) return 'Building baseline';

    final recentAvg = _getPerformanceScore(recent);
    final earlierAvg = _getPerformanceScore(earlier);

    if (recentAvg > earlierAvg + 0.2) return 'Improving 📈';
    if (recentAvg < earlierAvg - 0.2) return 'Declining 📉';
    return 'Stable ➡️';
  }

  static double _getPerformanceScore(List<WorkoutHistory> workouts) {
    final scores = workouts.map((w) {
      switch (w.performance) {
        case 'excellent':
          return 1.0;
        case 'good':
          return 0.75;
        case 'average':
          return 0.5;
        case 'poor':
          return 0.25;
        default:
          return 0.5;
      }
    });

    return scores.reduce((a, b) => a + b) / scores.length;
  }

  static String buildMotivationalContext(UserMemoryModel userMemory) {
    final profile = userMemory.profile;
    final streak = profile.streak;

    if (streak >= 7) {
      return 'Exceptional consistency! ${streak} day streak shows elite dedication.';
    } else if (streak >= 3) {
      return 'Building momentum with ${streak} day streak. Keep pushing!';
    } else if (streak == 0) {
      return 'Fresh start opportunity. Every elite soldier began here.';
    } else {
      return '${streak} day streak - consistency is key to military excellence.';
    }
  }

  static Map<String, dynamic> buildCompressedProfile(UserMemoryModel userMemory) {
    return {
      'rank': userMemory.profile.rank,
      'xp': userMemory.profile.xp,
      'streak': userMemory.profile.streak,
      'weakAreas': userMemory.profile.weakAreas,
      'strongAreas': userMemory.profile.strongAreas,
      'avgPerformance': userMemory.profile.averagePerformance,
      'recentPerformance': userMemory.history.isNotEmpty 
          ? userMemory.history.last.performance 
          : 'none',
      'personalityMode': userMemory.personalityMode.name,
      'lastActive': userMemory.lastUpdated.toIso8601String(),
    };
  }
}
