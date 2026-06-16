import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/storage_keys.dart';

class SeasonReward {
  final int level;
  final String name;
  final String description;
  final String type;
  final String icon;
  final bool isPremium;

  SeasonReward({
    required this.level,
    required this.name,
    required this.description,
    required this.type,
    required this.icon,
    this.isPremium = false,
  });
}

class SeasonService extends ChangeNotifier {
  static const String currentSeasonId = 'iron_dawn_1';
  static const String seasonName = 'OPERATION: IRON DAWN';
  static const int seasonDurationDays = 30; // Updated to 30 days
  static const int maxSeasonLevel = 50;
  static const int seasonXPPerLevel = 500;
  
  int _seasonXP = 0;
  int _seasonLevel = 1;
  List<int> _unlockedLevels = [1];
  List<String> _claimedRewards = [];
  DateTime? _seasonStartDate;
  DateTime? _seasonEndDate;

  int get seasonXP => _seasonXP;
  int get seasonLevel => _seasonLevel;
  List<int> get unlockedLevels => _unlockedLevels;
  List<String> get claimedRewards => _claimedRewards;
  DateTime? get seasonStartDate => _seasonStartDate;
  DateTime? get seasonEndDate => _seasonEndDate;

  // Iron Dawn Battle Pass Rewards - Full 50 levels
  static final List<SeasonReward> battlePassRewards = [
    // Free Rewards
    SeasonReward(level: 1, name: 'Recruit Badge', description: 'Basic military identification badge', type: 'badge', icon: '🎖️'),
    SeasonReward(level: 2, name: '100 XP Bonus', description: 'One-time XP boost', type: 'xp_boost', icon: '⭐'),
    SeasonReward(level: 3, name: 'Discipline Token', description: 'Token of unwavering discipline', type: 'token', icon: '🪙'),
    SeasonReward(level: 4, name: 'Basic Workout Pack', description: 'Unlock 3 basic workout routines', type: 'mission', icon: '📋'),
    SeasonReward(level: 5, name: 'Streak Protector', description: 'Save your streak once', type: 'boost', icon: '🛡️'),
    
    // Premium Rewards
    SeasonReward(level: 6, name: 'Military Green Neon Theme', description: 'Exclusive neon green UI theme', type: 'theme', icon: '🎨', isPremium: true),
    SeasonReward(level: 7, name: '200 XP Bonus', description: 'One-time XP boost', type: 'xp_boost', icon: '⭐'),
    SeasonReward(level: 8, name: 'Elite Badge Frame', description: 'Premium badge border effect', type: 'badge', icon: '🏅', isPremium: true),
    SeasonReward(level: 9, name: 'Advanced Workout Pack', description: 'Unlock 5 advanced workout routines', type: 'mission', icon: '📋'),
    SeasonReward(level: 10, name: 'XP Boost +5%', description: 'Permanent 5% XP increase', type: 'boost', icon: '⚡', isPremium: true),
    
    SeasonReward(level: 11, name: 'Sergeant Badge', description: 'Military rank badge', type: 'badge', icon: '🎖️'),
    SeasonReward(level: 12, name: '300 XP Bonus', description: 'One-time XP boost', type: 'xp_boost', icon: '⭐'),
    SeasonReward(level: 13, name: 'Tactical Token', description: 'Special forces token', type: 'token', icon: '🪙'),
    SeasonReward(level: 14, name: 'HIIT Workout Pack', description: 'Unlock HIIT workout routines', type: 'mission', icon: '📋'),
    SeasonReward(level: 15, name: 'Double XP Day', description: 'One 24-hour double XP period', type: 'boost', icon: '⚡'),
    
    SeasonReward(level: 16, name: 'Iron Skin Theme', description: 'Dark metallic theme with iron textures', type: 'theme', icon: '🎨', isPremium: true),
    SeasonReward(level: 17, name: '400 XP Bonus', description: 'One-time XP boost', type: 'xp_boost', icon: '⭐'),
    SeasonReward(level: 18, name: 'Golden Badge Frame', description: 'Premium gold badge effect', type: 'badge', icon: '🏅', isPremium: true),
    SeasonReward(level: 19, name: 'Endurance Workout Pack', description: 'Unlock endurance workout routines', type: 'mission', icon: '📋'),
    SeasonReward(level: 20, name: 'Elite Missions Unlock', description: 'Unlock special forces missions', type: 'mission', icon: '🎯', isPremium: true),
    
    SeasonReward(level: 21, name: 'Lieutenant Badge', description: 'Military rank badge', type: 'badge', icon: '🎖️'),
    SeasonReward(level: 22, name: '500 XP Bonus', description: 'One-time XP boost', type: 'xp_boost', icon: '⭐'),
    SeasonReward(level: 23, name: 'Commander Token', description: 'Elite commander token', type: 'token', icon: '🪙'),
    SeasonReward(level: 24, name: 'Strength Workout Pack', description: 'Unlock strength workout routines', type: 'mission', icon: '📋'),
    SeasonReward(level: 25, name: 'XP Boost +10%', description: 'Permanent 10% XP increase', type: 'boost', icon: '⚡'),
    
    SeasonReward(level: 26, name: 'HUD Interface Theme', description: 'Military HUD-style interface', type: 'theme', icon: '🎨', isPremium: true),
    SeasonReward(level: 27, name: '600 XP Bonus', description: 'One-time XP boost', type: 'xp_boost', icon: '⭐'),
    SeasonReward(level: 28, name: 'Platinum Badge Frame', description: 'Premium platinum badge effect', type: 'badge', icon: '🏅', isPremium: true),
    SeasonReward(level: 29, name: 'Flexibility Workout Pack', description: 'Unlock flexibility workout routines', type: 'mission', icon: '📋'),
    SeasonReward(level: 30, name: 'Sergeant Upgrade Animation', description: 'Cinematic rank-up effect', type: 'animation', icon: '🌟', isPremium: true),
    
    SeasonReward(level: 31, name: 'Captain Badge', description: 'Military rank badge', type: 'badge', icon: '🎖️'),
    SeasonReward(level: 32, name: '700 XP Bonus', description: 'One-time XP boost', type: 'xp_boost', icon: '⭐'),
    SeasonReward(level: 33, name: 'Elite Token', description: 'Special forces elite token', type: 'token', icon: '🪙'),
    SeasonReward(level: 34, name: 'Cardio Workout Pack', description: 'Unlock cardio workout routines', type: 'mission', icon: '📋'),
    SeasonReward(level: 35, name: 'Triple XP Hour', description: 'One 1-hour triple XP period', type: 'boost', icon: '⚡'),
    
    SeasonReward(level: 36, name: 'Cyber Military Theme', description: 'Futuristic cyber military theme', type: 'theme', icon: '🎨', isPremium: true),
    SeasonReward(level: 37, name: '800 XP Bonus', description: 'One-time XP boost', type: 'xp_boost', icon: '⭐'),
    SeasonReward(level: 38, name: 'Diamond Badge Frame', description: 'Premium diamond badge effect', type: 'badge', icon: '🏅', isPremium: true),
    SeasonReward(level: 39, name: 'Full Body Workout Pack', description: 'Unlock full body workout routines', type: 'mission', icon: '📋'),
    SeasonReward(level: 40, name: 'Gold UI Frame', description: 'Premium golden border theme', type: 'theme', icon: '🏆', isPremium: true),
    
    SeasonReward(level: 41, name: 'Major Badge', description: 'Military rank badge', type: 'badge', icon: '🎖️'),
    SeasonReward(level: 42, name: '900 XP Bonus', description: 'One-time XP boost', type: 'xp_boost', icon: '⭐'),
    SeasonReward(level: 43, name: 'General Token', description: 'General officer token', type: 'token', icon: '🪙'),
    SeasonReward(level: 44, name: 'All Workout Packs', description: 'Unlock all workout routines', type: 'mission', icon: '📋'),
    SeasonReward(level: 45, name: 'XP Boost +15%', description: 'Permanent 15% XP increase', type: 'boost', icon: '⚡'),
    
    SeasonReward(level: 46, name: 'Royal Military Theme', description: 'Premium royal military theme', type: 'theme', icon: '🎨', isPremium: true),
    SeasonReward(level: 47, name: '1000 XP Bonus', description: 'One-time XP boost', type: 'xp_boost', icon: '⭐'),
    SeasonReward(level: 48, name: 'Legendary Badge Frame', description: 'Premium legendary badge effect', type: 'badge', icon: '🏅', isPremium: true),
    SeasonReward(level: 49, name: 'Elite Animation Pack', description: 'Unlock all premium animations', type: 'animation', icon: '🌟', isPremium: true),
    SeasonReward(level: 50, name: 'Commander Title + Badge', description: 'Exclusive Commander rank title and badge', type: 'title', icon: '👑', isPremium: true),
  ];

