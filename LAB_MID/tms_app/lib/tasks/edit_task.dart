import 'package:flutter/material.dart';
import 'package:tms_app/Models/task_model.dart';
import 'package:tms_app/services/database_helper.dart';

class EditTask extends StatefulWidget {
  final int taskId;
  final String initialTitle;
  final String initialDescription;
  final DateTime? initialDueDate;
  final bool initialIsRepeating;

  EditTask({
    required this.taskId,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialDueDate,
    required this.initialIsRepeating,
  });

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final dbHelper = DatabaseHelper.instance;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;
  late bool _isRepeating;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _dueDate = widget.initialDueDate;
    _isRepeating = widget.initialIsRepeating;
  }

  Future<void> _updateTask() async {
    final updatedTask = Task(
      id: widget.taskId,
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDate,  // Keep as DateTime?
      repeat: _isRepeating ? 'daily' : 'none', // Assuming repeat is set to 'daily' or 'none'
    );

    await dbHelper.updateTask(updatedTask); // Update task in the database
    Navigator.of(context).pop(); // Close the Edit Task screen
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
      appBar: AppBar(title: Text('Edit Task')),
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
              child: Text('Update Task'),
              onPressed: _updateTask,
            ),
          ],
        ),
      ),
    );
  }
}
