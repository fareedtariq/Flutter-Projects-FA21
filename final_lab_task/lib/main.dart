import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'sign_up.dart';
import 'login.dart';
import 'profile.dart';
import 'schedule_screen.dart';  // Import ScheduleScreen
import 'splash_screen.dart';  // Import SplashScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

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
        '/splash': (context) => SplashScreen(),  // Added route for SplashScreen
        '/signUp': (context) => CreateAccountPage(),
        '/login': (context) => LoginPage(),
        '/profile': (context) => ProfileScreen(),
        '/schedule': (context) => ScheduleScreen(),  // Added route for ScheduleScreen
        // You can add more routes here, for example, for HomeScreen or other parts of your app
      },
    );
  }
}
