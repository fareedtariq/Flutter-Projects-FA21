import 'package:flutter/material.dart';

class TodayTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Today\'s Tasks')),
      body: Center(child: Text('List of today\'s tasks here')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add task navigation
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
