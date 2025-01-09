import 'package:firebase_auth/firebase_auth.dart';
import 'schedule_database.dart';
import 'firestore_service.dart';

class ScheduleManager {
  final ScheduleDatabase _db = ScheduleDatabase();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sync local schedules with Firestore when online
  Future<void> syncSchedules() async {
    try {
      // Check if there is an internet connection (or Firestore availability)
      if (_auth.currentUser != null) {
        // Get local schedules from SQFlite
        List<Map<String, dynamic>> localSchedules = await _db.getSchedules();

        for (var schedule in localSchedules) {
          // Sync each local schedule to Firestore
          await _firestoreService.addSchedule(schedule);
          // Remove from local storage after syncing
          await _db.deleteSchedule(schedule['id']);
        }
      }
    } catch (e) {
      print("Error syncing schedules: $e");
    }
  }

  // Add a new schedule locally and in Firestore
  Future<void> addSchedule(Map<String, dynamic> schedule) async {
    await _db.insertSchedule(schedule);  // Insert to local database
    await _firestoreService.addSchedule(schedule);  // Insert to Firestore
  }

  // Update an existing schedule
  Future<void> updateSchedule(String id, Map<String, dynamic> schedule) async {
    await _db.updateSchedule(schedule);  // Update in local database
    await _firestoreService.updateSchedule(id, schedule);  // Update in Firestore
  }

  // Delete a schedule
  Future<void> deleteSchedule(int id, String firestoreId) async {
    await _db.deleteSchedule(id);  // Delete from local database
    await _firestoreService.deleteSchedule(firestoreId);  // Delete from Firestore
  }

  // Get schedules from Firestore or local storage
  Future<List<Map<String, dynamic>>> getSchedules() async {
    try {
      List<Map<String, dynamic>> schedules = await _firestoreService.getSchedules();
      if (schedules.isEmpty) {
        schedules = await _db.getSchedules(); // Fallback to local storage if Firestore is empty
      }
      return schedules;
    } catch (e) {
      print("Error fetching schedules: $e");
      return await _db.getSchedules();  // Fetch from local storage in case of error
    }
  }
}
