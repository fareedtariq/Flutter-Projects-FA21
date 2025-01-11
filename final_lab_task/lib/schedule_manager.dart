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
    return openDatabase(path, version: 2, onCreate: (db, version) {
      // Create schedules table
      db.execute(
        'CREATE TABLE schedules(id INTEGER PRIMARY KEY, name TEXT, date TEXT, time TEXT)',
      );
      // Create assignments table with filePath column
      db.execute(
        'CREATE TABLE assignments(id TEXT PRIMARY KEY, title TEXT, deadline TEXT, filePath TEXT)',
      );
    }, onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < 2) {
        // Add the filePath column to the assignments table during an upgrade
        db.execute('ALTER TABLE assignments ADD COLUMN filePath TEXT');
      }
    });
  }

  // *** Schedule Operations ***

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
    await db.update(
      'schedules',
      schedule,
      where: 'id = ?',
      whereArgs: [schedule['id']],
    );
  }

  // Delete a schedule from the database
  Future<void> deleteSchedule(int id) async {
    final db = await database;
    await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }

  // Clear all schedules
  Future<void> clearSchedules() async {
    final db = await database;
    await db.delete('schedules');
  }

  // *** Assignment Operations ***

  // Save an assignment to the local database
  Future<void> saveAssignmentToLocal(Map<String, dynamic> assignment) async {
    final db = await database;
    await db.insert(
      'assignments',
      {
        'id': assignment['id'],
        'title': assignment['title'],
        'deadline': assignment['deadline'],
        'filePath': assignment['filePath'], // Add filePath to the assignment
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch assignments from the local database
  Future<List<Map<String, dynamic>>> getAssignmentsFromLocal() async {
    final db = await database;
    return await db.query('assignments');
  }

  // Update an assignment in the local database
  Future<void> updateAssignment(Map<String, dynamic> assignment) async {
    final db = await database;
    await db.update(
      'assignments',
      {
        'title': assignment['title'],
        'deadline': assignment['deadline'],
        'filePath': assignment['filePath'], // Update filePath in the assignment
      },
      where: 'id = ?',
      whereArgs: [assignment['id']],
    );
  }

  // Delete an assignment from the local database
  Future<void> deleteAssignment(String assignmentId) async {
    final db = await database;
    await db.delete('assignments', where: 'id = ?', whereArgs: [assignmentId]);
  }

  // Clear all assignments
  Future<void> clearAssignments() async {
    final db = await database;
    await db.delete('assignments');
  }
}
