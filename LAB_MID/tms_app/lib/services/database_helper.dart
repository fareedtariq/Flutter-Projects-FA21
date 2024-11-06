import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tms_app/Models/task_model.dart' as taskModel;  // Alias to avoid conflicts

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
        isCompleted INTEGER,
        repeatInterval TEXT,
        progress REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE subtasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskId INTEGER,
        title TEXT,
        isCompleted INTEGER,
        FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
      )
    ''');
  }

  // Task Operations

  Future<int> insertTask(taskModel.Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<taskModel.Task>> fetchTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks', orderBy: 'dueDate');
    return result.map((json) => taskModel.Task.fromMap(json)).toList();
  }

  Future<List<taskModel.Task>> fetchTodayTasks(String todayDate) async {
    final db = await instance.database;
    final result = await db.query('tasks', where: 'dueDate = ?', whereArgs: [todayDate]);
    return result.map((json) => taskModel.Task.fromMap(json)).toList();
  }

  Future<List<taskModel.Task>> fetchCompletedTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks', where: 'isCompleted = ?', whereArgs: [1]);
    return result.map((json) => taskModel.Task.fromMap(json)).toList();
  }

  Future<int> updateTask(taskModel.Task task) async {
    final db = await instance.database;
    return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> markTaskAsCompleted(int id) async {
    final db = await instance.database;
    return await db.update('tasks', {'isCompleted': 1}, where: 'id = ?', whereArgs: [id]);
  }

  // Repeat Tasks
  Future<List<taskModel.Task>> fetchRepeatedTasks(String interval) async {
    final db = await instance.database;
    final result = await db.query('tasks', where: 'repeatInterval = ?', whereArgs: [interval]);
    return result.map((json) => taskModel.Task.fromMap(json)).toList();
  }

  // Subtasks and Progress Tracking

  Future<int> insertSubtask(taskModel.Subtask subtask) async {
    final db = await instance.database;
    return await db.insert('subtasks', subtask.toMap());
  }

  Future<List<taskModel.Subtask>> fetchSubtasks(int taskId) async {
    final db = await instance.database;
    final result = await db.query('subtasks', where: 'taskId = ?', whereArgs: [taskId]);
    return result.map((json) => taskModel.Subtask.fromMap(json)).toList();
  }

  Future<int> markSubtaskAsCompleted(int id) async {
    final db = await instance.database;
    return await db.update('subtasks', {'isCompleted': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<double> calculateTaskProgress(int taskId) async {
    final db = await instance.database;
    final subtasks = await fetchSubtasks(taskId);
    if (subtasks.isEmpty) return 1.0;

    final completedSubtasks = subtasks.where((s) => s.isCompleted).length;
    final progress = completedSubtasks / subtasks.length;
    await db.update('tasks', {'progress': progress}, where: 'id = ?', whereArgs: [taskId]);
    return progress;
  }

  // Export and Close Database

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
