import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudyGroupFinder extends StatefulWidget {
  @override
  _StudyGroupFinderState createState() => _StudyGroupFinderState();
}

class _StudyGroupFinderState extends State<StudyGroupFinder> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _groupNameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser; // Get current logged-in user
  }

  // Function to create a new study group
  Future<void> createStudyGroup() async {
    String groupName = _groupNameController.text.trim();

    if (groupName.isNotEmpty && _currentUser != null) {
      // Add new group to Firestore
      await _firestore.collection('study_groups').add({
        'group_name': groupName,
        'members': [_currentUser!.uid],  // Add current user as the first member
        'created_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Study group created successfully!"),
      ));
      _groupNameController.clear();  // Clear the group name text field
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(groupName.isEmpty ? "Please enter a group name!" : "User not logged in!"),
      ));
    }
  }

  // Function to join an existing study group
  Future<void> joinStudyGroup(String groupId) async {
    if (_currentUser != null) {
      // Add the current user to the group in Firestore
      await _firestore.collection('study_groups').doc(groupId).update({
        'members': FieldValue.arrayUnion([_currentUser!.uid]),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Joined study group successfully!"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please log in to join a group!"),
      ));
    }
  }

  // Function to leave a study group
  Future<void> leaveStudyGroup(String groupId) async {
    if (_currentUser != null) {
      // Remove the current user from the group in Firestore
      await _firestore.collection('study_groups').doc(groupId).update({
        'members': FieldValue.arrayRemove([_currentUser!.uid]),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Left study group successfully!"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please log in to leave a group!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Study Group Finder"),
        backgroundColor: Colors.blue, // Blue AppBar
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Group Name Input
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                hintText: 'Enter the name of the study group',
                labelStyle: TextStyle(color: Colors.blue),
                filled: true,
                fillColor: Colors.blue[50], // Light blue background for text field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              ),
            ),
            SizedBox(height: 20),

            // Create Group Button
            ElevatedButton(
              onPressed: createStudyGroup,
              child: Text('Create Study Group'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Blue button
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20),

            // List of Study Groups
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('study_groups').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var groups = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      var group = groups[index];
                      bool isMember = group['members'].contains(_currentUser?.uid);
                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          title: Text(
                            group['group_name'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text('Members: ${group['members'].length}'),
                          trailing: isMember
                              ? IconButton(
                            icon: Icon(Icons.exit_to_app, color: Colors.blue),
                            onPressed: () => leaveStudyGroup(group.id),
                          )
                              : IconButton(
                            icon: Icon(Icons.group_add, color: Colors.blue),
                            onPressed: () => joinStudyGroup(group.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
