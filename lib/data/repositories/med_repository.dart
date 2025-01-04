import 'package:iaso/domain/medication.dart';

class MedRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Medication>> getMedications() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('MedsForUser')
          .orderBy('name')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Medication.fromFirestore(doc))
              .toList());
    }
    return Stream.value([]);
  }

  Future<List<Medication>> getMedicationsList() async {
    final medicationsStream = getMedications();
    return await medicationsStream.first;
  }

  Future<void> addMedication(Medication medication) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('MedsForUser')
          .add(medication.toFirestore());
    }
  }

  Future<void> updateMedication(Medication medication) async {
    final user = _auth.currentUser;
    if (user != null && medication.id != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('MedsForUser')
          .doc(medication.id)
          .update(medication.toFirestore());
    }
  }

  Future<void> deleteMedication(String medicationId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('MedsForUser')
          .doc(medicationId)
          .delete();
    }
  }
}
