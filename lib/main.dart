import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'quiz_brain.dart';

QuestionBrain questionBrain = QuestionBrain();

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  String animation = 'idle';

  int scoreCounter = 0;
  final Icon rightIcon = const Icon(
    Icons.check,
    color: Colors.green,
    size: 30.0,
  );
  final Icon wrongIcon = const Icon(
    Icons.close,
    color: Colors.red,
    size: 30.0,
  );
  void checkAnswer(bool pickAnswer) {
    bool questionAnswer = questionBrain.getQuestionAnswer();

    setState(() {
      if (questionBrain.isFinished()) {
        scoreCounter++;
        Alert(
            context: context,
            type: scoreCounter > 10 ? AlertType.success : AlertType.error,
            title: scoreCounter > 10 ? 'WELL DONE' : 'MAYBE NEXT TIME ',
            desc: "Your score is $scoreCounter",
            buttons: [
              DialogButton(
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                  child: const Text(
                    "Start again",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))
            ]).show();
        scoreKeeper = [];
        scoreCounter = 0;
        animation = 'idle';
      } else {
        if (questionAnswer == pickAnswer) {
          scoreCounter++;
          scoreKeeper.add(rightIcon);
          animation = 'success';
        } else {
          scoreKeeper.add(wrongIcon);
          animation = 'fail';
        }
      }
      questionBrain.nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 150,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: FlareActor('assets/teddy_test.flr',
                alignment: Alignment.center,
                fit: BoxFit.fitWidth,
                animation: animation),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            'Question ${questionBrain.getQuestionNumber() + 1}/${questionBrain.getNumberOfQuestions()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        )),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(questionBrain.getQuestionText(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  )),
            ),
          ),
        ),
        Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextButton(
                    onPressed: () {
                      checkAnswer(true);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'True',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextButton(
                    onPressed: () {
                      checkAnswer(false);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'False',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            )),
        Expanded(
            child: Row(
          children: scoreKeeper,
        ))
      ],
    );
  }
}
