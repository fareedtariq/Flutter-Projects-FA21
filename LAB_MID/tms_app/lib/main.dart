import 'package:flutter/material.dart';
import 'package:tms_app/models/task_model.dart'; // Import your models
import 'package:tms_app/services/database_helper.dart'; // Import your database services
import 'package:tms_app/tasks/edit_task.dart'; // Import your screens
import 'package:tms_app/screens/home_screen.dart'; // Home screen or main screen of the app

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Set the initial screen
      routes: {
        '/editTask': (context) => EditTaskScreen(task: ModalRoute.of(context)!.settings.arguments as Task), // Route for editing a task
        // Add other routes here
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
