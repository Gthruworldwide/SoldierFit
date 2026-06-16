import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class Mission {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final int difficulty;
  final String rankRequirement;

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.difficulty,
    required this.rankRequirement,
  });
}

class MissionsEditor extends StatefulWidget {
  const MissionsEditor({super.key});

  @override
  State<MissionsEditor> createState() => _MissionsEditorState();
}

class _MissionsEditorState extends State<MissionsEditor> {
  final List<Mission> _missions = [
    Mission(
      id: '1',
      title: 'Morning Drill',
      description: 'Complete 50 pushups and 50 squats',
      xpReward: 100,
      difficulty: 1,
      rankRequirement: 'Recruit',
    ),
    Mission(
      id: '2',
      title: 'Endurance Run',
      description: 'Run 5km under 30 minutes',
      xpReward: 150,
      difficulty: 2,
      rankRequirement: 'Private',
    ),
  ];

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
                'MISSIONS EDITOR',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppTheme.neonGreen,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddMissionDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Mission'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.neonGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildMissionsList(),
        ],
      ),
    );
  }

  Widget _buildMissionsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _missions.length,
      itemBuilder: (context, index) {
        final mission = _missions[index];
        return _buildMissionCard(mission, index);
      },
    );
  }

  Widget _buildMissionCard(Mission mission, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.militaryGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mission.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.neonGreen),
                    onPressed: () => _editMission(mission),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppTheme.alertRed),
                    onPressed: () => _deleteMission(index),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            mission.description,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildBadge('XP: ${mission.xpReward}', AppTheme.gold),
              const SizedBox(width: 8),
              _buildBadge('Diff: ${mission.difficulty}', AppTheme.neonGreen),
              const SizedBox(width: 8),
              _buildBadge(mission.rankRequirement, AppTheme.militaryGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAddMissionDialog() {
    showDialog(
      context: context,
      builder: (context) => _MissionDialog(
        onSave: (mission) {
          setState(() {
            _missions.add(mission);
          });
        },
      ),
    );
  }

  void _editMission(Mission mission) {
    showDialog(
      context: context,
      builder: (context) => _MissionDialog(
        mission: mission,
        onSave: (updatedMission) {
          setState(() {
            final index = _missions.indexWhere((m) => m.id == mission.id);
            if (index != -1) {
              _missions[index] = updatedMission;
            }
          });
        },
      ),
    );
  }

  void _deleteMission(int index) {
    setState(() {
      _missions.removeAt(index);
    });
  }
}

class _MissionDialog extends StatefulWidget {
  final Mission? mission;
  final Function(Mission) onSave;

  const _MissionDialog({
    this.mission,
    required this.onSave,
  });

  @override
  State<_MissionDialog> createState() => _MissionDialogState();
}

class _MissionDialogState extends State<_MissionDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _xpController;
  late TextEditingController _difficultyController;
  late TextEditingController _rankController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.mission?.title ?? '');
    _descriptionController = TextEditingController(text: widget.mission?.description ?? '');
    _xpController = TextEditingController(text: widget.mission?.xpReward.toString() ?? '100');
    _difficultyController = TextEditingController(text: widget.mission?.difficulty.toString() ?? '1');
    _rankController = TextEditingController(text: widget.mission?.rankRequirement ?? 'Recruit');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _xpController.dispose();
    _difficultyController.dispose();
    _rankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.primaryDark,
      title: Text(
        widget.mission == null ? 'Add Mission' : 'Edit Mission',
        style: const TextStyle(color: AppTheme.neonGreen),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
            ),
            TextField(
              controller: _xpController,
              decoration: const InputDecoration(
                labelText: 'XP Reward',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _difficultyController,
              decoration: const InputDecoration(
                labelText: 'Difficulty (1-5)',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _rankController,
              decoration: const InputDecoration(
                labelText: 'Rank Requirement',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: () {
            final mission = Mission(
              id: widget.mission?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
              title: _titleController.text,
              description: _descriptionController.text,
              xpReward: int.parse(_xpController.text),
              difficulty: int.parse(_difficultyController.text),
              rankRequirement: _rankController.text,
            );
            widget.onSave(mission);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonGreen),
          child: const Text('Save', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
