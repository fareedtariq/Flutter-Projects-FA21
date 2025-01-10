import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'assignment.dart';  // Assuming you have an `Assignment` model defined in assignment.dart

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // *** Schedule CRUD Operations ***

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

  // *** Assignment CRUD Operations ***

  // Add an assignment to Firestore (user-specific)
  Future<void> addAssignment(Assignment assignment) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(userId).collection('assignments').add(assignment.toMap());
    } catch (e) {
      print("Error adding assignment to Firestore: $e");
    }
  }

  // Update an assignment in Firestore
  Future<void> updateAssignment(String firestoreId, Assignment assignment) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(userId).collection('assignments').doc(firestoreId).update(assignment.toMap());
    } catch (e) {
      print("Error updating assignment in Firestore: $e");
    }
  }

  // Delete an assignment from Firestore
  Future<void> deleteAssignment(String firestoreId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(userId).collection('assignments').doc(firestoreId).delete();
    } catch (e) {
      print("Error deleting assignment from Firestore: $e");
    }
  }

  // Get all assignments from Firestore (user-specific)
  Future<List<Assignment>> getAssignments() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      final querySnapshot = await _firestore.collection('users').doc(userId).collection('assignments').get();
      return querySnapshot.docs.map((doc) {
        return Assignment.fromMap(doc.data());
      }).toList();
    } catch (e) {
      print("Error fetching assignments from Firestore: $e");
      throw Exception("Error fetching assignments from Firestore");
    }
  }
}
