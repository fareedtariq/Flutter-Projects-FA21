import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row for Add Task and View Task buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your action for adding a task here
                    },
                    child: Text('Add Task'),
                  ),
                ),
                SizedBox(width: 8), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your action for viewing tasks here
                    },
                    child: Text('View Task'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Space between rows
            // Row for Completed Task and Repeated Task buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your action for viewing completed tasks here
                    },
                    child: Text('Completed Task'),
                  ),
                ),
                SizedBox(width: 8), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your action for viewing repeated tasks here
                    },
                    child: Text('Repeated Task'),
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
