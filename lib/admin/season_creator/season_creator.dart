import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../services/season/season_service.dart';

class SeasonCreator extends StatefulWidget {
  const SeasonCreator({super.key});

  @override
  State<SeasonCreator> createState() => _SeasonCreatorState();
}

class _SeasonCreatorState extends State<SeasonCreator> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController(text: '30');
  final _maxLevelController = TextEditingController(text: '50');
  final _xpPerLevelController = TextEditingController(text: '500');
  
  List<SeasonReward> _rewards = [];

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _maxLevelController.dispose();
    _xpPerLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(DS.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SEASON CREATOR',
                style: DS.heading1.copyWith(color: DS.neonGreen),
              ),
              ElevatedButton.icon(
                onPressed: _saveSeason,
                icon: const Icon(Icons.save),
                label: const Text('Create Season'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DS.neonGreen,
                ),
              ),
            ],
          ),
          SizedBox(height: DS.lg),
          _buildSeasonForm(),
          SizedBox(height: DS.lg),
          _buildRewardsSection(),
        ],
      ),
    );
  }

  Widget _buildSeasonForm() {
    return Container(
      padding: EdgeInsets.all(DS.lg),
      decoration: Glassmorphism.card,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SEASON DETAILS',
              style: DS.label,
            ),
            SizedBox(height: DS.md),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Season Name',
                filled: true,
                fillColor: DS.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DS.radiusSm),
                  borderSide: const BorderSide(color: DS.green),
                ),
                labelStyle: const TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            SizedBox(height: DS.md),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      labelText: 'Duration (days)',
                      filled: true,
                      fillColor: DS.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(DS.radiusSm),
                        borderSide: const BorderSide(color: DS.green),
                      ),
                      labelStyle: const TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                SizedBox(width: DS.md),
                Expanded(
                  child: TextFormField(
                    controller: _maxLevelController,
                    decoration: InputDecoration(
                      labelText: 'Max Level',
                      filled: true,
                      fillColor: DS.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(DS.radiusSm),
                        borderSide: const BorderSide(color: DS.green),
                      ),
                      labelStyle: const TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                SizedBox(width: DS.md),
                Expanded(
                  child: TextFormField(
                    controller: _xpPerLevelController,
                    decoration: InputDecoration(
                      labelText: 'XP Per Level',
                      filled: true,
                      fillColor: DS.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(DS.radiusSm),
                        borderSide: const BorderSide(color: DS.green),
                      ),
                      labelStyle: const TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsSection() {
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
                'REWARDS (${_rewards.length})',
                style: DS.label,
              ),
              ElevatedButton.icon(
                onPressed: _showAddRewardDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Reward'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DS.gold,
                ),
              ),
            ],
          ),
          SizedBox(height: DS.md),
          ..._rewards.map((reward) => _buildRewardItem(reward)),
        ],
      ),
    );
  }

  Widget _buildRewardItem(SeasonReward reward) {
    return Container(
      margin: EdgeInsets.only(bottom: DS.sm),
      padding: EdgeInsets.all(DS.md),
      decoration: BoxDecoration(
        color: DS.card.withOpacity(0.6),
        borderRadius: BorderRadius.circular(DS.radiusSm),
        border: Border.all(
          color: reward.isPremium ? DS.gold : DS.green,
          width: DS.borderThin,
        ),
      ),
      child: Row(
        children: [
          Text(
            reward.icon,
            style: const TextStyle(fontSize: 24),
          ),
          SizedBox(width: DS.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level ${reward.level}: ${reward.name}',
                  style: DS.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  reward.description,
                  style: DS.bodySmall,
                ),
              ],
            ),
          ),
          if (reward.isPremium)
            Container(
              padding: EdgeInsets.symmetric(horizontal: DS.sm, vertical: DS.xs),
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
          SizedBox(width: DS.sm),
          IconButton(
            icon: const Icon(Icons.delete, color: DS.alertRed),
            onPressed: () => _removeReward(reward),
          ),
        ],
      ),
    );
  }

  void _showAddRewardDialog() {
    final levelController = TextEditingController();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final iconController = TextEditingController();
    bool isPremium = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: DS.card,
          title: Text(
            'Add Reward',
            style: DS.heading3.copyWith(color: DS.neonGreen),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: levelController,
                  decoration: InputDecoration(
                    labelText: 'Level',
                    filled: true,
                    fillColor: DS.card,
                    labelStyle: const TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: DS.sm),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: DS.card,
                    labelStyle: const TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(height: DS.sm),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    filled: true,
                    fillColor: DS.card,
                    labelStyle: const TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(height: DS.sm),
                TextField(
                  controller: iconController,
                  decoration: InputDecoration(
                    labelText: 'Icon (emoji)',
                    filled: true,
                    fillColor: DS.card,
                    labelStyle: const TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(height: DS.sm),
                CheckboxListTile(
                  title: Text(
                    'Premium Reward',
                    style: DS.bodyMedium.copyWith(color: Colors.white),
                  ),
                  value: isPremium,
                  onChanged: (value) {
                    setDialogState(() {
                      isPremium = value ?? false;
                    });
                  },
                  activeColor: DS.gold,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: DS.bodyMedium.copyWith(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (levelController.text.isNotEmpty && nameController.text.isNotEmpty) {
                  setState(() {
                    _rewards.add(SeasonReward(
                      level: int.parse(levelController.text),
                      name: nameController.text,
                      description: descriptionController.text,
                      type: 'custom',
                      icon: iconController.text.isNotEmpty ? iconController.text : '🎁',
                      isPremium: isPremium,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: DS.neonGreen),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeReward(SeasonReward reward) {
    setState(() {
      _rewards.remove(reward);
    });
  }

  void _saveSeason() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Season "${_nameController.text}" created successfully'),
          backgroundColor: DS.neonGreen,
        ),
      );
    }
  }
}

class SeasonReward {
  final int level;
  final String name;
  final String description;
  final String type;
  final String icon;
  final bool isPremium;

  SeasonReward({
    required this.level,
    required this.name,
    required this.description,
    required this.type,
    required this.icon,
    this.isPremium = false,
  });
}
