import 'package:flutter/material.dart';
import 'home_page.dart';      // Import HomeScreen
import 'products_screen.dart';  // Import ProductsScreen
import 'transaction_screen.dart'; // Import TransactionScreen
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Screen',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: AccountScreen(
        name: 'Fareed',
        email: 'fsfsffsf@gmail.com',
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
}

class AccountScreen extends StatefulWidget {
  final String name;
  final String email;
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  AccountScreen({
    required this.name,
    required this.email,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _currentIndex = 3;
  File? _profileImage;

  // Controllers for editable fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController(); // Phone number controller

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with existing data
    _nameController.text = widget.name;
    _emailController.text = widget.email;
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  // Save changes function
  void _saveChanges() {
    // You can implement the logic to save the changes (e.g., updating user profile in the backend)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Changes saved successfully!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.brightness_7 : Icons.brightness_4),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : AssetImage('assets/default_profile.png') as ImageProvider,
                child: _profileImage == null
                    ? Icon(Icons.camera_alt, color: Colors.black)
                    : null,
              ),
            ),
            SizedBox(height: 10),

            // Editable Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),

            // Editable Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 10),

            // Phone Number Text Field
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),

            // Save Changes Button
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _currentIndex, // Highlight the active tab
        selectedItemColor: Colors.orange,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab
            // Navigate to corresponding screen
            if (index == 0) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            } else if (index == 1) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductsScreen()));
            } else if (index == 2) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TransactionScreen()));
            } else if (index == 3) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountScreen(
                name: 'Fareed',
                email: 'fsfsffsf@gmail.com',
                toggleTheme: widget.toggleTheme,
                isDarkMode: widget.isDarkMode,
              )));
            }
          });
        },
      ),
    );
  }
}
