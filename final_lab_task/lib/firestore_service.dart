import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a schedule to Firestore
  Future<void> addSchedule(Map<String, dynamic> schedule) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(userId).collection('schedules').add(schedule);
    } catch (e) {
      print("Error adding schedule to Firestore: $e");
    }
  }

  // Update a schedule in Firestore
  Future<void> updateSchedule(String firestoreId, Map<String, dynamic> schedule) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(userId).collection('schedules').doc(firestoreId).update(schedule);
    } catch (e) {
      print("Error updating schedule in Firestore: $e");
    }
  }

  // Delete a schedule from Firestore
  Future<void> deleteSchedule(String firestoreId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(userId).collection('schedules').doc(firestoreId).delete();
    } catch (e) {
      print("Error deleting schedule from Firestore: $e");
    }
  }

  // Get all schedules from Firestore
  Future<List<Map<String, dynamic>>> getSchedules() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await _firestore.collection('users').doc(userId).collection('schedules').get();
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,  // Firestore document ID
          'name': doc['name'],
          'date': doc['date'],
          'time': doc['time'],
        };
      }).toList();
    } catch (e) {
      print("Error fetching schedules from Firestore: $e");
      throw Exception("Error fetching schedules from Firestore");
    }
  }
}
