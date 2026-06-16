import 'package:flutter_test/flutter_test.dart';
import 'package:soldierfit/services/rank/rank_service.dart';

void main() {
  group('Rank Service Tests', () {
    late RankService rankService;

    setUp(() {
      rankService = RankService();
    });

    test('Initial rank should be Recruit', () {
      expect(rankService.currentRank, 'Recruit');
    });

    test('Initial rank level should be 0', () {
      expect(rankService.rankLevel, 0);
    });

    test('Rank should update based on XP', () {
      rankService.updateRank(1000);
      expect(rankService.currentRank, isNot('Recruit'));
    });

    test('Rank progression should follow hierarchy', () {
      final ranks = [
        'Recruit', 'Corporal', 'Sergeant', 'Lieutenant',
        'Captain', 'Major', 'Colonel', 'General', 'Commander'
      ];
      
      for (var i = 0; i < ranks.length; i++) {
        rankService.updateRank((i + 1) * 1000);
        expect(rankService.currentRank, ranks[i]);
      }
    });

    test('Progress to next rank should calculate correctly', () {
      rankService.updateRank(500);
      final progress = rankService.getProgressToNextRank();
      expect(progress, greaterThanOrEqualTo(0.0));
      expect(progress, lessThanOrEqualTo(1.0));
    });

    test('Unlocked ranks should include current rank', () {
      rankService.updateRank(1000);
      expect(rankService.unlockedRanks.contains(rankService.currentRank), true);
    });

    test('Max rank should be Commander', () {
      rankService.updateRank(100000);
      expect(rankService.currentRank, 'Commander');
    });
  });
}
