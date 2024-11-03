import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Switch between light and dark
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system, // Can be toggled for customization
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  Database? _database;
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'tasks_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, dueDate TEXT, isCompleted INTEGER)',
        );
      },
      version: 1,
    );
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final List<Map<String, dynamic>> tasks = await _database!.query('tasks');
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask(String title, String description, String dueDate) async {
    await _database!.insert(
      'tasks',
      {'title': title, 'description': description, 'dueDate': dueDate, 'isCompleted': 0},
    );
    _fetchTasks();
  }

  Future<void> _toggleTaskCompletion(int id, int isCompleted) async {
    await _database!.update(
      'tasks',
      {'isCompleted': isCompleted == 1 ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchTasks();
  }

  Future<void> _deleteTask(int id) async {
    await _database!.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management App'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task['title']),
            subtitle: Text(task['description']),
            trailing: Checkbox(
              value: task['isCompleted'] == 1,
              onChanged: (bool? value) {
                _toggleTaskCompletion(task['id'], task['isCompleted']);
              },
            ),
            onLongPress: () => _deleteTask(task['id']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _dueDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(labelText: 'Due Date'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addTask(
                _titleController.text,
                _descriptionController.text,
                _dueDateController.text,
              );
              Navigator.of(context).pop();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }
}
