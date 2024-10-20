import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CoinFlipApp());
}

class CoinFlipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Flip Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CoinFlipScreen(players: _controllers.map((controller) => controller.text).toList())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Flip Game'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.redAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (int i = 0; i < 4; i++)
              TextField(
                controller: _controllers[i],
                decoration: InputDecoration(
                  labelText: 'Player ${i + 1} Name',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: _startGame,
              child: Text('Start Game', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

class CoinFlipScreen extends StatefulWidget {
  final List<String> players;

  CoinFlipScreen({required this.players});

  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen> {
  int _currentPlayer = 0;
  String _result = '';
  String _coinImage = 'assets/images/head.png'; // Default image
  bool _isFlipping = false;

  void _flipCoin() {
    if (_currentPlayer < widget.players.length && !_isFlipping) {
      setState(() {
        _isFlipping = true;
        _result = '';
        _coinImage = 'assets/images/coin_flipping.gif'; // Change to a coin flipping animation
      });

      Future.delayed(Duration(seconds: 2), () {
        final bool isHeads = Random().nextBool();
        final outcome = isHeads ? 'Heads' : 'Tails';
        setState(() {
          _result = '${widget.players[_currentPlayer]} flipped: $outcome';
          _coinImage = isHeads ? 'assets/images/head.png' : 'assets/images/tail.png'; // Set the image based on result
          _currentPlayer++;
          _isFlipping = false;
        });
      });
    } else {
      // After all players have flipped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WinnerScreen(winner: widget.players[Random().nextInt(widget.players.length)])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Coin Flip')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/coin_background.png'), // Use a background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(_coinImage, width: 100, height: 100), // Display the coin image
              SizedBox(height: 20),
              Text(_result, style: TextStyle(fontSize: 24, color: Colors.white)),
              SizedBox(height: 20),
              FloatingActionButton(
                onPressed: _flipCoin,
                child: Icon(Icons.attach_money),
                backgroundColor: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WinnerScreen extends StatefulWidget {
  final String winner;

  WinnerScreen({required this.winner});

  @override
  _WinnerScreenState createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Winner')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Text(
              '${widget.winner} is the winner!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
