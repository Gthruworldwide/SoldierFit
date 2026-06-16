import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class XPTuning extends StatefulWidget {
  const XPTuning({super.key});

  @override
  State<XPTuning> createState() => _XPTuningState();
}

class _XPTuningState extends State<XPTuning> {
  late TextEditingController _workoutXPController;
  late TextEditingController _missionXPController;
  late TextEditingController _streakXPController;
  late TextEditingController _levelUpXPController;

  @override
  void initState() {
    super.initState();
    _workoutXPController = TextEditingController(text: AppConstants.xpPerWorkout.toString());
    _missionXPController = TextEditingController(text: AppConstants.xpPerMission.toString());
    _streakXPController = TextEditingController(text: AppConstants.xpPerStreakDay.toString());
    _levelUpXPController = TextEditingController(text: AppConstants.xpPerLevelUp.toString());
  }

  @override
  void dispose() {
    _workoutXPController.dispose();
    _missionXPController.dispose();
    _streakXPController.dispose();
    _levelUpXPController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'XP TUNING',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppTheme.neonGreen,
            ),
          ),
          const SizedBox(height: 24),
          _buildXPSettings(),
        ],
      ),
    );
  }

  Widget _buildXPSettings() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.militaryGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildXPField('XP per Workout', _workoutXPController),
          const SizedBox(height: 16),
          _buildXPField('XP per Mission', _missionXPController),
          const SizedBox(height: 16),
          _buildXPField('XP per Streak Day', _streakXPController),
          const SizedBox(height: 16),
          _buildXPField('XP per Level Up', _levelUpXPController),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.neonGreen,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text(
              'Save Settings',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.neonGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.tacticalBlack,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.militaryGreen),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.militaryGreen),
            ),
          ),
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('XP settings saved successfully'),
        backgroundColor: AppTheme.neonGreen,
      ),
    );
  }
}
