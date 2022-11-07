class Question {
  late String _questionText;
  late bool _questionAnswer;

  Question({required text, required answer}) {
    _questionAnswer = answer;
    _questionText = text;
  }
  String getQuestionText() {
    return _questionText;
  }

  bool getQuestionAnswer() {
    return _questionAnswer;
  }
}
