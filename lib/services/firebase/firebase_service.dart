import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/firebase_collections.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => _auth.currentUser != null;

  Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // Authentication
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmailPassword(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // User Data
  Future<void> createUserData(String userId, Map<String, dynamic> data) async {
    await _firestore.collection(FirebaseCollections.users).doc(userId).set(data);
  }

  Future<DocumentSnapshot> getUserData(String userId) async {
    return await _firestore.collection(FirebaseCollections.users).doc(userId).get();
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    await _firestore.collection(FirebaseCollections.users).doc(userId).update(data);
  }

  // Missions
  Future<QuerySnapshot> getMissions() async {
    return await _firestore.collection(FirebaseCollections.missions).get();
  }

  Future<void> completeMission(String userId, String missionId, Map<String, dynamic> data) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('completed_missions')
        .doc(missionId)
        .set(data);
  }

  // Seasons
  Future<DocumentSnapshot> getSeasonData(String seasonId) async {
    return await _firestore.collection(FirebaseCollections.seasons).doc(seasonId).get();
  }

  Future<void> updateSeasonProgress(String userId, String seasonId, Map<String, dynamic> data) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection('seasons')
        .doc(seasonId)
        .set(data, SetOptions(merge: true));
  }

  // Coach Memory
  Future<void> saveCoachMemory(String userId, Map<String, dynamic> memory) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.coachMemory)
        .add(memory);
  }

  Future<QuerySnapshot> getCoachMemory(String userId) async {
    return await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .collection(FirebaseCollections.coachMemory)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();
  }

  // Analytics
  Future<void> logEvent(String eventName, Map<String, dynamic> parameters) async {
    await _firestore.collection(FirebaseCollections.analytics).add({
      'event': eventName,
      'parameters': parameters,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': currentUser?.uid,
    });
  }

  // Real-time listeners
  Stream<DocumentSnapshot> userStream(String userId) {
    return _firestore.collection(FirebaseCollections.users).doc(userId).snapshots();
  }

  Stream<QuerySnapshot> missionsStream() {
    return _firestore.collection(FirebaseCollections.missions).snapshots();
  }
}
