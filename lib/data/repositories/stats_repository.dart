import 'package:iaso/domain/stats.dart';

class StatsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createStatsForUser(Stats stats) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('StatsForUser')
        .doc(stats.dateField.year.toString())
        .collection(stats.dateField.month.toString())
        .doc(stats.dateField.day.toString());

    await docRef.set(stats.toJson());
  }

  Future<Stats?> fetchStats(DateTime selectedDate) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('StatsForUser')
        .doc(selectedDate.year.toString())
        .collection(selectedDate.month.toString())
        .doc(selectedDate.day.toString());

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      return Stats.fromJson(docSnapshot.data()!);
    }
    return null;
  }
}
