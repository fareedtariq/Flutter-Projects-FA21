import 'package:flutter/material.dart';
import 'package:weather_app/weather_provider.dart';
import 'home_screen.dart'; // Your main screen
 // Make sure this import is correct

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulating a splash screen delay
    Future.delayed(const Duration(seconds: 3), () {
      // After delay, navigate to the HomeScreen (Main Screen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // App logo (you can replace this with your actual logo)
            Icon(
              Icons.cloud,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              "Weather App",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
