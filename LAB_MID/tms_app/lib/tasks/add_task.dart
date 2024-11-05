import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  bool _isRepeating = false; // Optional repeat settings

  void _submitTask() {
    if (_titleController.text.isEmpty) {
      return; // Show error message or validation
    }

    // You can implement your method to save the task
    // Example: saveTask(title, description, dueDate, isRepeating)

    Navigator.of(context).pop(); // Close the Add Task screen
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Row(
              children: [
                Text('Due Date: ${_dueDate?.toLocal().toString().split(' ')[0] ?? 'Not Set'}'),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDueDate(context),
                ),
              ],
            ),
            SwitchListTile(
              title: Text('Repeat Task'),
              value: _isRepeating,
              onChanged: (bool value) {
                setState(() {
                  _isRepeating = value;
                });
              },
            ),
            ElevatedButton(
              child: Text('Add Task'),
              onPressed: _submitTask,
            ),
          ],
        ),
      ),
    );
  }
}
