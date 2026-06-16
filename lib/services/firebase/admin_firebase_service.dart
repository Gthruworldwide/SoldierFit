import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AdminFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Admin-specific methods with elevated permissions
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      debugPrint('Error fetching users: $e');
      return [];
    }
  }

  Future<void> updateUserXP(String userId, int xpToAdd) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'xp': FieldValue.increment(xpToAdd),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating user XP: $e');
      rethrow;
    }
  }

  Future<void> updateUserRank(String userId, String newRank) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'rank': newRank,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating user rank: $e');
      rethrow;
    }
  }

  Future<void> resetUserProgress(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'xp': 0,
        'rank': 'Recruit',
        'streak': 0,
        'seasonXP': 0,
        'seasonLevel': 1,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error resetting user progress: $e');
      rethrow;
    }
  }

  Future<void> banUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isBanned': true,
        'bannedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error banning user: $e');
      rethrow;
    }
  }

  Future<void> unbanUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isBanned': false,
        'unbannedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error unbanning user: $e');
      rethrow;
    }
  }

  // Missions management
  Future<void> createMission(Map<String, dynamic> missionData) async {
    try {
      await _firestore.collection('missions').add({
        ...missionData,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
    } catch (e) {
      debugPrint('Error creating mission: $e');
      rethrow;
    }
  }

  Future<void> updateMission(String missionId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('missions').doc(missionId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating mission: $e');
      rethrow;
    }
  }

  Future<void> deleteMission(String missionId) async {
    try {
      await _firestore.collection('missions').doc(missionId).delete();
    } catch (e) {
      debugPrint('Error deleting mission: $e');
      rethrow;
    }
  }

  // Season management
  Future<void> createSeason(Map<String, dynamic> seasonData) async {
    try {
      await _firestore.collection('seasons').add({
        ...seasonData,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
    } catch (e) {
      debugPrint('Error creating season: $e');
      rethrow;
    }
  }

  Future<void> updateSeason(String seasonId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('seasons').doc(seasonId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating season: $e');
      rethrow;
    }
  }

  // Analytics data
  Future<Map<String, dynamic>> getAnalyticsData() async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();
      final missionsSnapshot = await _firestore.collection('missions').get();
      final analyticsSnapshot = await _firestore.collection('analytics')
          .orderBy('timestamp', descending: true)
          .limit(100)
          .get();

      final totalUsers = usersSnapshot.docs.length;
      final totalMissions = missionsSnapshot.docs.length;
      
      // Calculate XP distribution
      final xpValues = usersSnapshot.docs
          .map((doc) => doc.data()['xp'] as int? ?? 0)
          .toList();
      
      final totalXP = xpValues.reduce((a, b) => a + b);
      final averageXP = totalUsers > 0 ? totalXP / totalUsers : 0;

      // Calculate rank distribution
      final rankDistribution = <String, int>{};
      for (final doc in usersSnapshot.docs) {
        final rank = doc.data()['rank'] as String? ?? 'Unknown';
        rankDistribution[rank] = (rankDistribution[rank] ?? 0) + 1;
      }

      return {
        'totalUsers': totalUsers,
        'totalMissions': totalMissions,
        'totalXP': totalXP,
        'averageXP': averageXP,
        'rankDistribution': rankDistribution,
        'recentEvents': analyticsSnapshot.docs.map((doc) => doc.data()).toList(),
      };
    } catch (e) {
      debugPrint('Error fetching analytics data: $e');
      return {};
    }
  }

  // Real-time streams for admin dashboard
  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('users').orderBy('lastUpdated', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getMissionsStream() {
    return _firestore.collection('missions').orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAnalyticsStream() {
    return _firestore
        .collection('analytics')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  // Batch operations for efficiency
  Future<void> batchUpdateUsers(List<String> userIds, Map<String, dynamic> updates) async {
    final batch = _firestore.batch();
    
    for (final userId in userIds) {
      final docRef = _firestore.collection('users').doc(userId);
      batch.update(docRef, updates);
    }
    
    try {
      await batch.commit();
    } catch (e) {
      debugPrint('Error in batch update: $e');
      rethrow;
    }
  }

  // Search and filtering
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUsersByRank(String rank) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('rank', isEqualTo: rank)
          .get();
      
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      debugPrint('Error fetching users by rank: $e');
      return [];
    }
  }
}
