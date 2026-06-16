import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class Mission {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final int difficulty;
  final String rankRequirement;
  final String icon;
  final bool isCompleted;

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.difficulty,
    required this.rankRequirement,
    required this.icon,
    this.isCompleted = false,
  });
}

class MissionsPage extends StatefulWidget {
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  final List<Mission> _missions = [
    Mission(
      id: '1',
      title: 'Morning Drill',
      description: 'Complete 50 pushups and 50 squats',
      xpReward: 100,
      difficulty: 1,
      rankRequirement: 'Recruit',
      icon: '🌅',
    ),
    Mission(
      id: '2',
      title: 'Endurance Run',
      description: 'Run 5km under 30 minutes',
      xpReward: 150,
      difficulty: 2,
      rankRequirement: 'Private',
      icon: '🏃',
    ),
    Mission(
      id: '3',
      title: 'Strength Training',
      description: 'Complete 100 pushups, 100 squats, 50 burpees',
      xpReward: 200,
      difficulty: 3,
      rankRequirement: 'Corporal',
      icon: '💪',
    ),
    Mission(
      id: '4',
      title: 'Elite Challenge',
      description: 'Complete 200 pushups, 200 squats, 100 burpees',
      xpReward: 300,
      difficulty: 4,
      rankRequirement: 'Sergeant',
      icon: '⭐',
    ),
    Mission(
      id: '5',
      title: 'Special Forces Test',
      description: 'Complete all exercises under 20 minutes',
      xpReward: 500,
      difficulty: 5,
      rankRequirement: 'Lieutenant',
      icon: '🎯',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tacticalBlack,
      appBar: AppBar(
        title: const Text('MISSIONS'),
        backgroundColor: AppTheme.tacticalBlack,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _missions.length,
        itemBuilder: (context, index) {
          final mission = _missions[index];
          return _buildMissionCard(mission, index);
        },
      ),
    );
  }

  Widget _buildMissionCard(Mission mission, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mission.isCompleted
            ? AppTheme.militaryGreen.withOpacity(0.3)
            : AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: mission.isCompleted
              ? AppTheme.neonGreen
              : AppTheme.militaryGreen,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    mission.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mission.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mission.rankRequirement,
                        style: TextStyle(
                          color: AppTheme.gold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(mission.difficulty),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Difficulty ${mission.difficulty}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            mission.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: AppTheme.gold,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+${mission.xpReward} XP',
                    style: const TextStyle(
                      color: AppTheme.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (!mission.isCompleted)
                ElevatedButton(
                  onPressed: () {
                    _startMission(mission, index);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.neonGreen,
                  ),
                  child: const Text('START'),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.neonGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'COMPLETED',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return AppTheme.neonGreen;
      case 2:
        return AppTheme.primaryGreen;
      case 3:
        return AppTheme.warningOrange;
      case 4:
        return AppTheme.alertRed;
      case 5:
        return Colors.purple;
      default:
        return AppTheme.neonGreen;
    }
  }

  void _startMission(Mission mission, int index) {
    // Navigate to mission detail/start page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting ${mission.title}...'),
        backgroundColor: AppTheme.neonGreen,
      ),
    );
  }
}
