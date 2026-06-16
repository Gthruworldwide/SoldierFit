class UserMemoryModel {
  final String userId;
  final UserProfile profile;
  final List<WorkoutHistory> history;
  final CoachMode personalityMode;
  final DateTime lastUpdated;

  UserMemoryModel({
    required this.userId,
    required this.profile,
    required this.history,
    required this.personalityMode,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'profile': profile.toJson(),
      'history': history.map((h) => h.toJson()).toList(),
      'personalityMode': personalityMode.name,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory UserMemoryModel.fromJson(Map<String, dynamic> json) {
    return UserMemoryModel(
      userId: json['userId'],
      profile: UserProfile.fromJson(json['profile']),
      history: (json['history'] as List)
          .map((h) => WorkoutHistory.fromJson(h))
          .toList(),
      personalityMode: CoachMode.values.firstWhere(
        (mode) => mode.name == json['personalityMode'],
      ),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

class UserProfile {
  final String rank;
  final int xp;
  final int streak;
  final List<String> weakAreas;
  final List<String> strongAreas;
  final double averagePerformance;
  final int totalWorkouts;

  UserProfile({
    required this.rank,
    required this.xp,
    required this.streak,
    required this.weakAreas,
    required this.strongAreas,
    required this.averagePerformance,
    required this.totalWorkouts,
  });

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'xp': xp,
      'streak': streak,
      'weakAreas': weakAreas,
      'strongAreas': strongAreas,
      'averagePerformance': averagePerformance,
      'totalWorkouts': totalWorkouts,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      rank: json['rank'],
      xp: json['xp'],
      streak: json['streak'],
      weakAreas: List<String>.from(json['weakAreas']),
      strongAreas: List<String>.from(json['strongAreas']),
      averagePerformance: json['averagePerformance'],
      totalWorkouts: json['totalWorkouts'],
    );
  }
}

class WorkoutHistory {
  final String date;
  final String workoutType;
  final String performance; // 'excellent', 'good', 'average', 'poor'
  final int duration;
  final int xpEarned;
  final Map<String, dynamic> metrics;

  WorkoutHistory({
    required this.date,
    required this.workoutType,
    required this.performance,
    required this.duration,
    required this.xpEarned,
    required this.metrics,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'workoutType': workoutType,
      'performance': performance,
      'duration': duration,
      'xpEarned': xpEarned,
      'metrics': metrics,
    };
  }

  factory WorkoutHistory.fromJson(Map<String, dynamic> json) {
    return WorkoutHistory(
      date: json['date'],
      workoutType: json['workoutType'],
      performance: json['performance'],
      duration: json['duration'],
      xpEarned: json['xpEarned'],
      metrics: json['metrics'],
    );
  }
}

enum CoachMode {
  strict,
  elite,
  friendly,
}

extension CoachModeExtension on CoachMode {
  String get displayName {
    switch (this) {
      case CoachMode.strict:
        return 'Drill Instructor';
      case CoachMode.elite:
        return 'Elite Commander';
      case CoachMode.friendly:
        return 'Motivational Coach';
    }
  }

  String get emoji {
    switch (this) {
      case CoachMode.strict:
        return '🪖';
      case CoachMode.elite:
        return '⭐';
      case CoachMode.friendly:
        return '💪';
    }
  }
}
