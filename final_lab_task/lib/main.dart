import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'sign_up.dart'; // Import SignUp page
import 'login.dart'; // Import Login page
import 'profile.dart'; // Import Profile page
import 'schedule_screen.dart'; // Import Schedule Screen
import 'splash_screen.dart'; // Import Splash Screen
import 'firebase_messaging_service.dart'; // Import Firebase Messaging Service
import 'assignment_screen.dart'; // Import Assignment Screen
import 'notification_service.dart';
import 'firebase_options.dart';
import 'StudyGroupFinder.dart'; // Import Study Group Finder screen
import 'FeedbackSystem.dart'; // Import Feedback System screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Show splash screen and initialize Firebase
  try {
    await Firebase.initializeApp();
    await FirebaseMessagingService().initialize();
    await NotificationService().initialize();
  } catch (e) {
    print("Error during initialization: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Life Assistant',
      initialRoute: '/splash',  // Set the initial route to SplashScreen
      routes: {
        '/splash': (context) => SplashScreen(),  // Route for SplashScreen
        '/signUp': (context) => CreateAccountPage(),  // Route for SignUp Screen
        '/login': (context) => LoginPage(),  // Route for Login Screen
        '/profile': (context) => ProfileScreen(),  // Route for Profile Screen
        '/schedule': (context) => ScheduleScreen(),  // Route for Schedule Screen
        '/assignments': (context) => AssignmentScreen(),  // Route for Assignment Screen
        '/studyGroup': (context) => StudyGroupFinder(), // Route for Study Group Finder
        '/feedback': (context) => FeedbackSystem(),  // Route for Feedback System
        // You can add more routes here for other parts of your app
      },
    );
  }
}
