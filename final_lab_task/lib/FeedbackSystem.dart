import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackSystem extends StatefulWidget {
  @override
  _FeedbackSystemState createState() => _FeedbackSystemState();
}

class _FeedbackSystemState extends State<FeedbackSystem> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  // Function to submit feedback
  Future<void> submitFeedback(String category) async {
    String rating = _ratingController.text.trim();
    String comment = _commentController.text.trim();

    if (rating.isNotEmpty && comment.isNotEmpty) {
      await _firestore.collection('feedback').add({
        'category': category,
        'rating': int.tryParse(rating),
        'comment': comment,
        'submitted_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Feedback submitted successfully!"),
      ));

      // Reset the text fields after submission
      _ratingController.clear();
      _commentController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please fill out all fields!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback System"),
        backgroundColor: Colors.blue, // Blue color for AppBar
        elevation: 0,
      ),
      body: Container(
        color: Colors.blue[50], // Light blue background for the screen
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating Input
              Text(
                'Rate the Course/Service/Professor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _ratingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Rating (1 to 5)',
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
              ),
              SizedBox(height: 20),

              // Comment Input
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Comments',
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),

              // Buttons for submitting feedback
              ElevatedButton(
                onPressed: () => submitFeedback('Course'),
                child: Text('Submit Feedback for Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue color for buttons
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => submitFeedback('Professor'),
                child: Text('Submit Feedback for Professor'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue color for buttons
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => submitFeedback('Campus Service'),
                child: Text('Submit Feedback for Campus Service'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue color for buttons
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
