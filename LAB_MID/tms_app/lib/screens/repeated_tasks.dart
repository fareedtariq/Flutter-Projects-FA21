import 'package:flutter/material.dart';
import 'package:tms_app/models/task_model.dart';
import 'package:tms_app/services/database_helper.dart';


class RepeatedTasksScreen extends StatefulWidget {
  @override
  _RepeatedTasksScreenState createState() => _RepeatedTasksScreenState();
}

class _RepeatedTasksScreenState extends State<RepeatedTasksScreen> {
  List<Task> repeatedTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchRepeatedTasks();
  }

  Future<void> _fetchRepeatedTasks() async {
    final tasks = await DatabaseHelper().getRepeatedTasks();
    setState(() {
      repeatedTasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Repeated Tasks')),
      body: ListView.builder(
        itemCount: repeatedTasks.length,
        itemBuilder: (context, index) {
          final task = repeatedTasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: Text('Repeats: ${task.isRepeated ?? 'N/A'}'), // Handle null case
          );
        },
      ),
    );
  }
}
