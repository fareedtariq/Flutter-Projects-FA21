import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? _user;
  String _name = '';
  String _phone = '';
  String _email = '';

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      _nameController.text = _user!.displayName ?? '';
      _emailController.text = _user!.email ?? '';
      _phoneController.text = _user!.phoneNumber ?? '';
    }
  }

  Future<void> _updateProfile() async {
    try {
      if (_user != null) {
        // Update display name
        await _user!.updateDisplayName(_nameController.text);

        // Update email
        if (_emailController.text != _user!.email) {
          await _user!.updateEmail(_emailController.text);
        }

        // Update phone number
        // You will need to handle phone number verification in a more secure way
        await _user!.updatePhoneNumber(PhoneAuthProvider.credential(
            verificationId: '',smsCode: '')); // Update this line

        // Store profile data in Firestore
        await _firestore.collection('users').doc(_user!.uid).set({
          'name': _nameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
        }, SetOptions(merge: true));

        setState(() {});
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_user != null)
              Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: Text('Update Profile'),
                  ),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: Text('Sign Out'),
                  ),
                ],
              )
            else
              Center(child: Text('No user signed in')),
          ],
        ),
      ),
    );
  }
}
