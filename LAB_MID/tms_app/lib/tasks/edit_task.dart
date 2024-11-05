import 'package:flutter/material.dart';
import 'package:tms_app/models/task_model.dart';
import 'package:tms_app/services/database_helper.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate; // Nullable due date

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dueDate = widget.task.dueDate; // Using existing due date
  }

  void _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      Task updatedTask = Task(
        id: widget.task.id,
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate ?? DateTime.now(),
        isCompleted: widget.task.isCompleted,
        isRepeated: widget.task.isRepeated,
        // repeatInterval: widget.task.repeatInterval, // Remove or modify this line based on your design
      );
      await DatabaseHelper().updateTask(updatedTask);
      Navigator.pop(context, true);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Task')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  return value == null || value.isEmpty ? 'Please enter a title' : null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  return value == null || value.isEmpty ? 'Please enter a description' : null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Due Date: ${_dueDate != null ? _dueDate!.toLocal().toString().split(' ')[0] : 'Not set'}",
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDueDate(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
