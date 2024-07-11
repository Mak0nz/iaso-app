import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iaso/src/services/stats/stats.dart';
import 'package:intl/intl.dart';

class StatsFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createStatsForUser(Stats stats) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final formattedDate = DateFormat('yyyy.M.d').format(stats.dateField);
    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('StatsForUser')
        .doc(formattedDate);

    await docRef.set(stats.toJson());
  }

  Future<Stats?> fetchStats(DateTime selectedDate) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final formattedDate = DateFormat('yyyy.M.d').format(selectedDate);
    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('StatsForUser')
        .doc(formattedDate);

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      return Stats.fromJson(docSnapshot.data()!);
    }
    return null;
  }

}