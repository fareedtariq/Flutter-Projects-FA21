import 'package:flutter/material.dart';
import 'home_page.dart'; // Import HomeScreen
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
      MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to HomeScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {
              // Show information or guide about the profile setup
            },
          )
        ],
      ),
      body: Padding(
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
                      radius: 50, // Avatar size
                      backgroundColor: Colors.grey[300],
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
                      'Upload Image',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Full Name Text Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Date of Birth Text Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Date of birth',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Phone Number Text Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(), // Push buttons to the bottom

            // Buttons
            Row(
              children: [
                // Skip button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Skip the profile setup and move to home or dashboard
                      print("Skip clicked");
                      // Navigate to HomeScreen (or any next screen)
                      _navigateToHome(); // Navigate to HomeScreen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      minimumSize: Size(double.infinity, 50),
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
                      print("Sign Up clicked");
                      _navigateToHome(); // Navigate to HomeScreen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Sign up',
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
