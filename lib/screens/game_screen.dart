import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brain_blitz/state/game_state.dart';
import 'package:google_fonts/google_fonts.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GameState>().loadQuestion();
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    context.read<GameState>().resetGame();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final wordLength = gameState.currentQuestion?.word.length ?? 0;
    final typed = _controller.text;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Column(
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/settings_icon.png',
                      width: 64,
                      height: 64,
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    'LEVEL ${gameState.level}',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 30,
                      color: Colors.orange,
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/hint_icon.png',
                      width: 64,
                      height: 64,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(
                height: 360,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/game_background.png',
                          width: double.infinity,
                          height: 260,
                          fit: BoxFit.fill,
                        ),
                        Image.asset(
                          'assets/images/wood.jpg',
                          width: double.infinity,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                    Positioned(
                      left: 60,
                      right: 60,
                      top: 40,
                      height: 180,
                      child: gameState.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Text(
                              gameState.currentQuestion?.definition ?? '',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: GoogleFonts.frederickaTheGreat(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 10,
                      child: Image.asset(
                        gameState.hasAnswered
                            ? (gameState.isCorrect
                                  ? 'assets/images/proud_wiz.png'
                                  : 'assets/images/sad_wiz.png')
                            : 'assets/images/regular_wiz.png',
                        width: 120,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Hidden text field
              SizedBox(
                height: 0,
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLength: wordLength,
                    onChanged: (value) {
                      setState(() {});
                      if (value.length == wordLength) {
                        context.read<GameState>().checkAnswer(value);
                        if (context.read<GameState>().isCorrect) {
                          Future.delayed(const Duration(milliseconds: 800), () {
                            _controller.clear();
                            context.read<GameState>().loadQuestion();
                          });
                        }
                      }
                    },
                    decoration: const InputDecoration(counterText: ''),
                  ),
                ),
              ),
              // Letter tiles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  wordLength,
                  (i) => AnimatedScale(
                    scale: i == typed.length - 1 ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeOut,
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: i < typed.length
                            ? (typed.length == wordLength
                                  ? (gameState.isCorrect
                                        ? Colors.green[300]
                                        : Colors.red[300])
                                  : Colors.orange[200])
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          i < typed.length ? typed[i].toUpperCase() : '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
