import 'package:flutter/material.dart';
import 'package:tms_app/services/database_helper.dart';
import 'package:tms_app/Models/task_model.dart';

class CompletedTaskScreen extends StatefulWidget {
  @override
  _CompletedTaskScreenState createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // Fetch completed tasks from the database
  Future<List<Task>> fetchCompletedTasks() async {
    final allTasks = await dbHelper.fetchTasks();
    return allTasks.where((task) => task.isCompleted).toList();
  }

  // Function to mark a task as incomplete
  Future<void> markAsIncomplete(Task task) async {
    task.isCompleted = false;
    await dbHelper.updateTask(task);
    setState(() {});
  }

  // Function to delete a task
  Future<void> deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: FutureBuilder<List<Task>>(
        future: fetchCompletedTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading tasks.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No completed tasks.'));
          }

          final completedTasks = snapshot.data!;
          return ListView.builder(
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final task = completedTasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.undo),
                      onPressed: () => markAsIncomplete(task),
                      tooltip: 'Mark as Incomplete',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        final confirmDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Task'),
                            content: Text('Are you sure you want to delete this task?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirmDelete == true) {
                          deleteTask(task.id!);
                        }
                      },
                      tooltip: 'Delete Task',
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
