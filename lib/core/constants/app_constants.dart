class AppConstants {
  // App Info
  static const String appName = 'SoldierFit';
  static const String appVersion = '1.0.0';
  
  // XP Constants
  static const int xpPerWorkout = 100;
  static const int xpPerMission = 50;
  static const int xpPerStreakDay = 25;
  static const int xpPerLevelUp = 1000;
  
  // Rank Thresholds
  static const Map<String, int> rankThresholds = {
    'Recruit': 0,
    'Private': 500,
    'Corporal': 1500,
    'Sergeant': 3000,
    'Lieutenant': 5000,
    'Captain': 7500,
    'Major': 10000,
    'Colonel': 15000,
    'General': 20000,
    'Commander': 30000,
  };
  
  // Season Constants
  static const int seasonDurationDays = 90;
  static const int maxSeasonLevel = 50;
  static const int seasonXPPerLevel = 500;
  
  // Streak Constants
  static const int maxStreakBonus = 100;
  static const int streakResetHours = 48;
  
  // Coach Personality Thresholds
  static const int strictModeThreshold = 3; // days of inactivity
  static const int eliteModeThreshold = 7; // consecutive workout days
  static const int friendlyModeThreshold = 0; // beginner
}

class StorageKeys {
  static const String userId = 'user_id';
  static const String userXP = 'user_xp';
  static const String userRank = 'user_rank';
  static const String userStreak = 'user_streak';
  static const String seasonXP = 'season_xp';
  static const String seasonLevel = 'season_level';
  static const String coachMode = 'coach_mode';
  static const String lastWorkoutDate = 'last_workout_date';
}

class FirebaseCollections {
  static const String users = 'users';
  static const String missions = 'missions';
  static const String seasons = 'seasons';
  static const String coachMemory = 'coach_memory';
  static const String analytics = 'analytics';
}
