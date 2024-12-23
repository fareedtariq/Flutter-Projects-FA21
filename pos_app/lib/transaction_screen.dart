import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text(
          'No transactions available.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
