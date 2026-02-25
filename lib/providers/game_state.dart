import 'package:flutter/material.dart';
import 'package:brain_blitz/models/question.dart';
import 'package:brain_blitz/services/question_service.dart';

class GameState extends ChangeNotifier{
  final QuestionService _service = QuestionService();

  Question? currentQuestion;
  bool isLoading = false;

  Future<void> loadQuestion() async {
    isLoading=true;
    notifyListeners();

    final word = _service.getRandomWord();
    currentQuestion = await _service.fetchQuestion(word);

    isLoading = false;
    notifyListeners();
  }
}
