import 'package:flutter/material.dart';
import 'package:brain_blitz/models/question.dart';
import 'package:brain_blitz/services/question_service.dart';

class GameState extends ChangeNotifier {
  final QuestionService _service = QuestionService();

  Question? currentQuestion;
  bool isLoading = false;
  bool isCorrect = false; 

  Future<void> loadQuestion() async {
    isLoading = true;
    isCorrect = false;
    notifyListeners();

    final word = _service.getRandomWord();

    try {
      currentQuestion = await _service.fetchQuestion(word);
    } catch (e) {
      print('Error: $e');
    }
    isLoading = false;
    notifyListeners();
  }
  void checkAnswer(String input){
    if (currentQuestion == null) return;
    isCorrect = input.toLowerCase() == currentQuestion!.word.toLowerCase();
    notifyListeners();
  }
}
