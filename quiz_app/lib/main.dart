import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: QuizSelectionScreen(),
    );
  }
}

class QuizSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Quiz Type'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orangeAccent,
              Colors.pinkAccent,
              Colors.blueAccent,
              Colors.greenAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QuizButton(
                title: 'Science Quiz',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(quizType: 'Science'),
                    ),
                  );
                },
              ),
              QuizButton(
                title: 'General Knowledge Quiz',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(quizType: 'General Knowledge'),
                    ),
                  );
                },
              ),
              QuizButton(
                title: 'Math Quiz',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(quizType: 'Math'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  QuizButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          backgroundColor: Colors.tealAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String quizType;

  QuizScreen({required this.quizType});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int questionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  List<bool?> answers = List.filled(5, null);
  Timer? _timer;
  int remainingTime = 5;

  final Map<String, List<Map<String, Object>>> quizQuestions = {
    'Science': [
      {
        'question': 'What is the chemical symbol for water?',
        'options': ['H2O', 'CO2', 'NaCl', 'O2'],
        'answer': 0,
      },
      {
        'question': 'What planet is known as the Red Planet?',
        'options': ['Earth', 'Mars', 'Jupiter', 'Venus'],
        'answer': 1,
      },
      {
        'question': 'What is the powerhouse of the cell?',
        'options': ['Nucleus', 'Mitochondria', 'Ribosome', 'Chloroplast'],
        'answer': 1,
      },
      {
        'question': 'What gas do plants absorb?',
        'options': ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'],
        'answer': 1,
      },
      {
        'question': 'What is the speed of light?',
        'options': ['300,000 km/s', '150,000 km/s', '100,000 km/s', '400,000 km/s'],
        'answer': 0,
      },
    ],
    'General Knowledge': [
      {
        'question': 'Which is the largest continent?',
        'options': ['Africa', 'Asia', 'Antarctica', 'Europe'],
        'answer': 1,
      },
      {
        'question': 'What is the capital of Japan?',
        'options': ['Tokyo', 'Beijing', 'Seoul', 'Bangkok'],
        'answer': 0,
      },
      {
        'question': 'Who wrote "Romeo and Juliet"?',
        'options': ['Charles Dickens', 'Mark Twain', 'William Shakespeare', 'Leo Tolstoy'],
        'answer': 2,
      },
      {
        'question': 'Which planet is known as the "Morning Star"?',
        'options': ['Mars', 'Venus', 'Jupiter', 'Saturn'],
        'answer': 1,
      },
      {
        'question': 'Who painted the Mona Lisa?',
        'options': ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Claude Monet'],
        'answer': 2,
      },
    ],
    'Math': [
      {
        'question': 'What is 2 + 2?',
        'options': ['3', '4', '5', '6'],
        'answer': 1,
      },
      {
        'question': 'What is the square root of 16?',
        'options': ['2', '4', '6', '8'],
        'answer': 1,
      },
      {
        'question': 'What is 5 x 5?',
        'options': ['25', '20', '15', '30'],
        'answer': 0,
      },
      {
        'question': 'What is 12 divided by 4?',
        'options': ['2', '3', '4', '5'],
        'answer': 1,
      },
      {
        'question': 'What is 10% of 200?',
        'options': ['10', '20', '30', '40'],
        'answer': 1,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    remainingTime = 5;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          nextQuestion();
        }
      });
    });
  }

  void answerQuestion(int selectedOption) {
    if (isAnswered) return;

    setState(() {
      isAnswered = true;
      answers[questionIndex] = selectedOption == quizQuestions[widget.quizType]![questionIndex]['answer'];
      if (answers[questionIndex]!) {
        score++;
      }
    });

    _timer?.cancel();
  }

  void nextQuestion() {
    setState(() {
      isAnswered = false;
      if (questionIndex < quizQuestions[widget.quizType]!.length - 1) {
        questionIndex++;
        startTimer();
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Quiz Completed'),
            content: Text('Your score is $score/${quizQuestions[widget.quizType]!.length}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  resetQuiz();
                },
                child: Text('Restart', style: TextStyle(color: Colors.teal)),
              ),
            ],
          ),
        );
      }
    });
  }

  void resetQuiz() {
    setState(() {
      questionIndex = 0;
      score = 0;
      answers = List.filled(5, null);
    });
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizType + ' Quiz'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orangeAccent,
              Colors.pinkAccent,
              Colors.blueAccent,
              Colors.greenAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Question ${questionIndex + 1} of ${quizQuestions[widget.quizType]!.length}',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Time Remaining: $remainingTime',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  quizQuestions[widget.quizType]![questionIndex]['question'] as String,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              ...(quizQuestions[widget.quizType]![questionIndex]['options'] as List<String>).asMap().entries.map((option) {
                int index = option.key;
                String value = option.value;

                return AnimatedButton(
                  title: value,
                  onPressed: isAnswered ? null : () => answerQuestion(index),
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isAnswered ? nextQuestion : null,
                child: Text('Next Question'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.tealAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  AnimatedButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          backgroundColor: Colors.tealAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
