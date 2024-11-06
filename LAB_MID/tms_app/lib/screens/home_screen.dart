import 'package:flutter/material.dart';
import 'today_tasks.dart';
import 'completed_task.dart';
import 'repeated_tasks.dart';
import 'package:tms_app/tasks/add_task.dart';
import 'package:tms_app/tasks/edit_task.dart';
import 'package:tms_app/services/database_helper.dart';
import 'package:tms_app/Models/task_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final taskList = await dbHelper.fetchTasks();
    setState(() {
      tasks = taskList;
    });
  }

  void _addTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTask()),
    );
    _fetchTasks(); // Refresh task list after adding
  }

  void _editTask(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskEditScreen(task: task)),
    );
    _fetchTasks(); // Refresh task list after editing
  }

  void _deleteTask(int taskId) async {
    await dbHelper.deleteTask(taskId);
    _fetchTasks(); // Refresh task list after deletion
  }

  void _markAsCompleted(Task task) async {
    task.isCompleted = true;
    await dbHelper.updateTask(task);
    _fetchTasks(); // Refresh task list after marking as completed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchTasks,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.today),
                  title: Text('Today\'s Tasks'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TodayTaskScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.check_circle),
                  title: Text('Completed Tasks'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CompletedTaskScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.repeat),
                  title: Text('Repeated Tasks'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RepeatedTaskScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Manage Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editTask(task),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(task.id!),
                          ),
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () => _markAsCompleted(task),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