  SeasonService() {
    _loadSeasonData();
  }

  Future<void> _loadSeasonData() async {
    final prefs = await SharedPreferences.getInstance();
    _seasonXP = prefs.getInt(StorageKeys.seasonXP) ?? 0;
    _seasonLevel = prefs.getInt(StorageKeys.seasonLevel) ?? 1;
    
    final unlockedLevelsList = prefs.getStringList('unlocked_season_levels');
    if (unlockedLevelsList != null) {
      _unlockedLevels = unlockedLevelsList.map((e) => int.parse(e)).toList();
    }
    
    final claimedRewardsList = prefs.getStringList('claimed_season_rewards');
    if (claimedRewardsList != null) {
      _claimedRewards = claimedRewardsList;
    }
    
    final startDateTimestamp = prefs.getInt('season_start_date');
    final endDateTimestamp = prefs.getInt('season_end_date');
    
    if (startDateTimestamp != null) {
      _seasonStartDate = DateTime.fromMillisecondsSinceEpoch(startDateTimestamp);
    }
    
    if (endDateTimestamp != null) {
      _seasonEndDate = DateTime.fromMillisecondsSinceEpoch(endDateTimestamp);
    }
    
    _initializeSeasonDates();
    _checkSeasonExpiry();
    notifyListeners();
  }

