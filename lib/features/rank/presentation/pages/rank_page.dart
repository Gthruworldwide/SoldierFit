import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../services/xp/xp_service.dart';
import '../../../../services/rank/rank_service.dart';

class RankPage extends StatelessWidget {
  const RankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tacticalBlack,
      appBar: AppBar(
        title: const Text('RANK PROGRESS'),
        backgroundColor: AppTheme.tacticalBlack,
      ),
      body: Consumer2<XPService, RankService>(
        builder: (context, xpService, rankService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCurrentRankCard(rankService, xpService),
                const SizedBox(height: 24),
                _buildRankProgress(xpService, rankService),
                const SizedBox(height: 24),
                _buildAllRanks(rankService),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentRankCard(RankService rankService, XPService xpService) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryDark,
            AppTheme.militaryGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.gold, width: 2),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.military_tech,
            color: AppTheme.gold,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            rankService.currentRank.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.gold,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Level ${rankService.rankLevel + 1}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRankStat('Total XP', xpService.totalXP.toString()),
              _buildRankStat('Streak', '${xpService.streak} days'),
              _buildRankStat('Next Rank', rankService.getNextRank()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildRankProgress(XPService xpService, RankService rankService) {
    final progress = rankService.getRankProgress(xpService.totalXP);
    final xpToNext = rankService.getXPToNextRank() - xpService.totalXP;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.militaryGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROGRESS TO ${rankService.getNextRank().toUpperCase()}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppTheme.neonGreen,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.tacticalBlack,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(0)}% Complete',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                '$xpToNext XP remaining',
                style: TextStyle(
                  color: AppTheme.gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllRanks(RankService rankService) {
    final ranks = AppConstants.rankThresholds.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RANK HIERARCHY',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.neonGreen,
          ),
        ),
        const SizedBox(height: 16),
        ...ranks.asMap().entries.map((entry) {
          final index = entry.key;
          final rank = entry.value;
          final isUnlocked = rankService.isRankUnlocked(rank);
          final isCurrent = rank == rankService.currentRank;

          return _buildRankItem(rank, index, isUnlocked, isCurrent);
        }),
      ],
    );
  }

  Widget _buildRankItem(String rank, int index, bool isUnlocked, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppTheme.gold.withOpacity(0.2)
            : isUnlocked
                ? AppTheme.primaryDark
                : Colors.black26,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrent
              ? AppTheme.gold
              : isUnlocked
                  ? AppTheme.militaryGreen
                  : Colors.grey,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isUnlocked ? AppTheme.neonGreen : Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              rank.toUpperCase(),
              style: TextStyle(
                color: isUnlocked ? Colors.white : Colors.grey,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.gold,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'CURRENT',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else if (!isUnlocked)
            const Icon(
              Icons.lock,
              color: Colors.grey,
              size: 20,
            ),
        ],
      ),
    );
  }
}
