import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../services/season/season_service.dart';

class SeasonPage extends StatelessWidget {
  const SeasonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DS.bg,
      appBar: AppBar(
        title: Text(
          SeasonService.seasonName,
          style: DS.heading2.copyWith(color: DS.goldBright),
        ),
        backgroundColor: DS.bg,
        elevation: 0,
      ),
      body: Consumer<SeasonService>(
        builder: (context, seasonService, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(DS.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSeasonHeader(seasonService),
                SizedBox(height: DS.lg),
                _buildProgressCard(seasonService),
                SizedBox(height: DS.lg),
                _buildBattlePass(seasonService),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSeasonHeader(SeasonService seasonService) {
    return Container(
      padding: EdgeInsets.all(DS.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DS.ironDark,
            DS.ironMetallic,
          ],
        ),
        borderRadius: BorderRadius.circular(DS.radiusLg),
        border: Border.all(color: DS.goldBright, width: DS.borderMedium),
        boxShadow: DS.goldGlow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SeasonService.seasonName,
            style: DS.heading1.copyWith(
              color: DS.goldBright,
              fontSize: 28,
            ),
          ),
          SizedBox(height: DS.xs),
          Text(
            'Battle Pass Progress',
            style: DS.bodyMedium,
          ),
          SizedBox(height: DS.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeaderStat('Level', '${seasonService.seasonLevel}/50'),
              _buildHeaderStat('XP', '${seasonService.seasonXP}'),
              _buildHeaderStat('Days', '${seasonService.getSeasonDaysRemaining()}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: DS.heading3.copyWith(
            color: DS.neonGreen,
          ),
        ),
        SizedBox(height: DS.xs),
        Text(
          label,
          style: DS.bodySmall,
        ),
      ],
    );
  }

  Widget _buildProgressCard(SeasonService seasonService) {
    return Container(
      padding: EdgeInsets.all(DS.lg),
      decoration: Glassmorphism.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LEVEL PROGRESS',
            style: DS.label,
          ),
          SizedBox(height: DS.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(DS.radiusSm),
            child: LinearProgressIndicator(
              value: seasonService.getSeasonProgress(),
              backgroundColor: DS.card,
              valueColor: AlwaysStoppedAnimation<Color>(DS.goldBright),
              minHeight: 12,
            ),
          ),
          SizedBox(height: DS.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(seasonService.getSeasonProgress() * 100).toStringAsFixed(0)}% to Level ${seasonService.seasonLevel + 1}',
                style: DS.bodyMedium,
              ),
              Text(
                '${seasonService.getXPToNextLevel()} XP needed',
                style: DS.label.copyWith(
                  color: DS.goldBright,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBattlePass(SeasonService seasonService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BATTLE PASS REWARDS',
          style: DS.label,
        ),
        SizedBox(height: DS.md),
        ...SeasonService.battlePassRewards.map((reward) {
          return _buildRewardCard(reward, seasonService);
        }),
      ],
    );
  }

  Widget _buildRewardCard(SeasonService.SeasonReward reward, SeasonService seasonService) {
    final isUnlocked = seasonService.isLevelUnlocked(reward.level);
    final isLocked = seasonService.isLevelLocked(reward.level);
    final isClaimed = seasonService.isRewardClaimed('${reward.level}_${reward.name}');

    return Container(
      margin: EdgeInsets.only(bottom: DS.sm),
      padding: EdgeInsets.all(DS.md),
      decoration: BoxDecoration(
        color: isLocked
            ? Colors.black26
            : isUnlocked
                ? DS.green.withOpacity(0.3)
                : DS.card,
        borderRadius: BorderRadius.circular(DS.radiusSm),
        border: Border.all(
          color: isLocked
              ? Colors.grey
              : isUnlocked
                  ? DS.neonGreen
                  : DS.ironMetallic,
          width: isUnlocked ? DS.borderMedium : DS.borderThin,
        ),
        boxShadow: isUnlocked ? DS.shadowGlow : null,
      ),
      child: Row(
        children: [
          // Glowing node for level indicator
          Container(
            width: 50,
            height: 50,
            decoration: isLocked
                ? GlowingNode.locked()
                : isClaimed
                    ? GlowingNode.completed(color: DS.gold)
                    : GlowingNode.active(color: DS.neonGreen),
            child: Center(
              child: Text(
                reward.icon,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          SizedBox(width: DS.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Level ${reward.level}',
                      style: DS.label.copyWith(
                        color: isLocked
                            ? Colors.grey
                            : DS.goldBright,
                        fontSize: 12,
                      ),
                    ),
                    if (reward.isPremium) ...[
                      SizedBox(width: DS.xs),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: DS.xs, vertical: 2),
                        decoration: BoxDecoration(
                          color: DS.gold,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PREMIUM',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: DS.xs),
                Text(
                  reward.name,
                  style: DS.bodyMedium.copyWith(
                    color: isLocked ? Colors.grey : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: DS.xs),
                Text(
                  reward.description,
                  style: DS.bodySmall.copyWith(
                    color: isLocked ? Colors.grey38 : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          if (isLocked)
            const Icon(
              Icons.lock,
              color: Colors.grey,
            )
          else if (isClaimed)
            const Icon(
              Icons.check_circle,
              color: DS.gold,
              size: 28,
            )
          else
            Icon(
              Icons.arrow_forward_ios,
              color: DS.neonGreen,
            ),
        ],
      ),
    );
  }
}
