import 'package:flutter/material.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/widgets/next_button.dart';
import 'package:quiz_app/widgets/option_card.dart';
import 'package:quiz_app/widgets/question_widget.dart';
import 'package:quiz_app/widgets/result_box.dart';

import '../models/question_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Question> _questions = [
    Question(
      id: '10',
      title: 'What is 2+2?',
      options: {'5': false, '30': false, '4': true, '10': false},
    ),
    Question(
      id: '11',
      title: 'What is 3+3?',
      options: {'5': false, '30': false, '6': true, '10': false},
    ),
    Question(
      id: '12',
      title: 'What is 4+4?',
      options: {'5': false, '30': false, '8': true, '10': false},
    ),
  ];

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;

  void nextQuestion() {
    if (index == _questions.length - 1) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
                result: score,
                questionLength: _questions.length,
                onPressed: () {},
              ));
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an option'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20.0),
          ),
        );
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
        setState(() {
          isPressed = true;
          isAlreadySelected = false;
        });
      }
    }
    void startOver() {
      setState(() {
        index = 0;
        score = 0;
        isPressed = false;
        isAlreadySelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Score: $score',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ],
        title: const Text(
          'Quiz App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        width: double.infinity,
        child: Column(
          children: [
            QuestionWidget(
              question: _questions[index].title,
              indexAction: index,
              totalQuestions: _questions.length,
            ),
            const Divider(
              color: neutral,
            ),
            const SizedBox(
              height: 25.0,
            ),
            for (int i = 0; i < _questions[index].options.length; i++)
              GestureDetector(
                onTap: () => checkAnswerAndUpdate(
                    _questions[index].options.values.toList()[i]),
                child: OptionCard(
                  option: _questions[index].options.keys.toList()[i],
                  color: isPressed
                      ? _questions[index].options.values.toList()[i]
                          ? correct
                          : incorrect
                      : neutral,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(
          nextQuestion: nextQuestion,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
