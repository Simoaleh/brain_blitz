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

  final List<String> wordBankChemistryEasy = ['atom', 'molecule', 'element'];

  final List<String> wordBankChemistryMedium = [
    'periodic table',
    'chemical bond',
    'ionic bond',
    'covalent bond',
    'solution',
    'solvent',
    'solute',
    'concentration',
    'ph scale',
    'neutralization',
    'oxidation',
    'reduction',
    'catalyst',
    'equilibrium',
    'molarity',
    'stoichiometry',
    'valence electrons',
    'reactant',
    'product',
    'precipitate',
  ];

  final List<String> wordBankChemistryHard = [
    'quantum mechanics',
    'electron configuration',
    'orbital hybridization',
    'enthalpy',
    'entropy',
    'gibbs free energy',
    'le chatelier principle',
    'electrochemistry',
    'redox reaction',
    'acid dissociation constant',
    'buffer solution',
    'titration curve',
    'spectroscopy',
    'chromatography',
    'polymerization',
    'nanotechnology',
    'isomerism',
    'thermodynamics',
    'kinetics',
    'molecular orbital theory',
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
    'function parameter',
    'return value',
    'conditional statement',
    'for loop',
    'while loop',
    'recursion',
    'exception handling',
    'library',
    'framework',
    'version control',
    'git',
    'repository',
    'debugging tool',
    'data structure',
  ];

  final List<String> wordBankProgrammingHard = [
    'object oriented programming',
    'functional programming',
    'asynchronous programming',
    'multithreading',
    'concurrency',
    'memory management',
    'garbage collection',
    'design patterns',
    'dependency injection',
    'microservices',
    'distributed systems',
    'compiler design',
    'interpreter',
    'abstract syntax tree',
    'type system',
    'lambda calculus',
    'algorithm optimization',
    'time complexity',
    'space complexity',
    'low level programming',
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

  final List<String> _usedWords = [];

  String getRandomWord() {
    final remaining = wordBankChemistryEasy
        .where((w) => !_usedWords.contains(w))
        .toList();

    if (remaining.isEmpty) {
      _usedWords.clear();
    }

    final available = remaining.isEmpty ? wordBankChemistryEasy : remaining;
    available.shuffle();
    final word = available.first;
    _usedWords.add(word);
    return word;
  }
}
