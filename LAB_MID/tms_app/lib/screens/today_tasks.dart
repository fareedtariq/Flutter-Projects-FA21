import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tms_app/services/database_helper.dart';
import 'package:tms_app/Models/task_model.dart';
import 'package:tms_app/tasks//add_task.dart';

class TodayTaskScreen extends StatefulWidget {
  @override
  _TodayTaskScreenState createState() => _TodayTaskScreenState();
}

class _TodayTaskScreenState extends State<TodayTaskScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<Task> _todayTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTodayTasks();
  }

  // Load tasks due today
  Future<void> _loadTodayTasks() async {
    final allTasks = await dbHelper.fetchTasks();
    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    setState(() {
      _todayTasks = allTasks.where((task) => task.dueDate == todayDate).toList();
    });
  }

  // Function to add a new task
  void _addNewTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskAddScreen()),
    );
    if (result == true) {
      _loadTodayTasks();
    }
  }

  // Function to mark task as completed
  void _markTaskAsCompleted(Task task) async {
    task.isCompleted = true;
    await dbHelper.updateTask(task);
    _loadTodayTasks();
  }

  // Function to delete a task
  void _deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    _loadTodayTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Tasks"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewTask,
          ),
        ],
      ),
      body: _todayTasks.isEmpty
          ? Center(child: Text("No tasks for today"))
          : ListView.builder(
        itemCount: _todayTasks.length,
        itemBuilder: (context, index) {
          final task = _todayTasks[index];
          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(task.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!task.isCompleted)
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () => _markTaskAsCompleted(task),
                  ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(task.id!),
                ),
              ],
            ),
            onTap: () {
              // You may want to add a detail screen or edit functionality here
            },
          );
        },
      ),
    );
  }
}
