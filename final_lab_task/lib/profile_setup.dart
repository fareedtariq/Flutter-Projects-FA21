import 'package:flutter/material.dart';
import 'schedule_screen.dart'; // Import ScheduleScreen
import 'package:image_picker/image_picker.dart';  // Import image_picker package
import 'dart:io';  // To handle file images

class ProfileSetupPage extends StatefulWidget {
  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  File? _image; // Variable to store selected image

  // Function to pick an image from the gallery or take a photo
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    // Pick image from gallery or camera
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);  // You can change to `ImageSource.camera` for the camera

    if (image != null) {
      setState(() {
        _image = File(image.path); // Save the selected image to the variable
      });
    }
  }

  // Function to navigate to Home Screen
  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ScheduleScreen()), // Navigate to HomeScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Setup', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {
              // Show information or guide about the profile setup
            },
          ),
        ],
      ),
      body: SingleChildScrollView( // Allows scrolling for small screens
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image upload section
            Center(
              child: GestureDetector(
                onTap: _pickImage, // Call the pick image function when tapped
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60, // Avatar size
                      backgroundColor: Colors.orangeAccent,
                      backgroundImage: _image != null
                          ? FileImage(_image!)  // Display selected image
                          : null,
                      child: _image == null
                          ? Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.white,
                      )
                          : null,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tap to Upload Image',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Full Name Text Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.person, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Date of Birth Text Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.calendar_today, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Phone Number Text Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.phone, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Buttons
            Row(
              children: [
                // Skip button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Skip the profile setup and move to home or dashboard
                      _navigateToHome(); // Navigate to HomeScreen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Color of the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Sign Up button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Complete the sign-up process and navigate to HomeScreen
                      _navigateToHome(); // Navigate to HomeScreen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Color of the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
