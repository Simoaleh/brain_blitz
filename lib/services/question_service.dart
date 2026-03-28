import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:brain_blitz/models/question.dart';

class QuestionService {
  static const String _baseUrl =
      'https://api.dictionaryapi.dev/api/v2/entries/en';

  // word bank
  final List<String> wordBankAnimal = ['cat', 'dog', 'birdie'];

  final List<String> wordBankTechEasy = [
    'computer',
    'internet',
    'mouse',
    'keyboard',
    'screen',
    'phone',
    'app',
    'website',
    'email',
    'wifi',
    'download',
    'upload',
    'password',
    'file',
    'folder',
    'printer',
    'tablet',
    'camera',
    'video',
    'audio',
  ];

  final List<String> wordBankTechMedium = [
    'software',
    'hardware',
    'operating system',
    'browser',
    'cloud storage',
    'database',
    'network',
    'firewall',
    'encryption',
    'algorithm',
    'programming',
    'coding',
    'user interface',
    'user experience',
    'server',
    'client',
    'bandwidth',
    'api',
    'debugging',
    'version control',
  ];

  final List<String> wordBankTechHard = [
    'machine learning',
    'artificial intelligence',
    'neural network',
    'blockchain',
    'cryptography',
    'distributed systems',
    'data mining',
    'quantum computing',
    'natural language processing',
    'computer vision',
    'big data',
    'edge computing',
    'internet of things',
    'cybersecurity',
    'penetration testing',
    'virtualization',
    'containerization',
    'microservices architecture',
    'devops',
    'parallel computing',
  ];

  Future<Question> fetchQuestion(String word) async {
    final response = await http.get(Uri.parse('$_baseUrl/$word'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final definition = data[0]['meanings'][0]['definitions'][0]['definition'];

      return Question(word: word, definition: definition);
    } else {
      throw Exception('Failed to fetch definition for $word');
    }
  }

  String getRandomWord() {
    wordBankTechEasy.shuffle();
    return wordBankTechEasy.first;
  }
}
