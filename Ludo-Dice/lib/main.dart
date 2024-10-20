import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(DiceApp());

class DiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ludo Dice',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DiceScreen(),
    );
  }
}

class DiceScreen extends StatefulWidget {
  @override
  _DiceScreenState createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> with TickerProviderStateMixin {
  int _diceNumber1 = 0;
  int _diceNumber2 = 0;
  int _diceNumber3 = 0;
  int _diceNumber4 = 0;

  bool _isRolling1 = false;
  bool _isRolling2 = false;
  bool _isRolling3 = false;
  bool _isRolling4 = false;

  final Duration _animationDuration = Duration(milliseconds: 500);

  void _rollDice1() {
    setState(() {
      _isRolling1 = true;
      _diceNumber1 = Random().nextInt(6) + 1;
    });
    _resetAnimation(1);
  }

  void _rollDice2() {
    setState(() {
      _isRolling2 = true;
      _diceNumber2 = Random().nextInt(6) + 1;
    });
    _resetAnimation(2);
  }

  void _rollDice3() {
    setState(() {
      _isRolling3 = true;
      _diceNumber3 = Random().nextInt(6) + 1;
    });
    _resetAnimation(3);
  }

  void _rollDice4() {
    setState(() {
      _isRolling4 = true;
      _diceNumber4 = Random().nextInt(6) + 1;
    });
    _resetAnimation(4);
  }

  void _resetAnimation(int diceNumber) {
    Future.delayed(_animationDuration, () {
      setState(() {
        if (diceNumber == 1) _isRolling1 = false;
        if (diceNumber == 2) _isRolling2 = false;
        if (diceNumber == 3) _isRolling3 = false;
        if (diceNumber == 4) _isRolling4 = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ludo Dice',
          style: TextStyle(fontFamily: 'Cursive', fontSize: 28),
        ),
        backgroundColor: Colors.redAccent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDiceColumn(
                  'Rolling Number: $_diceNumber1',
                  'images/dice-$_diceNumber1.png',
                  _isRolling1,
                  _rollDice1,
                  screenWidth / 2 - 40, // Dynamically size the dice
                ),
                SizedBox(width: screenWidth * 0.1),
                _buildDiceColumn(
                  'Rolling Number: $_diceNumber2',
                  'images/dice-$_diceNumber2.png',
                  _isRolling2,
                  _rollDice2,
                  screenWidth / 2 - 40,
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDiceColumn(
                  'Rolling Number: $_diceNumber3',
                  'images/dice-$_diceNumber3.png',
                  _isRolling3,
                  _rollDice3,
                  screenWidth / 2 - 40,
                ),
                SizedBox(width: screenWidth * 0.1),
                _buildDiceColumn(
                  'Rolling Number: $_diceNumber4',
                  'images/dice-$_diceNumber4.png',
                  _isRolling4,
                  _rollDice4,
                  screenWidth / 2 - 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiceColumn(String text, String imagePath, bool isRolling, VoidCallback onPressed, double imageSize) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        AnimatedOpacity(
          opacity: isRolling ? 1.0 : 0.8, // Change opacity during rolling
          duration: _animationDuration,
          child: AnimatedScale(
            scale: isRolling ? 1.5 : 1.0, // Pop-up effect with scale
            duration: _animationDuration,
            child: Image.asset(
              imagePath,
              height: imageSize,
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(
            'Roll the Dice',
            style: TextStyle(fontSize: 16, fontFamily: 'Cursive'),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Background color
            disabledBackgroundColor: Colors.white, // Text color
            shadowColor: Colors.greenAccent, // Shadow color
          ),
        ),
      ],
    );
  }
}
