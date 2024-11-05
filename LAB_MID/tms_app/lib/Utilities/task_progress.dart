import 'package:flutter/material.dart';

class Task {
  final String title;
  final List<Subtask> subtasks;

  Task({required this.title, required this.subtasks});

  int get completedSubtasks => subtasks.where((subtask) => subtask.isCompleted).length;

  double get progress => subtasks.isEmpty ? 0 : completedSubtasks / subtasks.length;
}

class Subtask {
  final String title;
  bool isCompleted;

  Subtask({required this.title, this.isCompleted = false});
}

class TaskProgress extends StatelessWidget {
  final Task task;

  TaskProgress({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Progress: ${task.completedSubtasks} / ${task.subtasks.length}'),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: task.progress,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: task.subtasks.map((subtask) {
                return CheckboxListTile(
                  title: Text(subtask.title),
                  value: subtask.isCompleted,
                  onChanged: (bool? value) {
                    subtask.isCompleted = value ?? false; // Update subtask completion status
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
