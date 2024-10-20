import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SpinBottleGame());
}

class SpinBottleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpinBottleHome(),
    );
  }
}

class SpinBottleHome extends StatefulWidget {
  @override
  _SpinBottleHomeState createState() => _SpinBottleHomeState();
}

class _SpinBottleHomeState extends State<SpinBottleHome>
    with SingleTickerProviderStateMixin {
  final List<Color> playerColors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.tealAccent,
    Colors.deepOrangeAccent,
    Colors.cyanAccent,
    Colors.indigoAccent,
  ];

  List<String> playerNames = List.generate(10, (index) => "Player ${index + 1}");
  bool spinning = false;
  String selectedPlayer = "";
  bool showNameInput = true;
  String selectedBottleImage = 'assets/wine.jpg'; // Default bottle image

  AnimationController? _controller;
  double _currentRotation = 0;
  double _targetRotation = 0;

  // Predefined challenges
  List<String> challenges = [
    "Do 10 pushups",
    "Sing a song",
    "Tell a joke",
    "Dance for 30 seconds",
    "Imitate an animal",
    "Share a secret",
    "Do your best impression of a celebrity",
    "Act like a robot for 1 minute",
    "Do a silly walk",
    "Say the alphabet backwards"
  ];

  String selectedChallenge = "";

  @override
  @override
  void initState() {
    super.initState();

    // Print the initial player names and challenges for debugging
    print('Player Names: $playerNames');
    print('Challenges: $challenges');

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addListener(() {
      setState(() {
        _currentRotation = _controller!.value * _targetRotation;
      });
    });
  }


  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Prevent back navigation while spinning
  Future<bool> _onWillPop() async {
    if (spinning) {
      return false; // Prevent back navigation if spinning
    } else {
      return true; // Allow back navigation if not spinning
    }
  }


  void spinBottle() {
    setState(() {
      spinning = true;

      // Calculate the angle each player occupies on the circle
      double playerAngle = (2 * pi) / playerNames.length;

      // Generate a random index for the selected player
      Random random = Random();
      int selectedPlayerIndex = random.nextInt(playerNames.length);
      double stopAngle = selectedPlayerIndex * playerAngle;

      // Calculate the rotation target for smooth spinning
      _targetRotation =
          _currentRotation + 4 * pi + stopAngle - (_currentRotation % (2 * pi));

      _controller?.reset();

      // Start the animation and handle completion
      _controller?.forward().then((_) {
        setState(() {
          spinning = false;

          // Assign selected player and challenge after spinning completes
          // Adjust the index calculation to ensure correct display
          selectedPlayer = playerNames[selectedPlayerIndex];
          selectedChallenge = challenges[selectedPlayerIndex % challenges.length];

          // Logging the results for debugging
          print('Spin completed:');
          print('Randomly selected player index: $selectedPlayerIndex');
          print('Selected Player: $selectedPlayer');
          print('Selected Challenge: $selectedChallenge');
        });
      });
    });
  }


  Widget buildPlayerNames() {
    return ListView.builder(
      itemCount: playerNames.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: TextField(
            controller: TextEditingController(text: playerNames[index]),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.9),
              labelText: "Player ${index + 1} Name",
              labelStyle: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.deepPurple, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 3),
              ),
            ),
            onChanged: (value) {
              playerNames[index] = value.isNotEmpty ? value : "Player ${index + 1}";
            },
          ),
        );
      },
    );
  }

  Widget buildWheel() {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(playerNames.length, (index) {
        final angle = (index / playerNames.length) * 2 * pi;
        return Transform.translate(
          offset: Offset(
            120 * cos(angle),
            120 * sin(angle),
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: playerColors[index % playerColors.length],
            child: Text(
              playerNames[index],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }),
    );
  }

  void selectBottle() async {
    String? selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select a Bottle"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: Image.asset('assets/wine.jpg', width: 50, height: 50),
                  title: Text("Wine Bottle"),
                  onTap: () {
                    Navigator.of(context).pop('assets/wine.jpg');
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/AB.png', width: 50, height: 50),
                  title: Text("Green Bottle"),
                  onTap: () {
                    Navigator.of(context).pop('assets/AB.png');
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/Bo.jpg', width: 50, height: 50),
                  title: Text("Juice Bottle"),
                  onTap: () {
                    Navigator.of(context).pop('assets/Bo.jpg');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedBottleImage = selected;
      });
    }
  }

  void changePlayerColor() async {
    Color? selectedColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color color = Colors.redAccent; // Default color
        return AlertDialog(
          title: Text("Select Player Color"),
          content: SingleChildScrollView(
            child: Column(
              children: playerColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(color);
                  },
                  child: Container(
                    height: 50,
                    color: color,
                    child: Center(
                      child: Text(
                        "Select",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selectedColor != null) {
      setState(() {
        for (int i = 0; i < playerColors.length; i++) {
          if (i < playerNames.length) {
            playerColors[i] = selectedColor;
          }
        }
      });
    }
  }

  void showSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Settings"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  title: Text("Edit Player Names"),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the settings dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Edit Player Names"),
                          content: Container(
                            width: double.maxFinite,
                            child: buildPlayerNames(), // Display the player names for editing
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the edit dialog
                              },
                              child: Text("Done"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: Text("Change Colors"),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the settings dialog
                    changePlayerColor(); // Call the function to change colors
                  },
                ),
                ListTile(
                  title: Text("Choose Bottle"),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the settings dialog
                    selectBottle(); // Call the function to select a bottle
                  },
                ),
                ListTile(
                  title: Text("Edit Tasks"),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the settings dialog
                    editTasks(); // Call the function to edit tasks
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void editTasks() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Tasks"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: TextField(
                    decoration: InputDecoration(
                      labelText: "Task ${index + 1}",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      challenges[index] = value; // Update the task
                    },
                    controller: TextEditingController(text: challenges[index]),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        challenges.removeAt(index); // Remove the task
                      });
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Close"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  challenges.add("New Task"); // Add a new task placeholder
                });
                Navigator.of(context).pop(); // Close the dialog
                editTasks(); // Open the dialog again to add new tasks
              },
              child: Text("Add Task"),
            ),
          ],
        );
      },
    );
  }

  Widget fadeIn({required Widget child}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(seconds: 1),
      builder: (context, double opacity, _) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
    );
  }

  Widget buildSpinBottlePage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Spin & Share",
          style: TextStyle(
            fontSize: 26, // Increase font size for more impact
            fontWeight: FontWeight.bold, // Make the text bold
            color: Colors.yellowAccent, // Change text color
            letterSpacing: 2, // Increase letter spacing
            shadows: [
              Shadow(
                blurRadius: 3.0,
                color: Colors.black.withOpacity(0.6),
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: showSettings,
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purpleAccent,
              Colors.blueAccent,
              Colors.greenAccent,
              Colors.orangeAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showNameInput
                  ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildPlayerNames(),
                ),
              )
                  : Expanded(
                child: fadeIn(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: _currentRotation,
                          child: Image.asset(
                            selectedBottleImage,
                            width: 150,
                            height: 150,
                          ),
                        ),
                        buildWheel(),
                      ],
                    ),
                  ),
                ),
              ),
              if (!spinning && !showNameInput)
                Column(
                  children: [
                    Text(
                      selectedPlayer.isEmpty
                          ? "Tap Spin to start!"
                          : "$selectedPlayer's turn\nChallenge: $selectedChallenge",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ElevatedButton(
                onPressed: showNameInput
                    ? () {
                  setState(() {
                    showNameInput = false;
                  });
                }
                    : !spinning
                    ? spinBottle
                    : null,
                child: Text(
                  showNameInput ? "Start Game" : "Spin",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return buildSpinBottlePage();
  }
}
