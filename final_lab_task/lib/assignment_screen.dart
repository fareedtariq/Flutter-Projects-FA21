import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart'; // For formatting date/time
import 'firestore_service.dart';
import 'schedule_database.dart';
import 'notification_service.dart';
import 'assignment.dart';

class AssignmentScreen extends StatefulWidget {
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final ScheduleDatabase _localStorageService = ScheduleDatabase();
  final NotificationService _notificationService = NotificationService();

  List<Assignment> _assignments = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  String? _filePath; // To store file path for attached document

  @override
  void initState() {
    super.initState();
    _syncAssignments();
  }

  // Sync assignments from Firestore to local database
  Future<void> _syncAssignments() async {
    // Fetch assignments from Firestore
    List<Assignment> firestoreAssignments = await _firestoreService.getAssignments();

    // Store them locally
    for (var assignment in firestoreAssignments) {
      await _localStorageService.saveAssignmentToLocal(assignment);
    }

    // Fetch assignments from local storage and update the state
    List<Assignment> localAssignments = await _localStorageService.getAssignmentsFromLocal();
    setState(() {
      _assignments = localAssignments;
    });
  }

  // Show dialog to add or update an assignment
  Future<void> _showAssignmentDialog({Assignment? assignment}) async {
    if (assignment != null) {
      _titleController.text = assignment.title;
      _deadlineController.text = DateFormat('yyyy-MM-dd HH:mm').format(assignment.deadline);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(assignment != null ? 'Edit Assignment' : 'Add Assignment'),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Assignment Title'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _deadlineController,
                    decoration: InputDecoration(
                      labelText: 'Deadline (yyyy-mm-dd hh:mm)',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDeadline(),
                      ),
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      // File picker for document attachment
                      FilePickerResult? result = await FilePicker.platform.pickFiles();
                      if (result != null) {
                        setState(() {
                          _filePath = result.files.single.path;
                        });
                      }
                    },
                    child: Text('Attach Document'),
                  ),
                  if (_filePath != null) ...[
                    SizedBox(height: 10),
                    Text('Attached File: $_filePath'),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final title = _titleController.text;
                final deadline = DateFormat('yyyy-MM-dd HH:mm').parse(_deadlineController.text);

                Assignment newAssignment = Assignment(
                  id: assignment?.id ?? DateTime.now().toString(),
                  title: title,
                  deadline: deadline,
                  filePath: _filePath, // Add file path
                );

                if (assignment != null) {
                  // Update existing assignment
                  await _firestoreService.updateAssignment(assignment.id, newAssignment);
                  await _localStorageService.updateAssignment(newAssignment);
                } else {
                  // Add new assignment
                  await _firestoreService.addAssignment(newAssignment);
                  await _localStorageService.saveAssignmentToLocal(newAssignment);
                }

                _notificationService.showDeadlineReminder(newAssignment);

                // Clear fields and reset file path
                _titleController.clear();
                _deadlineController.clear();
                _filePath = null;

                // Close dialog and refresh assignments
                Navigator.pop(context);
                _syncAssignments(); // Refresh the list of assignments
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Show date and time picker for deadline
  Future<void> _selectDeadline() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(pickedDate),
      );
      if (pickedTime != null) {
        setState(() {
          _deadlineController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              ));
        });
      }
    }
  }

  // Delete an assignment
  Future<void> _deleteAssignment(Assignment assignment) async {
    bool confirmDelete = await _confirmDelete();
    if (confirmDelete) {
      await _firestoreService.deleteAssignment(assignment.id);
      await _localStorageService.deleteAssignment(assignment.id);
      _syncAssignments(); // Refresh the list of assignments
    }
  }

  // Confirm delete dialog
  Future<bool> _confirmDelete() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this assignment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assignments')),
      body: ListView.builder(
        itemCount: _assignments.length,
        itemBuilder: (context, index) {
          Assignment assignment = _assignments[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(assignment.title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Due: ${DateFormat('yyyy-MM-dd HH:mm').format(assignment.deadline)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showAssignmentDialog(assignment: assignment),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteAssignment(assignment),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAssignmentDialog(), // Show dialog to add new assignment
        child: Icon(Icons.add),
      ),
    );
  }
}
