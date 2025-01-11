import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'schedule_manager.dart'; // Import ScheduleManager
import 'profile.dart'; // Import ProfileScreen
import 'firestore_service.dart'; // Import FirestoreService
import 'assignment_screen.dart'; // Import AssignmentScreen
import 'StudyGroupFinder.dart'; // Import Study Group Finder
import 'FeedbackSystem.dart'; // Import Feedback System

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final ScheduleManager _scheduleManager = ScheduleManager();
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _schedules = [];

  int _selectedIndex = 0; // Track the selected index for BottomNavigationBar

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  // Fetch schedules from Firestore or local storage
  _fetchSchedules() async {
    List<Map<String, dynamic>> schedules = await _scheduleManager.getSchedules();
    if (schedules.isEmpty) {
      schedules = await _firestoreService.getSchedules();  // Fetch from Firestore if local DB is empty
    }
    setState(() {
      _schedules = schedules;
    });
  }

  // Show date picker to choose date
  Future<void> _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];  // Format as yyyy-mm-dd
      });
    }
  }

  // Show time picker to choose time
  Future<void> _selectTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _timeController.text = selectedTime.format(context);  // Format as hh:mm AM/PM
      });
    }
  }

  // Show dialog to add or update schedule
  _showScheduleDialog({Map<String, dynamic>? schedule}) {
    if (schedule != null) {
      _nameController.text = schedule['name'];
      _dateController.text = schedule['date'];
      _timeController.text = schedule['time'];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(schedule != null ? 'Edit Schedule' : 'Add Schedule'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Class Name'),
                ),
                GestureDetector(
                  onTap: _selectDate, // Show date picker on tap
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(labelText: 'Date'),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _selectTime, // Show time picker on tap
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _timeController,
                      decoration: InputDecoration(labelText: 'Time'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (schedule != null) {
                  _firestoreService.updateSchedule(schedule['id'], {
                    'name': _nameController.text,
                    'date': _dateController.text,
                    'time': _timeController.text,
                  });
                } else {
                  _firestoreService.addSchedule({
                    'name': _nameController.text,
                    'date': _dateController.text,
                    'time': _timeController.text,
                  });
                }
                _nameController.clear();
                _dateController.clear();
                _timeController.clear();
                Navigator.pop(context);
                _fetchSchedules();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Delete a schedule
  Future<void> _deleteSchedule(int scheduleId, String firestoreId) async {
    try {
      await _scheduleManager.deleteSchedule(scheduleId);
      await _firestoreService.deleteSchedule(firestoreId);
      _fetchSchedules();  // Refresh the schedule list after deletion
    } catch (e) {
      print("Error deleting schedule: $e");
    }
  }

  // Navigate to Profile screen
  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()), // Profile Screen navigation
    );
  }

  // Navigate to Assignment screen
  void _navigateToAssignments() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AssignmentScreen()), // Assignment Screen navigation
    );
  }

  // Navigate to Study Group screen
  void _navigateToStudyGroup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudyGroupFinder()), // Study Group Finder navigation
    );
  }

  // Navigate to Feedback screen
  void _navigateToFeedback() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedbackSystem()), // Feedback System navigation
    );
  }

  // Handle BottomNavigationBar item taps
  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        break; // Stay on the current page (ScheduleScreen)
      case 1:
        _navigateToAssignments(); // Navigate to Assignment Screen
        break;
      case 2:
        _navigateToProfile(); // Navigate to Profile Screen
        break;
      case 3:
        _navigateToStudyGroup(); // Navigate to Study Group Finder Screen
        break;
      case 4:
        _navigateToFeedback(); // Navigate to Feedback System Screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // AppBar Color
        elevation: 5, // Adding shadow
        title: Text(
          'Class Schedule',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _schedules.length,
        itemBuilder: (context, index) {
          var schedule = _schedules[index];
          return ListTile(
            title: Text(schedule['name']),
            subtitle: Text('Date: ${schedule['date']} Time: ${schedule['time']}'),
            onTap: () => _showScheduleDialog(schedule: schedule),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showScheduleDialog(schedule: schedule),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    bool confirmDelete = await _confirmDelete();
                    if (confirmDelete) {
                      await _deleteSchedule(schedule['id'] as int, schedule['firestoreId']);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showScheduleDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent, // Floating Action Button Color
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarItemTapped,
        selectedItemColor: Colors.blueAccent, // Active tab color
        unselectedItemColor: Colors.grey, // Inactive tab color
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Study Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
        ],
      ),
    );
  }

  // Confirm delete dialog
  Future<bool> _confirmDelete() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this schedule?'),
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
}
