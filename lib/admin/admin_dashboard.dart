import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
import 'users_view/users_view.dart';
import 'missions_editor/missions_editor.dart';
import 'xp_tuning/xp_tuning.dart';
import 'season_manager/season_manager.dart';
import 'season_creator/season_creator.dart';
import 'analytics/analytics.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const UsersView(),
    const MissionsEditor(),
    const XPTuning(),
    const SeasonManager(),
    const SeasonCreator(),
    const Analytics(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DS.bg,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: DS.card,
        border: Border(
          right: BorderSide(color: DS.green, width: DS.borderThin),
        ),
      ),
      child: Column(
        children: [
          _buildSidebarHeader(),
          Divider(color: DS.green),
          _buildSidebarItems(),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: EdgeInsets.all(DS.lg),
      child: Column(
        children: [
          Icon(
            Icons.admin_panel_settings,
            color: DS.neonGreen,
            size: 48,
          ),
          SizedBox(height: DS.sm),
          Text(
            'ADMIN PANEL',
            style: DS.heading2.copyWith(color: DS.neonGreen),
          ),
          SizedBox(height: DS.xs),
          Text(
            'SoldierFit Control',
            style: DS.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItems() {
    final items = [
      {'icon': Icons.people, 'label': 'Users'},
      {'icon': Icons.flag, 'label': 'Missions'},
      {'icon': Icons.star, 'label': 'XP Tuning'},
      {'icon': Icons.emoji_events, 'label': 'Seasons'},
      {'icon': Icons.add_circle, 'label': 'Create Season'},
      {'icon': Icons.analytics, 'label': 'Analytics'},
    ];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = _selectedIndex == index;

        return ListTile(
          leading: Icon(
            item['icon'] as IconData,
            color: isSelected ? DS.neonGreen : Colors.white54,
          ),
          title: Text(
            item['label'] as String,
            style: TextStyle(
              color: isSelected ? DS.neonGreen : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          selectedTileColor: DS.green.withOpacity(0.2),
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
        );
      },
    );
  }
}
