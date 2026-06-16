import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/motion/xp_effect.dart';
import '../../../../services/xp/xp_service.dart';
import '../../../../services/rank/rank_service.dart';
import '../../../../services/season/season_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showXPEffect = false;
  int _lastXPGained = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tacticalBlack,
      body: Consumer3<XPService, RankService, SeasonService>(
        builder: (context, xpService, rankService, seasonService, child) {
          return Stack(
            children: [
              _buildMainContent(xpService, rankService, seasonService),
              if (_showXPEffect)
                Positioned(
                  top: MediaQuery.of(context).size.height / 2 - 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: XPEffect(
                      _lastXPGained,
                      onComplete: () {
                        setState(() {
                          _showXPEffect = false;
                        });
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainContent(
    XPService xpService,
    RankService rankService,
    SeasonService seasonService,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(DS.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(rankService),
            SizedBox(height: DS.lg),
            _buildRankCard(rankService),
            SizedBox(height: DS.lg),
            _buildXPProgressRing(xpService),
            SizedBox(height: DS.lg),
            _buildQuickActions(xpService),
            SizedBox(height: DS.lg),
            _buildMissionsPreview(),
            SizedBox(height: DS.lg),
            _buildCoachPanel(),
            SizedBox(height: DS.lg),
            _buildSeasonCard(seasonService),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(RankService rankService) {
    return Container(
      padding: EdgeInsets.all(DS.md),
      decoration: Glassmorphism.card,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SOLDIERFIT',
                style: DS.heading1.copyWith(
                  color: DS.neonGreen,
                  fontSize: 28,
                ),
              ),
              SizedBox(height: DS.xs),
              Text(
                'Welcome, Soldier',
                style: DS.bodyMedium,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(DS.sm),
            decoration: BoxDecoration(
              color: DS.card,
              borderRadius: BorderRadius.circular(DS.radiusSm),
              border: Border.all(color: DS.gold, width: DS.borderMedium),
              boxShadow: DS.goldGlow,
            ),
            child: Icon(
              Icons.military_tech,
              color: DS.gold,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankCard(RankService rankService) {
    return Container(
      padding: EdgeInsets.all(DS.lg),
      decoration: Glassmorphism.heavy,
      child: Column(
        children: [
          Icon(
            Icons.military_tech,
            color: DS.gold,
            size: 64,
          ),
          SizedBox(height: DS.md),
          Text(
            rankService.currentRank.toUpperCase(),
            style: DS.heading2.copyWith(
              color: DS.gold,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: DS.sm),
          Text(
            'Level ${rankService.rankLevel + 1}',
            style: DS.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildXPProgressRing(XPService xpService) {
    return Container(
      padding: EdgeInsets.all(DS.lg),
      decoration: Glassmorphism.card,
      child: Column(
        children: [
          Text(
            'XP PROGRESS',
            style: DS.label,
          ),
          SizedBox(height: DS.md),
          SizedBox(
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(
                    value: xpService.getLevelProgress(),
                    strokeWidth: 8,
                    backgroundColor: DS.card,
                    valueColor: AlwaysStoppedAnimation<Color>(DS.gold),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${xpService.totalXP}',
                      style: DS.heading3.copyWith(
                        color: DS.gold,
                      ),
                    ),
                    Text(
                      'TOTAL XP',
                      style: DS.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: DS.md),
          Text(
            '${xpService.getXPToNextLevel()} XP to next level',
            style: DS.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(XPService xpService, RankService rankService) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        border: Border.all(color: AppTheme.neonGreen, width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('TOTAL XP', xpService.totalXP.toString(), Icons.star),
              _buildStatItem('STREAK', '${xpService.streak} days', Icons.local_fire_department),
              _buildStatItem('RANK', rankService.currentRank, Icons.military_tech),
            ],
          ),
          const SizedBox(height: 20),
          _buildXPProgressBar(xpService),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.neonGreen, size: 28),
        const SizedBox(height: 8),
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

  Widget _buildXPProgressBar(XPService xpService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level Progress',
              style: TextStyle(
                color: AppTheme.neonGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${xpService.getLevelProgress().toStringAsFixed(0)}%',
              style: TextStyle(
                color: AppTheme.gold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: xpService.getLevelProgress(),
            backgroundColor: AppTheme.tacticalBlack,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.neonGreen),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonCard(SeasonService seasonService) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                SeasonService.seasonName,
                style: DS.heading2.copyWith(
                  color: DS.goldBright,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: DS.sm, vertical: DS.xs),
                decoration: BoxDecoration(
                  color: DS.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Lvl ${seasonService.seasonLevel}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: DS.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${seasonService.getSeasonDaysRemaining()} days remaining',
                style: DS.bodyMedium,
              ),
              Text(
                '${seasonService.seasonXP} XP',
                style: DS.label.copyWith(
                  color: DS.neonGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(XPService xpService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ACTIONS',
          style: DS.label,
        ),
        SizedBox(height: DS.md),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'START WORKOUT',
                Icons.fitness_center,
                DS.neonGreen,
                () async {
                  final xpGained = await xpService.addWorkoutXP();
                  setState(() {
                    _lastXPGained = xpGained;
                    _showXPEffect = true;
                  });
                },
              ),
            ),
            SizedBox(width: DS.sm),
            Expanded(
              child: _buildActionButton(
                'MISSIONS',
                Icons.flag,
                DS.gold,
                () {
                  // Navigate to missions
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMissionsPreview() {
    return Container(
      padding: EdgeInsets.all(DS.lg),
      decoration: Glassmorphism.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MISSIONS',
                style: DS.label,
              ),
              Text(
                'View All',
                style: DS.bodySmall.copyWith(
                  color: DS.neonGreen,
                ),
              ),
            ],
          ),
          SizedBox(height: DS.md),
          _buildMissionPreviewCard('Morning Drill', '50 pushups, 50 squats', 100, DS.neonGreen),
          SizedBox(height: DS.sm),
          _buildMissionPreviewCard('Endurance Run', '5km under 30min', 150, DS.gold),
        ],
      ),
    );
  }

  Widget _buildMissionPreviewCard(String title, String description, int xp, Color color) {
    return Container(
      padding: EdgeInsets.all(DS.md),
      decoration: BoxDecoration(
        color: DS.card.withOpacity(0.6),
        borderRadius: BorderRadius.circular(DS.radiusSm),
        border: Border.all(color: color.withOpacity(0.3), width: DS.borderThin),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: DS.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: DS.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: DS.sm, vertical: DS.xs),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(DS.radiusSm),
            ),
            child: Text(
              '+$xp XP',
              style: DS.label.copyWith(
                color: color,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachPanel() {
    return Container(
      padding: EdgeInsets.all(DS.lg),
      decoration: Glassmorphism.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI COACH',
            style: DS.label,
          ),
          SizedBox(height: DS.md),
          Container(
            padding: EdgeInsets.all(DS.md),
            decoration: BoxDecoration(
              color: DS.card.withOpacity(0.4),
              borderRadius: BorderRadius.circular(DS.radiusSm),
              border: Border.all(color: DS.neonGreen.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: GlowingNode.active(color: DS.neonGreen),
                  child: const Icon(Icons.psychology, color: Colors.white, size: 24),
                ),
                SizedBox(width: DS.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Elite Mode',
                        style: DS.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ready for your next session',
                        style: DS.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: DS.neonGreen,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(DS.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(DS.radiusSm),
          border: Border.all(color: color, width: DS.borderMedium),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: DS.sm),
            Text(
              label,
              style: DS.label.copyWith(
                color: color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(XPService xpService, RankService rankService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.militaryGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RANK PROGRESS',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppTheme.neonGreen,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rankService.currentRank,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                rankService.getNextRank(),
                style: TextStyle(
                  color: AppTheme.gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: rankService.getRankProgress(xpService.totalXP),
              backgroundColor: AppTheme.tacticalBlack,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${rankService.getXPToNextRank() - xpService.totalXP} XP to next rank',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
