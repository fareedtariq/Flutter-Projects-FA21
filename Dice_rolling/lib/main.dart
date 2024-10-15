import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(DiceGameApp());
}

class DiceGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dice Rolling Videoo HGsmr',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Change primary color
      ),
      home: DiceGameScreen(),
    );
  }
}

class DiceGameScreen extends StatefulWidget {
  @override
  _DiceGameScreenState createState() => _DiceGameScreenState();
}

class _DiceGameScreenState extends State<DiceGameScreen> {
  // Game State Variables
  int currentPlayer = 0;
  int rounds = 0;
  final int maxRounds = 4;
  final List<int> scores = [0, 0, 0, 0];
  final List<int> turnsTaken = [0, 0, 0, 0];
  String message = "Player 1's Turn";
  bool gameOver = false;
  int diceRoll = 1;

  // Dice images path
  final List<String> diceImages = [
    'images/dice-1.png',
    'images/dice-2.png',
    'images/dice-3.png',
    'images/dice-4.png',
    'images/dice-5.png',
    'images/dice-6.png',
  ];

  // Custom colors
  final Color playerTextColor = Colors.white;
  final Color playerBackgroundColor = Colors.teal;
  final Color diceButtonColor = Colors.deepPurple;
  final Color restartButtonColor = Colors.orange;

  void rollDice() {
    if (!gameOver) {
      diceRoll = Random().nextInt(6) + 1;
      scores[currentPlayer] += diceRoll;
      turnsTaken[currentPlayer] += 1;

      setState(() {
        if (rounds < maxRounds * 4 - 1) {
          currentPlayer = (currentPlayer + 1) % 4;
          if (currentPlayer == 0) rounds++;
          message = "Player ${currentPlayer + 1}'s Turn";
        } else {
          gameOver = true;
          List<int> winners = findWinners();
          if (winners.length == 1) {
            message = "Game Over! Player ${winners[0] + 1} wins with ${scores[winners[0]]} points!";
          } else {
            String tiedPlayers = winners.map((i) => "Player ${i + 1}").join(' and ');
            message = "Game Tied! $tiedPlayers with ${scores[winners[0]]} points!";
          }
        }
      });
    }
  }

  List<int> findWinners() {
    int maxScore = scores[0];
    List<int> winners = [0];

    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > maxScore) {
        maxScore = scores[i];
        winners = [i];
      } else if (scores[i] == maxScore) {
        winners.add(i);
      }
    }

    return winners;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dice Rolling Game'),
      ),
      body: Stack(
        children: [
          // Player 1 (Top Left)
          Positioned(
            top: 20,
            left: 20,
            child: playerInfo(0, 'Player 1', playerBackgroundColor),
          ),
          // Player 2 (Top Right)
          Positioned(
            top: 20,
            right: 20,
            child: playerInfo(1, 'Player 2', playerBackgroundColor),
          ),
          // Player 3 (Bottom Left)
          Positioned(
            bottom: 20,
            left: 20,
            child: playerInfo(2, 'Player 3', playerBackgroundColor),
          ),
          // Player 4 (Bottom Right)
          Positioned(
            bottom: 20,
            right: 20,
            child: playerInfo(3, 'Player 4', playerBackgroundColor),
          ),
          // Dice Button (Center)
          if (!gameOver) Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Player ${currentPlayer + 1}\'s Turn',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
                ),
                SizedBox(height: 20),
                Image.asset(
                  diceImages[diceRoll - 1],
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: rollDice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: diceButtonColor,
                  ),
                  child: Text('Roll Dice'),
                ),
              ],
            ),
          ),
          // Show the game over screen and the winner when the game ends
          if (gameOver)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          // Restart Button at the bottom
          if (gameOver)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPlayer = 0;
                      rounds = 0;
                      scores.fillRange(0, 4, 0);
                      turnsTaken.fillRange(0, 4, 0);
                      message = "Player 1's Turn";
                      gameOver = false;
                      diceRoll = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: restartButtonColor,
                  ),
                  child: Text('Restart Game'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Player Info widget
  Widget playerInfo(int playerIndex, String playerName, Color backgroundColor) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            playerName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: playerTextColor),
          ),
          Text(
            'Score: ${scores[playerIndex]}',
            style: TextStyle(fontSize: 18, color: playerTextColor),
          ),
          Text(
            'Turns taken: ${turnsTaken[playerIndex]}',
            style: TextStyle(fontSize: 18, color: playerTextColor),
          ),
        ],
      ),
    );
  }
}
