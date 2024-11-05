import 'package:tms_app/models/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        dueDate TEXT,  -- Add this line if you're storing due dates
        repeatInterval INTEGER,
        isCompleted INTEGER DEFAULT 0,
        isRepeated INTEGER DEFAULT 0  -- Include this if you have a isRepeated field
      )
    ''');
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]); // Use the factory method to create Task
    });
  }

  Future<List<Task>> getRepeatedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'repeatInterval IS NOT NULL',
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]); // Use the factory method to create Task
    });
  }

  Future<List<Task>> getCompletedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]); // Use the factory method to create Task
    });
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
