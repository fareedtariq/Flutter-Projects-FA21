import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(DiceGameApp());
}

class DiceGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dice Rolling Game',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: PlayerNameScreen(),
    );
  }
}

class PlayerNameScreen extends StatelessWidget {
  final List<TextEditingController> controllers =
  List.generate(4, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Player Names'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              // Add functionality for info icon if needed
            },
          ),
        ],
      ),
      body: SingleChildScrollView( // Wrap Column with SingleChildScrollView
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.yellowAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to the Dice Rolling Game!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              for (int i = 0; i < 4; i++)
                TextField(
                  controller: controllers[i],
                  decoration: InputDecoration(
                    labelText: 'Player ${i + 1} Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  List<String> playerNames =
                  controllers.map((controller) => controller.text).toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DiceGameScreen(playerNames: playerNames)),
                  );
                },
                child: Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiceGameScreen extends StatefulWidget {
  final List<String> playerNames;

  DiceGameScreen({required this.playerNames});

  @override
  _DiceGameScreenState createState() => _DiceGameScreenState();
}

class _DiceGameScreenState extends State<DiceGameScreen> {
  int currentPlayer = 0;
  int rounds = 0;
  final int maxRounds = 4;
  final List<int> scores = [0, 0, 0, 0];
  final List<int> turnsTaken = [0, 0, 0, 0];
  String message = "";
  bool gameOver = false;
  int diceRoll = 1;

  List<String> diceImages = [
    'images/dice-1.png',
    'images/dice-2.png',
    'images/dice-3.png',
    'images/dice-4.png',
    'images/dice-5.png',
    'images/dice-6.png',
  ];

  List<Color> playerColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];

  final Color diceButtonColor = Colors.deepPurple;
  final Color restartButtonColor = Colors.orange;

  @override
  void initState() {
    super.initState();
    message = "${widget.playerNames[0]}'s Turn";
  }

  void rollDice() {
    if (!gameOver) {
      diceRoll = Random().nextInt(6) + 1;
      scores[currentPlayer] += diceRoll;
      turnsTaken[currentPlayer] += 1;

      setState(() {
        if (rounds < maxRounds * 4 - 1) {
          currentPlayer = (currentPlayer + 1) % 4;
          if (currentPlayer == 0) rounds++;
          message = "${widget.playerNames[currentPlayer]}'s Turn";
        } else {
          gameOver = true;
          List<int> winners = findWinners();
          if (winners.length == 1) {
            message =
            "Game Over! ${widget.playerNames[winners[0]]} wins with ${scores[winners[0]]} points!";
          } else {
            String tiedPlayers =
            winners.map((i) => widget.playerNames[i]).join(' and ');
            message =
            "Game Tied! $tiedPlayers with ${scores[winners[0]]} points!";
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

  void openSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Select Dice Image:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(diceImages.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        diceRoll = index + 1;
                      });
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      diceImages[index],
                      width: 50,
                      height: 50,
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              Text('Change Player Colors:'),
              ...List.generate(4, (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Player ${index + 1}:'),
                    Container(
                      width: 30,
                      height: 30,
                      color: playerColors[index],
                    ),
                    IconButton(
                      icon: Icon(Icons.color_lens),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title:
                              Text('Select Color for Player ${index + 1}'),
                              content: SingleChildScrollView(
                                child: BlockPicker(
                                  pickerColor: playerColors[index],
                                  onColorChanged: (color) {
                                    setState(() {
                                      playerColors[index] = color;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dice Rolling Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: openSettings,
          ),
        ],
      ),
      body: SingleChildScrollView( // Wrap the entire body in a scrollable view
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.yellowAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              height: MediaQuery.of(context).size.height,
            ),
            Positioned(
              top: 40,
              left: 20,
              child: playerInfoBox(0, widget.playerNames[0], scores[0],
                  turnsTaken[0], playerColors[0]),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: playerInfoBox(1, widget.playerNames[1], scores[1],
                  turnsTaken[1], playerColors[1]),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              child: playerInfoBox(2, widget.playerNames[2], scores[2],
                  turnsTaken[2], playerColors[2]),
            ),
            Positioned(
              bottom: 40,
              right: 20,
              child: playerInfoBox(3, widget.playerNames[3], scores[3],
                  turnsTaken[3], playerColors[3]),
            ),
            if (!gameOver)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
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
            if (gameOver)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: restartButtonColor,
                      ),
                      child: Text('Restart Game'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget playerInfoBox(int playerIndex, String playerName, int score,
      int turns, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            playerName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            'Score: $score',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            'Turns: $turns',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