  Future<void> _saveSeasonData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(StorageKeys.seasonXP, _seasonXP);
    await prefs.setInt(StorageKeys.seasonLevel, _seasonLevel);
    await prefs.setStringList(
      'unlocked_season_levels',
      _unlockedLevels.map((e) => e.toString()).toList(),
    );
    await prefs.setStringList('claimed_season_rewards', _claimedRewards);
    
    if (_seasonStartDate != null) {
      await prefs.setInt('season_start_date', _seasonStartDate!.millisecondsSinceEpoch);
    }
    
    if (_seasonEndDate != null) {
      await prefs.setInt('season_end_date', _seasonEndDate!.millisecondsSinceEpoch);
    }
  }

  void _initializeSeasonDates() {
    if (_seasonStartDate == null) {
      _seasonStartDate = DateTime.now();
    }
    
    if (_seasonEndDate == null) {
      _seasonEndDate = _seasonStartDate!.add(
        Duration(days: seasonDurationDays),
      );
    }
  }

  void _checkSeasonExpiry() {
    if (_seasonEndDate != null && DateTime.now().isAfter(_seasonEndDate!)) {
      // Season has expired, trigger reset
      _resetSeasonData();
    }
  }

  void _resetSeasonData() {
    _seasonXP = 0;
    _seasonLevel = 1;
    _unlockedLevels = [1];
    _claimedRewards = [];
    _seasonStartDate = DateTime.now();
    _seasonEndDate = _seasonStartDate!.add(Duration(days: seasonDurationDays));
    _saveSeasonData();
  }

  Future<void> addSeasonXP(int xp) async {
    _seasonXP += xp;
    _checkLevelUp();
    await _saveSeasonData();
    notifyListeners();
  }

  void _checkLevelUp() {
    final xpForNextLevel = _seasonLevel * seasonXPPerLevel;
    
    if (_seasonXP >= xpForNextLevel && _seasonLevel < maxSeasonLevel) {
      _seasonLevel++;
      _unlockedLevels.add(_seasonLevel);
      _checkLevelUp(); // Check for multiple level ups
    }
  }

  double getSeasonProgress() {
    final currentLevelXP = (_seasonLevel - 1) * seasonXPPerLevel;
    final nextLevelXP = _seasonLevel * seasonXPPerLevel;
    final progress = (_seasonXP - currentLevelXP) / (nextLevelXP - currentLevelXP);
    return progress.clamp(0.0, 1.0);
  }

  int getXPToNextLevel() {
    final nextLevelXP = _seasonLevel * seasonXPPerLevel;
    return nextLevelXP - _seasonXP;
  }

  SeasonReward? getRewardForLevel(int level) {
    try {
      return battlePassRewards.firstWhere((reward) => reward.level == level);
    } catch (e) {
      return null;
    }
  }

  bool isLevelUnlocked(int level) {
    return _unlockedLevels.contains(level);
  }

  bool isLevelLocked(int level) {
    return level > _seasonLevel;
  }

  bool isRewardClaimed(String rewardId) {
    return _claimedRewards.contains(rewardId);
  }

  Future<void> claimReward(int level) async {
    final reward = getRewardForLevel(level);
    if (reward != null && isLevelUnlocked(level) && !isRewardClaimed('${reward.level}_${reward.name}')) {
      _claimedRewards.add('${reward.level}_${reward.name}');
      await _saveSeasonData();
      notifyListeners();
    }
  }

  List<SeasonReward> getUnlockedRewards() {
    return battlePassRewards
        .where((reward) => _unlockedLevels.contains(reward.level))
        .toList();
  }

  List<SeasonReward> getLockedRewards() {
    return battlePassRewards
        .where((reward) => !_unlockedLevels.contains(reward.level))
        .toList();
  }

  List<SeasonReward> getClaimableRewards() {
    return battlePassRewards
        .where((reward) => 
            isLevelUnlocked(reward.level) && 
            !isRewardClaimed('${reward.level}_${reward.name}'))
        .toList();
  }

  int getSeasonDaysRemaining() {
    if (_seasonEndDate == null) return seasonDurationDays;
    
    final now = DateTime.now();
    final difference = _seasonEndDate!.difference(now);
    return difference.inDays.clamp(0, seasonDurationDays);
  }

  bool isSeasonActive() {
    if (_seasonEndDate == null) return true;
    return DateTime.now().isBefore(_seasonEndDate!);
  }

  Future<void> resetSeason() async {
    _resetSeasonData();
    notifyListeners();
  }

  static SeasonReward? getRewardByLevel(int level) {
    try {
      return battlePassRewards.firstWhere((reward) => reward.level == level);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> getSeasonStats() {
    return {
      'seasonId': currentSeasonId,
      'seasonName': seasonName,
      'currentLevel': _seasonLevel,
      'seasonXP': _seasonXP,
      'maxLevel': maxSeasonLevel,
      'daysRemaining': getSeasonDaysRemaining(),
      'isActive': isSeasonActive(),
      'unlockedLevels': _unlockedLevels.length,
      'claimedRewards': _claimedRewards.length,
      'totalRewards': battlePassRewards.length,
      'completionPercentage': (_unlockedLevels.length / maxSeasonLevel * 100).toStringAsFixed(1),
    };
  }
}
