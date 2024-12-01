import 'package:flutter/material.dart';

class EnableNotificationScreen extends StatelessWidget {
  const EnableNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enable Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.4,
              child: Image.asset(
                "assets/screens/Enable notification.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Stay updated!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Enable notifications to receive updates about offers, promotions, and important announcements.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: screenWidth * 0.6,
              child: ElevatedButton(
                onPressed: () {
                  // Add your enable notification logic here
                },
                child: const Text("Enable Notifications"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
