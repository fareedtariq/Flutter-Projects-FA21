import 'package:firebase_auth/firebase_auth.dart';  // Import Firebase Auth
import 'package:flutter/material.dart';
import 'home_page.dart';  // Import HomeScreen
import 'create_account_page.dart';  // Import CreateAccountPage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  // Method to handle forgot password logic
  Future<void> _forgotPassword() async {
    try {
      String email = _emailController.text.trim();
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter your email address'),
        ));
        return;
      }

      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password reset email sent! Check your inbox.'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Welcome back!'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Text
            Text(
              'Log in with your data that you entered during your registration.',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(height: 30),

            // Email text field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),

            // Password text field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 10),

            // Forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _forgotPassword,  // Call the forgot password function
                child: Text(
                  'Forgot password',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            Spacer(),  // Push the button to the bottom

            // Log in button
            ElevatedButton(
              onPressed: () {
                // Navigate to HomePage after login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Log in',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Sign up link for users who don't have an account
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  // Navigate to Create Account screen (Sign Up)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccountPage()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
