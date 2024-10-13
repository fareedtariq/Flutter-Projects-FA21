import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Home());
}
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // Remove debug banner
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Xylophone',
              style: TextStyle(color: Colors.black), // Text color set to black
            ),
            backgroundColor: Colors.grey, // Background color set to grey
            centerTitle: true, // Center the title
          ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                final musi = AudioPlayer();
                 musi.play(AssetSource('note1.wav'));
              },
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.pink),
                child: Center(child: Text('Play Note 1')),
              ),
            ),
            GestureDetector(
              onTap: () {
                final musi = AudioPlayer();
                musi.play(AssetSource('note2.wav'));
              },
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black),
                child: Center(child: Text('Play Note 2')),
              ),
            ),
            GestureDetector(
              onTap: () {
                final musi = AudioPlayer();
                musi.play(AssetSource('note3.wav'));
              },
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(child: Text('Play Note 3')),
              ),
            ),
            GestureDetector(
              onTap: () {
                final musi = AudioPlayer();
                musi.play(AssetSource('note4.wav'));
              },
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.orange),
                child: Center(child: Text('Play Note 4')),
              ),
            ),
            GestureDetector(
              onTap: () {
                final musi = AudioPlayer();
                musi.play(AssetSource('note5.wav'));
              },
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.amber),
                child: Center(child: Text('Play Note 5')),
              ),
            ),
            GestureDetector(
              onTap: () {
                final musi = AudioPlayer();
                musi.play(AssetSource('note6.wav'));
              },
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.yellow),
                child: Center(child: Text('Play Note 6')),
              ),
            ),
            GestureDetector(
              onTap: () {
                final musi = AudioPlayer();
                musi.play(AssetSource('note7.wav'));
              },
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.deepPurple ),
                child: Center(child: Text('Play Note 7')),
              ),
            ),// Add more GestureDetectors as needed...
          ],
        ),
      ),
    );
  }
}
