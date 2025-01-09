import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a schedule to Firestore
  Future<void> addSchedule(Map<String, dynamic> schedule) async {
    await _db.collection('schedules').add(schedule);
  }

  // Update a schedule in Firestore
  Future<void> updateSchedule(String id, Map<String, dynamic> schedule) async {
    await _db.collection('schedules').doc(id).update(schedule);
  }

  // Delete a schedule from Firestore
  Future<void> deleteSchedule(String id) async {
    await _db.collection('schedules').doc(id).delete();
  }

  // Get all schedules from Firestore
  Future<List<Map<String, dynamic>>> getSchedules() async {
    QuerySnapshot querySnapshot = await _db.collection('schedules').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
