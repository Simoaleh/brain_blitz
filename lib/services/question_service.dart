import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:brain_blitz/models/question.dart';

class QuestionService {
  static const String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';

  // word bank 
  final List<String> _wordBank_Animal = [
    //Animal 
  'cat', 'dog,', 'birdie'
  ];

  Future<Question> fetchQuestion(String word) async {
    final response = await http.get(Uri.parse('$_baseUrl/$word'));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final definition = data[0]['meanings'][0]['definitions'][0]['definition'];

      return Question(word: word, definition: definition);
    }
    else {
      throw Exception ('Failed to fetch definition for $word');
    }
  }
  
  String getRandomWord() {
  _wordBank_Animal.shuffle();
  return _wordBank_Animal.first;
  }
}