import 'package:flutter/material.dart';
import 'package:brain_blitz/models/question.dart';
import 'package:brain_blitz/services/question_service.dart';

class GameState extends ChangeNotifier {
  int level = 1;
  int lives = 3;
  bool hintUsed = false;
  int? hintIndex;

  final QuestionService _service = QuestionService();

  Question? currentQuestion;
  bool isLoading = false;
  bool isCorrect = false;
  bool hasAnswered = false;

  Future<void> loadQuestion() async {
    isLoading = true;
    isCorrect = false;
    hasAnswered = false;
    hintUsed = false;
    hintIndex = null;
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

  void useHint() {
    if (hintUsed || currentQuestion == null) return;
    hintUsed = true;
    // Pick the first unfilled index — caller passes current typed length
    hintIndex = 0;
    notifyListeners();
  }

  void setHintIndex(int typedLength) {
    if (hintUsed || currentQuestion == null) return;
    hintUsed = true;
    hintIndex = typedLength; // fills the next empty slot
    notifyListeners();
  }

  void checkAnswer(String input) {
    if (currentQuestion == null) return;
    isCorrect = input.toLowerCase() == currentQuestion!.word.toLowerCase();
    hasAnswered = true;
    if (isCorrect) {
      level++;
    } else {
      if (lives > 0) lives--;
    }
    notifyListeners();
  }

  void resetGame() {
    level = 1;
    lives = 3;
    hintUsed = false;
    hintIndex = null;
    currentQuestion = null;
    isCorrect = false;
    hasAnswered = false;
    notifyListeners();
  }
}
