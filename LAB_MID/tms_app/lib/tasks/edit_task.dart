import 'package:flutter/material.dart';
import 'package:tms_app/Models/task_model.dart'; // Ensure Task model is imported
import 'package:tms_app/database_helper.dart'; // Ensure DatabaseHelper is imported

class EditTaskScreen extends StatefulWidget {
  final int taskId;
  final String initialTitle;
  final String initialDescription;
  final DateTime? initialDueDate;
  final bool initialIsRepeating;

  EditTaskScreen({
    required this.taskId,
    required this.initialTitle,
    required this.initialDescription,
    this.initialDueDate,
    this.initialIsRepeating = false,
  });

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
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
      dueDate: _dueDate?.toIso8601String() ?? '', // Convert DateTime to String
      repeatInterval: _isRepeating ? 'daily' : 'none', // Set repeat interval
      isCompleted: 0, // Assuming task is not completed by default
      progress: 0.0, // Initial progress set to 0
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
