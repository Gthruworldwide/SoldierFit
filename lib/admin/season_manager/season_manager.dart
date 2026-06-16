import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/season/season_service.dart';

class SeasonManager extends StatefulWidget {
  const SeasonManager({super.key});

  @override
  State<SeasonManager> createState() => _SeasonManagerState();
}

class _SeasonManagerState extends State<SeasonManager> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SEASON MANAGER',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppTheme.neonGreen,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showCreateSeasonDialog,
                icon: const Icon(Icons.add),
                label: const Text('Create Season'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.neonGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSeasonCard(),
        ],
      ),
    );
  }

  Widget _buildSeasonCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.ironDark,
            AppTheme.ironMetallic,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.goldBright, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                SeasonService.seasonName,
                style: const TextStyle(
                  color: AppTheme.goldBright,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.neonGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Duration: 90 days',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          const Text(
            'Max Level: 50',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Season'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.goldBright,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Season'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.alertRed,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateSeasonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.primaryDark,
        title: const Text(
          'Create New Season',
          style: TextStyle(color: AppTheme.neonGreen),
        ),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Season Name',
            labelStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonGreen),
            child: const Text('Create', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
