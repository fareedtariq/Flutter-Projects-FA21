import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulate initialization tasks (like Firebase init)
    Future.delayed(Duration(seconds: 3), () {
      // Automatically navigate to the next screen (Login) after a delay
      Navigator.pushReplacementNamed(context, '/login');  // Navigate to the login screen after delay
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Centers vertically
          crossAxisAlignment: CrossAxisAlignment.center,  // Centers horizontally
          children: [
            // Image centered
            Container(
              height: 250,  // Set the height of the image container
              width: double.infinity,  // Full width
              child: Center(
                child: Image.asset('assets/splash_logo.png'), // Your image file
              ),
            ),
            SizedBox(height: 20),

            // Welcome text
            Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to Flutter POS app',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 40), // Space between text and next element

            // No "Continue" button, automatic transition after the delay
          ],
        ),
      ),
    );
  }
}
