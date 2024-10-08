import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(CoinFlipApp());
}

class CoinFlipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coin Flip Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CoinFlipScreen(),
    );
  }
}

class CoinFlipScreen extends StatefulWidget {
  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen>
    with SingleTickerProviderStateMixin {
  final List<String> players = ['Player 1', 'Player 2', 'Player 3', 'Player 4'];
  final List<String> options = ['Heads', 'Tails'];
  final List<String?> playerGuesses = [null, null, null, null];
  final List<int> playerScores = [0, 0, 0, 0];
  String coinResult = '';
  bool isFlipping = false;
  bool showWinner = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipCoin() {
    setState(() {
      isFlipping = true;
      showWinner = false; // Hide winner message before flipping
      _controller.forward(from: 0);
    });

    Future.delayed(Duration(seconds: 1), () {
      String result = options[Random().nextInt(2)];
      setState(() {
        coinResult = result;
        isFlipping = false;

        // Update player scores based on their guesses
        for (int i = 0; i < players.length; i++) {
          if (playerGuesses[i] == coinResult) {
            playerScores[i]++;
          }
        }

        // Show winner message
        showWinner = true;
      });
    });
  }

  void resetGame() {
    setState(() {
      playerScores.fillRange(0, players.length, 0);
      playerGuesses.fillRange(0, players.length, null);
      coinResult = '';
      showWinner = false; // Reset winner display
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Coin Flip Game')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Player UI in a Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(players.length, (i) {
              return Column(
                children: [
                  Text(players[i], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: options.map((option) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          onPressed: coinResult.isNotEmpty ? null : () {
                            setState(() {
                              playerGuesses[i] = option; // Update player's guess
                            });
                          },
                          child: Text(option),
                        ),
                      );
                    }).toList(),
                  ),
                  Text('Score: ${playerScores[i]}', style: TextStyle(fontSize: 18)),
                ],
              );
            }),
          ),
          SizedBox(height: 20), // Space between players and coin
          // Coin Animation
          Center(
            child: isFlipping
                ? RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: Image.asset(
                'images/coin.png', // Use your coin image path
                width: 100,
                height: 100,
              ),
            )
                : Text(
              coinResult.isEmpty ? 'Make your guesses!' : 'Coin Result: $coinResult',
              style: TextStyle(fontSize: 24),
            ),
          ),
          // Display the winner if applicable
          if (showWinner) ...[
            SizedBox(height: 20), // Space before showing the winner
            Container(
              color: Colors.green,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Winner(s): ${playerGuesses.asMap().entries.where((entry) => entry.value == coinResult).map((entry) => players[entry.key]).join(', ')}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10), // Space between winner text and button
                  ElevatedButton(
                    onPressed: resetGame,
                    child: Text('Restart Game'),
                  ),
                ],
              ),
            ),
          ],
          // Flip Coin Button
          SizedBox(height: 20), // Space before the button
          // Only show the Flip Coin button if no winner is displayed
          if (!showWinner)
            ElevatedButton(
              onPressed: isFlipping ? null : flipCoin,
              child: Text('Flip Coin'),
            ),
        ],
      ),
    );
  }
}
