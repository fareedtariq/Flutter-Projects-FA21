import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AudioPlayer player = AudioPlayer();
  final List<String> noteSequence = [];
  Color appBackgroundColor = Colors.white;

  // Default note colors and icons
  final List<Color> defaultNoteColors = [
    Colors.pink,
    Colors.black,
    Colors.blue,
    Colors.orange,
    Colors.amber,
    Colors.yellow,
    Colors.deepPurple,
  ];

  final List<String> noteNames = [
    "Note 1",
    "Note 2",
    "Note 3",
    "Note 4",
    "Note 5",
    "Note 6",
    "Note 7",
  ];

  final List<IconData> defaultNoteIcons = [
    Icons.emoji_nature,
    Icons.directions_car,
    Icons.pets,
    Icons.cake,
    Icons.sports_soccer,
    Icons.star,
    Icons.toys,
  ];

  final List<IconData> availableIcons = [
    Icons.favorite,
    Icons.catching_pokemon,
    Icons.icecream,
    Icons.flash_on,
    Icons.music_note,
    Icons.cloud,
    Icons.emoji_emotions,
  ];

  List<Color> currentNoteColors = [];
  List<IconData> currentNoteIcons = [];
  List<bool> isPressed = List.filled(7, false);
  double volume = 1.0; // Volume slider value

  @override
  void initState() {
    super.initState();
    currentNoteColors = List.from(defaultNoteColors);
    currentNoteIcons = List.from(defaultNoteIcons);
  }

  void playNote(String noteFile, int index) {
    player.setVolume(volume); // Set volume before playing
    player.play(AssetSource(noteFile));
    noteSequence.add(noteFile);
    setState(() {
      isPressed[index] = true;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        isPressed[index] = false;
      });
    });
  }

  void replaySequence() async {
    for (String note in noteSequence) {
      await player.play(AssetSource(note));
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void handleLongPress(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Customize Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  pickColor(index);
                },
                child: const Text('Pick Color'),
              ),
              ElevatedButton(
                onPressed: () {
                  pickIcon(index);
                },
                child: const Text('Pick Icon'),
              ),
              ElevatedButton(
                onPressed: () {
                  editNoteName(index);
                },
                child: const Text('Edit Note Name'),
              ),
              ElevatedButton(
                onPressed: () {
                  resetNote(index);
                },
                child: const Text('Reset to Default'),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void pickColor(int index) async {
    Color? pickedColor = await showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(currentColor: currentNoteColors[index]),
    );

    if (pickedColor != null) {
      setState(() {
        currentNoteColors[index] = pickedColor;
      });
    }
  }

  void pickIcon(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick an Icon'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: List.generate(availableIcons.length, (iconIndex) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        availableIcons[iconIndex],
                        size: 40,
                        color: currentNoteColors[index],
                      ),
                      onPressed: () {
                        setState(() {
                          currentNoteIcons[index] = availableIcons[iconIndex];
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(noteNames[index]), // Display the note name below the icon
                  ],
                );
              }),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void editNoteName(int index) {
    TextEditingController controller = TextEditingController(text: noteNames[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Note Name'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  noteNames[index] = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void resetNote(int index) {
    setState(() {
      currentNoteColors[index] = defaultNoteColors[index];
      currentNoteIcons[index] = defaultNoteIcons[index];
      noteNames[index] = "Note ${index + 1}"; // Reset to default name
    });
  }

  Widget buildKey({
    required int index,
    required String noteFile,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          playNote(noteFile, index);
        },
        onLongPress: () {
          handleLongPress(index);
        },
        child: AnimatedScale(
          scale: isPressed[index] ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: currentNoteColors[index].withOpacity(isPressed[index] ? 0.7 : 1.0),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: currentNoteColors[index].withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    currentNoteIcons[index],
                    size: 50.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    noteNames[index],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Xylophone',
            style: GoogleFonts.pacifico(
              textStyle: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.orange,
                  Colors.red,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: replaySequence,
              tooltip: 'Replay Notes',
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text('Volume', style: TextStyle(fontSize: 18)),
              Slider(
                value: volume,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: volume.toStringAsFixed(1),
                onChanged: (newVolume) {
                  setState(() {
                    volume = newVolume;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text('Background Color', style: TextStyle(fontSize: 18)),
              ElevatedButton(
                onPressed: pickBackgroundColor,
                child: const Text('Pick Color'),
              ),
              const SizedBox(height: 20),
              const Text('Edit Note Icons'),
              ElevatedButton(
                onPressed: editAllNoteIcons,
                child: const Text('Edit Icons'),
              ),
              const SizedBox(height: 20),
              const Text('Reset All Notes', style: TextStyle(fontSize: 18)),
              ElevatedButton(
                onPressed: resetAllNotes,
                child: const Text('Reset to Default'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: editAllNoteNames,
                child: const Text('Edit All Names'),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            color: appBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(7, (index) {
                return buildKey(
                  index: index,
                  noteFile: 'note${index + 1}.wav',
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void pickBackgroundColor() async {
    Color? pickedColor = await showDialog(
      context: context,
      builder: (context) => ColorPickerDialog(currentColor: appBackgroundColor),
    );

    if (pickedColor != null) {
      setState(() {
        appBackgroundColor = pickedColor;
      });
    }
  }

  void editAllNoteIcons() {
    for (int i = 0; i < currentNoteIcons.length; i++) {
      pickIcon(i);
    }
  }

  void resetAllNotes() {
    setState(() {
      currentNoteColors = List.from(defaultNoteColors);
      currentNoteIcons = List.from(defaultNoteIcons);
      for (int i = 0; i < noteNames.length; i++) {
        noteNames[i] = "Note ${i + 1}"; // Reset to default names
      }
    });
  }

  void editAllNoteNames() {
    for (int i = 0; i < noteNames.length; i++) {
      editNoteName(i);
    }
  }
}

// Color Picker Dialog
class ColorPickerDialog extends StatelessWidget {
  final Color currentColor;

  const ColorPickerDialog({Key? key, required this.currentColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color selectedColor = currentColor;

    return AlertDialog(
      title: const Text('Select Color'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: 300,
              child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  selectedColor = color;
                },
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedColor);
              },
              child: const Text('Select'),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}
