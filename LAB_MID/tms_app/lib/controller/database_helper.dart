import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tms_app/Models//task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        dueDate TEXT,
        isCompleted INTEGER
      )
    ''');
  }

  Future<void> insertTask(Task task) async {
    final db = await instance.database;
    await db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> fetchTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
