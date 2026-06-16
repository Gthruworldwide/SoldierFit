import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/storage_keys.dart';
import 'xp_service.dart';

class RankService extends ChangeNotifier {
  String _currentRank = 'Recruit';
  int _rankLevel = 0;
  List<String> _unlockedRanks = ['Recruit'];

  String get currentRank => _currentRank;
  int get rankLevel => _rankLevel;
  List<String> get unlockedRanks => _unlockedRanks;

  RankService() {
    _loadRankData();
  }

  Future<void> _loadRankData() async {
    final prefs = await SharedPreferences.getInstance();
    _currentRank = prefs.getString(StorageKeys.userRank) ?? 'Recruit';
    _rankLevel = prefs.getInt('rank_level') ?? 0;
    
    final unlockedRanksList = prefs.getStringList('unlocked_ranks');
    if (unlockedRanksList != null) {
      _unlockedRanks = unlockedRanksList;
    }
    
    notifyListeners();
  }

  Future<void> _saveRankData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.userRank, _currentRank);
    await prefs.setInt('rank_level', _rankLevel);
    await prefs.setStringList('unlocked_ranks', _unlockedRanks);
  }

  void updateRank(int totalXP) {
    final ranks = AppConstants.rankThresholds.keys.toList();
    String newRank = 'Recruit';
    int newRankLevel = 0;

    for (int i = 0; i < ranks.length; i++) {
      final rank = ranks[i];
      final threshold = AppConstants.rankThresholds[rank]!;
      
      if (totalXP >= threshold) {
        newRank = rank;
        newRankLevel = i;
      }
    }

    if (newRank != _currentRank) {
      _currentRank = newRank;
      _rankLevel = newRankLevel;
      
      if (!_unlockedRanks.contains(newRank)) {
        _unlockedRanks.add(newRank);
      }
      
      _saveRankData();
      notifyListeners();
      
      return true; // Rank up occurred
    }

    return false; // No rank change
  }

  int getXPToNextRank() {
    final ranks = AppConstants.rankThresholds.keys.toList();
    final currentIndex = ranks.indexOf(_currentRank);
    
    if (currentIndex < ranks.length - 1) {
      final nextRank = ranks[currentIndex + 1];
      return AppConstants.rankThresholds[nextRank]!;
    }
    
    return 0; // Already at max rank
  }

  double getRankProgress(int currentXP) {
    final nextRankXP = getXPToNextRank();
    if (nextRankXP == 0) return 1.0;
    
    final ranks = AppConstants.rankThresholds.keys.toList();
    final currentIndex = ranks.indexOf(_currentRank);
    
    if (currentIndex > 0) {
      final currentRankXP = AppConstants.rankThresholds[_currentRank]!;
      final progress = (currentXP - currentRankXP) / (nextRankXP - currentRankXP);
      return progress.clamp(0.0, 1.0);
    }
    
    return (currentXP / nextRankXP).clamp(0.0, 1.0);
  }

  String getNextRank() {
    final ranks = AppConstants.rankThresholds.keys.toList();
    final currentIndex = ranks.indexOf(_currentRank);
    
    if (currentIndex < ranks.length - 1) {
      return ranks[currentIndex + 1];
    }
    
    return 'MAX RANK';
  }

  bool isRankUnlocked(String rank) {
    return _unlockedRanks.contains(rank);
  }

  Future<void> resetRank() async {
    _currentRank = 'Recruit';
    _rankLevel = 0;
    _unlockedRanks = ['Recruit'];
    
    await _saveRankData();
    notifyListeners();
  }
}
