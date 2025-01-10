import 'package:flutter/material.dart';
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

    // Update the state with the fetched assignments
    _assignments = firestoreAssignments;
    setState(() {});
  }

  // Show dialog to add or update an assignment
  Future<void> _showAssignmentDialog({Assignment? assignment}) async {
    if (assignment != null) {
      _titleController.text = assignment.title;
      _deadlineController.text = assignment.deadline.toIso8601String();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(assignment != null ? 'Edit Assignment' : 'Add Assignment'),
          content: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Assignment Title'),
              ),
              TextField(
                controller: _deadlineController,
                decoration: InputDecoration(labelText: 'Deadline (yyyy-mm-dd hh:mm)'),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final title = _titleController.text;
                final deadline = DateTime.parse(_deadlineController.text);

                Assignment newAssignment = Assignment(
                  id: assignment?.id ?? DateTime.now().toString(),  // Generate new id if not editing
                  title: title,
                  deadline: deadline,
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

                _titleController.clear();
                _deadlineController.clear();
                Navigator.pop(context);
                _syncAssignments(); // Refresh the list of assignments
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
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
          return ListTile(
            title: Text(assignment.title),
            subtitle: Text('Due: ${assignment.deadline}'),
            onTap: () => _notificationService.showDeadlineReminder(assignment),
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
