import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:brain_blitz/models/question.dart';

class QuestionService {
  static const String _baseUrl =
      'https://api.dictionaryapi.dev/api/v2/entries/en';

  // word bank

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
    'debugging',
  ];

  final List<String> wordBankTechHard = [
    'machine learning',
    'artificial intelligence',
    'neural network',
    'blockchain',
    'cryptography',
    'data mining',
    'natural language processing',
    'big data',
    'internet of things',
    'cybersecurity',
  ];

  final List<String> wordBankChemistryEasy = ['atom', 'molecule', 'element'];

  final List<String> wordBankChemistryMedium = [
    'periodic table',
    'solution',
    'solvent',
    'solute',
    'concentration',
    'oxidation',
    'reduction',
    'catalyst',
    'equilibrium',
    'stoichiometry',
    'reactant',
    'product',
    'precipitate',
  ];

  final List<String> wordBankChemistryHard = [
    'quantum mechanics',
    'enthalpy',
    'entropy',
    'electrochemistry',
    'buffer solution',
    'spectroscopy',
    'chromatography',
    'nanotechnology',
    'thermodynamics',
    'kinetics',
  ];

  final List<String> wordBankProgrammingEasy = [
    'code',
    'program',
    'computer',
    'variable',
    'loop',
    'function',
    'print',
    'input',
    'string',
    'integer',
    'boolean',
    'debug',
    'run',
    'compile',
    'error',
    'output',
    'syntax',
    'command',
  ];

  final List<String> wordBankProgrammingMedium = [
    'array',
    'list',
    'object',
    'class',
    'method',
    'recursion',
    'library',
    'framework',
    'git',
    'repository',
  ];

  final List<String> wordBankProgrammingHard = [
    'multithreading',
    'concurrency',
    'garbage collection',
    'interpreter',
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

  final Map<String, Set<String>> _usedWordsByPool = {};

  String _normalize(String value) => value.trim().toLowerCase();

  List<String> _getWordBank(String category, String difficulty) {
    final c = _normalize(category);
    final d = _normalize(difficulty);

    if (c == 'technology' && d == 'easy') return wordBankTechEasy;
    if (c == 'technology' && d == 'medium') return wordBankTechMedium;
    if (c == 'technology' && d == 'hard') return wordBankTechHard;

    if (c == 'chemistry' && d == 'easy') return wordBankChemistryEasy;
    if (c == 'chemistry' && d == 'medium') return wordBankChemistryMedium;
    if (c == 'chemistry' && d == 'hard') return wordBankChemistryHard;

    if (c == 'programming' && d == 'easy') return wordBankProgrammingEasy;
    if (c == 'programming' && d == 'medium') return wordBankProgrammingMedium;
    if (c == 'programming' && d == 'hard') return wordBankProgrammingHard;

    return wordBankProgrammingEasy;
  }

  String getRandomWord({required String category, required String difficulty}) {
    final bank = _getWordBank(category, difficulty);
    final poolKey = '${_normalize(category)}|${_normalize(difficulty)}';
    final used = _usedWordsByPool.putIfAbsent(poolKey, () => <String>{});

    var remaining = bank.where((w) => !used.contains(w)).toList();
    if (remaining.isEmpty) {
      used.clear();
      remaining = List<String>.from(bank);
    }

    remaining.shuffle();
    final word = remaining.first;
    used.add(word);
    return word;
  }
}
