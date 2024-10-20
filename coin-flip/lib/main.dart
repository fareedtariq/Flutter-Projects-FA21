import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(FlipMasterApp()); // New unique app name
}

class FlipMasterApp extends StatefulWidget {
  @override
  _FlipMasterAppState createState() => _FlipMasterAppState();
}

class _FlipMasterAppState extends State<FlipMasterApp> {
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlipMaster', // Unique app name
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: _isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      home: CoinFlipScreen(
        onThemeChanged: (bool isDark) {
          setState(() {
            _isDarkTheme = isDark;
          });
        },
        isDarkTheme: _isDarkTheme,
      ),
    );
  }
}

class CoinFlipScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkTheme;

  CoinFlipScreen({required this.onThemeChanged, required this.isDarkTheme});

  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen> with SingleTickerProviderStateMixin {
  List<String> _playerNames = ['Player 1', 'Player 2', 'Player 3', 'Player 4'];
  List<Color> _playerColors = [Colors.red, Colors.green, Colors.blue, Colors.orange];
  List<String> _playerResults = ['', '', '', ''];
  int _currentPlayer = 0;
  Random _random = Random();
  String _coinImage = 'assets/images/head.png';
  bool _gameOver = false;
  String _winnerMessage = '';

  // Animation controller for coin flip
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300), // Speed of coin flip
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(_animationController);
  }

  void _flipCoin() {
    setState(() {
      // Play coin flip sound


      // Flip the coin for the current player
      bool isHeads = _random.nextBool();
      _coinImage = isHeads ? 'assets/images/head.png' : 'assets/images/tail.png';
      _playerResults[_currentPlayer] = isHeads ? 'Heads' : 'Tails';

      // Start the animation
      _animationController.forward().then((_) {
        _animationController.reset();

        // Check if the game is over
        if (_currentPlayer == 3) {
          _gameOver = true;
          _determineWinner();
          _showWinnerDialog(); // Show the winner announcement dialog
        } else {
          _currentPlayer++;
        }
      });
    });
  }

  void _determineWinner() {
    int headsCount = _playerResults.where((result) => result == 'Heads').length;
    int tailsCount = _playerResults.where((result) => result == 'Tails').length;

    if (headsCount > tailsCount) {
      _winnerMessage = 'Heads wins!';
    } else if (tailsCount > headsCount) {
      _winnerMessage = 'Tails wins!';
    } else {
      _winnerMessage = 'It\'s a tie!';
    }
  }

  void _resetGame() {
    setState(() {
      _playerResults = ['', '', '', ''];
      _currentPlayer = 0;
      _gameOver = false;
      _winnerMessage = '';
      _coinImage = 'assets/images/head.png';
    });
  }

  void _editPlayerName(int playerIndex) {
    TextEditingController nameController = TextEditingController(text: _playerNames[playerIndex]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Player Name'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Player Name'),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  _playerNames[playerIndex] = nameController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editPlayerColor(int playerIndex) {
    Color selectedColor = _playerColors[playerIndex];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Player Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _playerColors[playerIndex] = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show the winner announcement dialog
  void _showWinnerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Winner Announced'),
          content: Text(_winnerMessage, style: TextStyle(fontSize: 18)),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Play Again'),
              onPressed: () {
                _resetGame();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FlipMaster',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings or open a dialog
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.white,
            height: 4.0,
          ),
        ),
        elevation: 5,
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset(
              'assets/animation/background.json',
              fit: BoxFit.cover,
            ), // Full-screen Lottie animation as the background
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _gameOver ? _winnerMessage : '${_playerNames[_currentPlayer]}\'s Turn',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _playerColors[_currentPlayer]),
                ),
                SizedBox(height: 20),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(_animation.value),
                  child: Image.asset(
                    _coinImage,
                    height: 200,
                    width: 200,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  _gameOver ? 'Game Over' : 'Flip the coin',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                if (!_gameOver)
                  ElevatedButton(
                    onPressed: _flipCoin,
                    child: Text('Flip Coin'),
                  ),
                if (_gameOver)
                  ElevatedButton(
                    onPressed: _resetGame,
                    child: Text('Play Again'),
                  ),
                SizedBox(height: 20),
                _buildPlayerResults(), // Display player results
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Edit Player Names'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ListView.builder(
                    itemCount: _playerNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.person),
                        title: Text(_playerNames[index]),
                        trailing: Icon(Icons.edit),
                        onTap: () => _editPlayerName(index),
                      );
                    },
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Edit Player Colors'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ListView.builder(
                    itemCount: _playerNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.color_lens),
                        title: Text('Change color for ${_playerNames[index]}'),
                        trailing: Container(
                          width: 24,
                          height: 24,
                          color: _playerColors[index],
                        ),
                        onTap: () => _editPlayerColor(index),
                      );
                    },
                  );
                },
              );
            },
          ),
          SwitchListTile(
            title: Text('Switch Theme'),
            secondary: Icon(widget.isDarkTheme ? Icons.dark_mode : Icons.light_mode),
            value: widget.isDarkTheme,
            onChanged: (bool value) {
              widget.onThemeChanged(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerResults() {
    return Column(
      children: List.generate(4, (index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _playerColors[index].withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _playerColors[index]),
          ),
          child: Text(
            '${_playerNames[index]}: ${_playerResults[index]}',
            style: TextStyle(fontSize: 18, color: _playerColors[index]),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
