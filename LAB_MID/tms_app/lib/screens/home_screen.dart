import 'package:flutter/material.dart';
import 'package:tms_app/models/task_model.dart';
import 'package:tms_app/services/database_helper.dart';
import 'package:tms_app/tasks/edit_task.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = []; // List to hold tasks
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks from the database
  }

  Future<void> _loadTasks() async {
    tasks = await dbHelper.getTasks(); // Assume getTasks fetches tasks from the database
    setState(() {}); // Refresh the UI
  }

  void _navigateToEditTask(Task task) {
    Navigator.pushNamed(context, '/editTask', arguments: task); // Navigate to edit task screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index].title),
            subtitle: Text(tasks[index].description),
            onTap: () => _navigateToEditTask(tasks[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to add a new task
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
