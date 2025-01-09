import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import Firebase Auth
import 'profile_setup.dart';  // Import ProfileSetupPage (ensure this is the correct path for your Profile Setup page)

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isAgree = false; // To track the state of terms and conditions checkbox
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to handle account creation
  Future<void> _createAccount() async {
    try {
      // Check if the checkbox is checked
      if (!_isAgree) {
        // Show an error if terms and conditions are not agreed to
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You must agree to the Terms of service & privacy policy.'),
        ));
        return;
      }

      // Create a new user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to ProfileSetupPage if successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileSetupPage()),
      );
    } catch (e) {
      // Handle error (e.g., email already in use, weak password)
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
        title: Text('Let\'s get started!'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading text
            Text(
              'Please enter your valid data in order to create an account.',
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
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),

            // Password text field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20),

            // Terms and conditions checkbox
            Row(
              children: [
                Checkbox(
                  value: _isAgree,
                  onChanged: (value) {
                    setState(() {
                      _isAgree = value!;
                    });
                  },
                ),
                Text('I agree with the '),
                Text(
                  'Terms of service & privacy policy.',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
            Spacer(),  // Push the button to the bottom

            // Continue button
            ElevatedButton(
              onPressed: _createAccount,  // Call the create account function
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Continue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Login link for users who already have an account
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  // Navigate to LoginPage
                  Navigator.pop(context);
                },
                child: Text(
                  "Already have an account? Log in",
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
