import 'package:flutter/material.dart';
import 'dart:async'; // Import the timer library

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
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int questionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  List<bool?> answers = List.filled(5, null);
  Timer? _timer;
  int remainingTime = 5; // Countdown timer starting at 5 seconds

  final List<Map<String, Object>> questions = [
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
      'question': 'Which planet is known as the Blue Planet?',
      'options': ['Mars', 'Earth', 'Venus', 'Jupiter'],
      'answer': 1,
    },
    {
      'question': 'What is the smallest country in the world?',
      'options': ['Vatican City', 'Monaco', 'Nauru', 'Tuvalu'],
      'answer': 0,
    },
    {
      'question': 'Which element has the chemical symbol O?',
      'options': ['Gold', 'Oxygen', 'Hydrogen', 'Carbon'],
      'answer': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    remainingTime = 5; // Reset time
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          nextQuestion(); // Automatically go to next question
        }
      });
    });
  }

  void answerQuestion(int selectedOption) {
    if (isAnswered) return;

    setState(() {
      isAnswered = true;
      answers[questionIndex] = selectedOption == questions[questionIndex]['answer'];
      if (answers[questionIndex]!) {
        score++;
      }
    });

    // Cancel the timer when the question is answered
    _timer?.cancel();

    // Start a new timer for the next question
    Timer(Duration(seconds: 2), nextQuestion); // Wait 2 seconds before moving on
  }

  void nextQuestion() {
    setState(() {
      isAnswered = false;
      if (questionIndex < questions.length - 1) {
        questionIndex++;
      } else {
        // Show results
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Quiz Completed'),
            content: Text('Your score is $score/${questions.length}'),
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

    // Start the timer for the next question
    startTimer();
  }

  void resetQuiz() {
    setState(() {
      questionIndex = 0;
      score = 0;
      answers = List.filled(5, null);
    });
    startTimer(); // Restart the timer
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Quiz App')),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Question ${questionIndex + 1}/${questions.length}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'Time left: $remainingTime seconds',
                  style: TextStyle(fontSize: 18, color: Colors.yellowAccent),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    questions[questionIndex]['question'] as String,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                ...(questions[questionIndex]['options'] as List<String>).asMap().entries.map((option) {
                  int index = option.key;
                  String value = option.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: isAnswered ? null : () => answerQuestion(index),
                      child: Text(value),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAnswered
                            ? (index == questions[questionIndex]['answer'] ? Colors.green
                            : (answers[questionIndex] == false && index == questions[questionIndex]['answer'] ? Colors.red : Colors.grey))
                            : Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),
                if (isAnswered)
                  ElevatedButton(
                    onPressed: nextQuestion,
                    child: Text('Next Question'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
