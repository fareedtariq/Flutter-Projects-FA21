import 'package:flutter/material.dart';
import 'package:tms_app/models/task_model.dart';
import 'package:tms_app/services/database_helper.dart';

class CompletedTasksScreen extends StatefulWidget {
  @override
  _CompletedTasksScreenState createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  List<Task> completedTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchCompletedTasks();
  }

  Future<void> _fetchCompletedTasks() async {
    final tasks = await DatabaseHelper().getCompletedTasks();
    setState(() {
      completedTasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completed Tasks')),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return ListTile(
            title: Text(task.title, style: TextStyle(decoration: TextDecoration.lineThrough)),
            subtitle: Text(task.description),
          );
        },
      ),
    );
  }
}
