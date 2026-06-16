import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/storage_keys.dart';

class XPService extends ChangeNotifier {
  int _totalXP = 0;
  int _currentLevelXP = 0;
  int _streak = 0;
  DateTime? _lastWorkoutDate;
  int _xpMultiplier = 1;

  int get totalXP => _totalXP;
  int get currentLevelXP => _currentLevelXP;
  int get streak => _streak;
  DateTime? get lastWorkoutDate => _lastWorkoutDate;
  int get xpMultiplier => _xpMultiplier;

  XPService() {
    _loadXPData();
  }

  Future<void> _loadXPData() async {
    final prefs = await SharedPreferences.getInstance();
    _totalXP = prefs.getInt(StorageKeys.userXP) ?? 0;
    _currentLevelXP = prefs.getInt('current_level_xp') ?? 0;
    _streak = prefs.getInt(StorageKeys.userStreak) ?? 0;
    _xpMultiplier = prefs.getInt('xp_multiplier') ?? 1;
    
    final lastWorkoutTimestamp = prefs.getInt(StorageKeys.lastWorkoutDate);
    if (lastWorkoutTimestamp != null) {
      _lastWorkoutDate = DateTime.fromMillisecondsSinceEpoch(lastWorkoutTimestamp);
    }
    
    _checkStreakReset();
    notifyListeners();
  }

  Future<void> _saveXPData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(StorageKeys.userXP, _totalXP);
    await prefs.setInt('current_level_xp', _currentLevelXP);
    await prefs.setInt(StorageKeys.userStreak, _streak);
    await prefs.setInt('xp_multiplier', _xpMultiplier);
    
    if (_lastWorkoutDate != null) {
      await prefs.setInt(StorageKeys.lastWorkoutDate, _lastWorkoutDate!.millisecondsSinceEpoch);
    }
  }

  void _checkStreakReset() {
    if (_lastWorkoutDate == null) return;
    
    final now = DateTime.now();
    final difference = now.difference(_lastWorkoutDate!);
    
    if (difference.inHours > AppConstants.streakResetHours) {
      _streak = 0;
      _xpMultiplier = 1;
    }
  }

  Future<int> addWorkoutXP({int bonusXP = 0}) async {
    final baseXP = AppConstants.xpPerWorkout;
    final streakBonus = _calculateStreakBonus();
    final total = (baseXP + streakBonus + bonusXP) * _xpMultiplier;
    
    _totalXP += total;
    _currentLevelXP += total;
    _lastWorkoutDate = DateTime.now();
    _streak++;
    
    // Update multiplier based on streak
    if (_streak >= 7) {
      _xpMultiplier = 2;
    } else if (_streak >= 3) {
      _xpMultiplier = 1;
    }
    
    await _saveXPData();
    notifyListeners();
    
    return total;
  }

  Future<int> addMissionXP(int difficulty) async {
    final baseXP = AppConstants.xpPerMission * difficulty;
    final total = baseXP * _xpMultiplier;
    
    _totalXP += total;
    _currentLevelXP += total;
    
    await _saveXPData();
    notifyListeners();
    
    return total;
  }

  Future<int> addStreakBonus() async {
    final bonus = _calculateStreakBonus();
    if (bonus > 0) {
      _totalXP += bonus;
      _currentLevelXP += bonus;
      await _saveXPData();
      notifyListeners();
    }
    return bonus;
  }

  int _calculateStreakBonus() {
    if (_streak == 0) return 0;
    final bonus = (_streak * AppConstants.xpPerStreakDay).clamp(0, AppConstants.maxStreakBonus);
    return bonus;
  }

  double getLevelProgress() {
    return (_currentLevelXP / AppConstants.xpPerLevelUp).clamp(0.0, 1.0);
  }

  int getXPToNextLevel() {
    return AppConstants.xpPerLevelUp - _currentLevelXP;
  }

  Future<void> resetXP() async {
    _totalXP = 0;
    _currentLevelXP = 0;
    _streak = 0;
    _xpMultiplier = 1;
    _lastWorkoutDate = null;
    
    await _saveXPData();
    notifyListeners();
  }

  Future<void> setXP(int xp) async {
    _totalXP = xp;
    _currentLevelXP = xp % AppConstants.xpPerLevelUp;
    await _saveXPData();
    notifyListeners();
  }
}
