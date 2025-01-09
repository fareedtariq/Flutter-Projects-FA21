import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ScheduleManager {
  static Database? _database;

  // Get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // Initialize the database
  initDatabase() async {
    String path = join(await getDatabasesPath(), 'schedule.db');
    return openDatabase(path, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE schedules(id INTEGER PRIMARY KEY, name TEXT, date TEXT, time TEXT)',
      );
    }, version: 1);
  }

  // Insert a schedule into the database
  Future<void> insertSchedule(Map<String, dynamic> schedule) async {
    final db = await database;
    await db.insert('schedules', schedule, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all schedules from the database
  Future<List<Map<String, dynamic>>> getSchedules() async {
    final db = await database;
    return await db.query('schedules');
  }

  // Update a schedule in the database
  Future<void> updateSchedule(Map<String, dynamic> schedule) async {
    final db = await database;
    await db.update('schedules', schedule, where: 'id = ?', whereArgs: [schedule['id']]);
  }

  // Delete a schedule from the database
  Future<void> deleteSchedule(int id) async {
    final db = await database;
    await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }

  // Clear all schedules (optional, for reset purpose)
  Future<void> clearSchedules() async {
    final db = await database;
    await db.delete('schedules');
  }
}
