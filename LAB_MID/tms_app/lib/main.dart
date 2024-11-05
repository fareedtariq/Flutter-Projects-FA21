import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(TaskManagerApp());

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData.light(), // toggle to dark theme for customization
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Map<String, dynamic>> _tasks = [];
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'task_manager.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, dueDate TEXT, completed INTEGER, repeatDays TEXT)",
        );
      },
    );
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final tasks = await _database?.query('tasks');
    setState(() {
      _tasks = tasks ?? [];
    });
  }

  Future<void> _addTask(String title, String description, String dueDate, bool repeat) async {
    await _database?.insert(
      'tasks',
      {
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'completed': 0,
        'repeatDays': repeat ? 'Mon, Wed, Fri' : '',
      },
    );
    _fetchTasks();
  }

  Future<void> _markAsCompleted(int id) async {
    await _database?.update(
      'tasks',
      {'completed': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchTasks();
  }

  Future<void> _deleteTask(int id) async {
    await _database?.delete(
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
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddTaskDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task['title']),
            subtitle: Text(task['description']),
            trailing: IconButton(
              icon: Icon(Icons.check, color: task['completed'] == 1 ? Colors.green : Colors.grey),
              onPressed: () => _markAsCompleted(task['id']),
            ),
            onLongPress: () => _deleteTask(task['id']),
          );
        },
      ),
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final dueDateController = TextEditingController();
    bool isRepeating = false; // Variable to track the checkbox state

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // Ensure correct BuildContext
        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: dueDateController,
                decoration: InputDecoration(labelText: 'Due Date'),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: dialogContext, // Use dialogContext
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    dueDateController.text = selectedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
              CheckboxListTile(
                title: Text('Repeat Task'),
                value: isRepeating,
                onChanged: (value) {
                  setState(() {
                    isRepeating = value ?? false; // Update checkbox state
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Use dialogContext
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addTask(
                  titleController.text,
                  descriptionController.text,
                  dueDateController.text,
                  isRepeating, // Pass the checkbox state
                );
                Navigator.of(dialogContext).pop(); // Use dialogContext
              },
              child: Text('Add Task'),
            ),
          ],
        );
      },
    );
  }
}
