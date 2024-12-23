import 'package:flutter/material.dart';
import 'login_page.dart';  // Import LoginPage screen

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Circle to highlight the notification part
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/notification.png'), // Example image from assets
                  Positioned(
                    left: 60,
                    top: 30,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.pink.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text for the explanation
            Text(
              'Notify latest offers & product availability',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Be Notified.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // Switch for enabling/disabling notifications
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Notifications'),
                Switch(
                  value: _isNotificationEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _isNotificationEnabled = value;
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            // Next button at the bottom
            ElevatedButton(
              onPressed: () {
                // Navigate to the LoginPage using named route
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Button color (same as splash screen)
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Optional: for rounded corners
                ),
              ),
              child: Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )

          ],
        ),
      ),
    );
  }
}
