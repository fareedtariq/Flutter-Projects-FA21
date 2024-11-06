import 'package:flutter/material.dart';
import 'package:tms_app/Models/task_model.dart';
import 'package:tms_app/services/database_helper.dart';
import 'package:intl/intl.dart';



class RepeatedTaskScreen extends StatefulWidget {
  @override
  _RepeatedTaskScreenState createState() => _RepeatedTaskScreenState();
}

class _RepeatedTaskScreenState extends State<RepeatedTaskScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<Task> repeatedTasks = [];

  @override
  void initState() {
    super.initState();
    fetchRepeatedTasks();
  }

  Future<void> fetchRepeatedTasks() async {
    // Fetch tasks from the database that have repetition settings enabled
    final tasks = await dbHelper.fetchTasks();
    setState(() {
      repeatedTasks = tasks.where((task) => task.repeat != 'none').toList();
    });
  }

  Future<void> markTaskAsCompleted(Task task) async {
    // Mark task as completed and update in database
    task.isCompleted = true;
    await dbHelper.updateTask(task);
    await fetchRepeatedTasks();
  }

  Future<void> resetRepeatedTasks() async {
    // Reset all completed tasks with repeat settings
    for (var task in repeatedTasks) {
      if (task.isCompleted && shouldResetTask(task)) {
        task.isCompleted = false;
        await dbHelper.updateTask(task);
      }
    }
    fetchRepeatedTasks();
  }

  bool shouldResetTask(Task task) {
    // Check if task needs to be reset based on its repeat settings
    final now = DateTime.now();
    switch (task.repeat) {
      case 'daily':
        return true; // Always reset daily tasks
      case 'weekly':
      // Reset weekly tasks if the day matches
        return now.weekday == DateTime.parse(task.dueDate).weekday;
    // Add more cases if needed, e.g., for custom days
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repeated Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: resetRepeatedTasks, // Reset repeated tasks on refresh
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: repeatedTasks.length,
        itemBuilder: (context, index) {
          final task = repeatedTasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('Repeats: ${task.repeat}'),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                if (value != null && value) {
                  markTaskAsCompleted(task);
                }
              },
            ),
          );
        },
      ),
    );
  }
}