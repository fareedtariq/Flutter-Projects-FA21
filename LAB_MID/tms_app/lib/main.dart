import 'package:flutter/material.dart';
import 'screens/today_tasks.dart';
import 'screens/completed_task.dart';
import 'screens/repeated_tasks.dart';
import 'tasks/add_task.dart';
import 'screens/theme_manager.dart';
import 'services/database_helper.dart';
import 'Utilities/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotifications();
  runApp(TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management App',
      theme: ThemeManager.lightTheme,  // Light theme
      darkTheme: ThemeManager.darkTheme, // Dark theme
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),  // Home screen with tabs
        '/addTask': (context) => TaskAddScreen(), // Add task screen
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    TodayTaskScreen(),
    CompletedTaskScreen(),
    RepeatedTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings for theme or notification customization
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.repeat), label: 'Repeated'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addTask'); // Navigates to Add Task screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
