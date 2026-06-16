import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../services/firebase/admin_firebase_service.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final AdminFirebaseService _adminService = AdminFirebaseService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
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
                'USERS MANAGEMENT',
                style: DS.heading1.copyWith(color: DS.neonGreen),
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: DS.card,
                  borderRadius: BorderRadius.circular(DS.radiusSm),
                  border: Border.all(color: DS.green),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search, color: DS.neonGreen),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(DS.sm),
                    hintStyle: DS.bodyMedium.copyWith(color: Colors.white54),
                  ),
                  style: DS.bodyMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: DS.lg),
          _buildUsersTable(),
        ],
      ),
    );
  }

  Widget _buildUsersTable() {
    return StreamBuilder<QuerySnapshot>(
      stream: _adminService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: DS.neonGreen));
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading users',
              style: DS.bodyMedium.copyWith(color: DS.alertRed),
            ),
          );
        }

        final users = snapshot.data?.docs ?? [];

        if (users.isEmpty) {
          return Center(
            child: Text(
              'No users found',
              style: DS.bodyMedium,
            ),
          );
        }

        return Container(
          decoration: Glassmorphism.card,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildTableHeader(),
              ...users.map((doc) {
                final userData = doc.data() as Map<String, dynamic>;
                return _buildUserRow(doc.id, userData);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.all(DS.md),
      decoration: BoxDecoration(
        color: DS.green.withOpacity(0.2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(DS.radiusSm),
          topRight: Radius.circular(DS.radiusSm),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Name', style: DS.label)),
          Expanded(flex: 2, child: Text('Email', style: DS.label)),
          Expanded(child: Text('XP', style: DS.label)),
          Expanded(child: Text('Rank', style: DS.label)),
          Expanded(child: Text('Streak', style: DS.label)),
          Expanded(child: Text('Actions', style: DS.label)),
        ],
      ),
    );
  }

  Widget _buildUserRow(String userId, Map<String, dynamic> userData) {
    return Container(
      padding: EdgeInsets.all(DS.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: DS.green.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(userData['name'] ?? 'Unknown', style: DS.bodyMedium)),
          Expanded(flex: 2, child: Text(userData['email'] ?? 'No email', style: DS.bodyMedium.copyWith(color: Colors.white70))),
          Expanded(child: Text('${userData['xp'] ?? 0}', style: DS.bodyMedium.copyWith(color: DS.gold))),
          Expanded(child: Text(userData['rank'] ?? 'Recruit', style: DS.bodyMedium.copyWith(color: DS.neonGreen))),
          Expanded(child: Text('${userData['streak'] ?? 0} days', style: DS.bodyMedium)),
          Expanded(
            child: Row(
              children: [
                _buildActionButton('+XP', DS.neonGreen, () => _addXP(userId, userData)),
                SizedBox(width: DS.xs),
                _buildActionButton('Promote', DS.gold, () => _promoteUser(userId, userData)),
                SizedBox(width: DS.xs),
                _buildActionButton('Reset', DS.alertRed, () => _resetUser(userId, userData)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: DS.sm, vertical: DS.xs),
        minimumSize: Size.zero,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }

  Future<void> _addXP(String userId, Map<String, dynamic> userData) async {
    try {
      await _adminService.updateUserXP(userId, 100);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added 100 XP to ${userData['name'] ?? 'User'}'),
            backgroundColor: DS.neonGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding XP: $e'),
            backgroundColor: DS.alertRed,
          ),
        );
      }
    }
  }

  Future<void> _promoteUser(String userId, Map<String, dynamic> userData) async {
    try {
      final currentRank = userData['rank'] as String? ?? 'Recruit';
      final ranks = ['Recruit', 'Corporal', 'Sergeant', 'Lieutenant', 'Captain', 'Major', 'Colonel', 'General', 'Commander'];
      final currentIndex = ranks.indexOf(currentRank);
      
      if (currentIndex < ranks.length - 1) {
        final newRank = ranks[currentIndex + 1];
        await _adminService.updateUserRank(userId, newRank);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Promoted ${userData['name'] ?? 'User'} to $newRank'),
              backgroundColor: DS.gold,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${userData['name'] ?? 'User'} is already at maximum rank'),
              backgroundColor: DS.warningOrange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error promoting user: $e'),
            backgroundColor: DS.alertRed,
          ),
        );
      }
    }
  }

  Future<void> _resetUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _adminService.resetUserProgress(userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reset ${userData['name'] ?? 'User'} progress'),
            backgroundColor: DS.alertRed,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error resetting user: $e'),
            backgroundColor: DS.alertRed,
          ),
        );
      }
    }
  }
}
