import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'schedule_manager.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final ScheduleManager _scheduleManager = ScheduleManager();
  List<Map<String, dynamic>> _schedules = [];

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  // Fetch schedules from Firestore or local storage
  _fetchSchedules() async {
    List<Map<String, dynamic>> schedules = await _scheduleManager.getSchedules();
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
                  _scheduleManager.updateSchedule(schedule['id'].toString(), {
                    'name': _nameController.text,
                    'date': _dateController.text,
                    'time': _timeController.text,
                  });
                } else {
                  _scheduleManager.addSchedule({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Class Schedule')),
      body: ListView.builder(
        itemCount: _schedules.length,
        itemBuilder: (context, index) {
          var schedule = _schedules[index];
          return ListTile(
            title: Text(schedule['name']),
            subtitle: Text('Date: ${schedule['date']} Time: ${schedule['time']}'),
            onTap: () => _showScheduleDialog(schedule: schedule),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await _scheduleManager.deleteSchedule(schedule['id'], schedule['firestoreId']);
                _fetchSchedules();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showScheduleDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
