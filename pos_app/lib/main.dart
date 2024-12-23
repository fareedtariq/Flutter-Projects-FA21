import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'splash_screen.dart';  // Import SplashScreen
import 'login_page.dart';  // Import LoginPage
import 'home_page.dart';  // Import HomeScreen
import 'create_account_page.dart';  // Import CreateAccountPage
import 'ProfileSetupPage.dart'; // Import ProfileSetupPage
import 'notification_screen.dart';  // Import NotificationScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter binding is initialized
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POS App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',  // Start with the splash screen
      routes: {
        '/': (context) => SplashScreen(),  // Splash Screen
        '/notification': (context) => NotificationScreen(), // Notification Screen
        '/login': (context) => LoginPage(),  // Login Page
        '/create-account': (context) => CreateAccountPage(), // Create Account Page
        '/profile-setup': (context) => ProfileSetupPage(), // Profile Setup Page
        '/home': (context) => HomeScreen(), // Home Page
      },
    );
  }
}
