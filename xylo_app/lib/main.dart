import 'package:flutter/material.dart';
import 'package:xylo_app/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(XylophoneApp());
}

class XylophoneApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}