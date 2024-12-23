import 'package:flutter/material.dart';
import 'notification_screen.dart';  // Import NotificationScreen

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 40), // Space between text and button

            // Continue button
            ElevatedButton(
              onPressed: () {
                // Navigate to Notification Screen
                Navigator.pushReplacementNamed(context, '/notification');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,  // Button color
                minimumSize: Size(double.infinity, 50),  // Full width button
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
