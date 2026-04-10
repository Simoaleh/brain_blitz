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

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.brown[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'GAME OVER',
          textAlign: TextAlign.center,
          style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.orange),
        ),
        content: Text(
          'You reached Level ${context.read<GameState>().level}',
          textAlign: TextAlign.center,
          style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.white),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<GameState>().resetGame();
              context.read<GameState>().loadQuestion();
              _focusNode.requestFocus();
            },
            child: Text(
              'PLAY AGAIN',
              style: GoogleFonts.pressStart2p(
                fontSize: 12,
                color: Colors.orange,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'QUIT',
              style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final word = gameState.currentQuestion?.word ?? '';
    final wordLength = word.length;
    final typed = _controller.text;
    final hintIndex = gameState.hintIndex;

    // Inject hint letter into typed string for display and answer checking
    String effectiveTyped = typed;
    if (hintIndex != null && word.isNotEmpty) {
      final h = hintIndex!;
      if (effectiveTyped.length >= h) {
        effectiveTyped =
            effectiveTyped.substring(0, h) +
            word[h].toLowerCase() +
            effectiveTyped.substring(h);
      }
    }

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
                    icon: Opacity(
                      opacity: gameState.hintUsed ? 0.3 : 1.0,
                      child: Image.asset(
                        'assets/images/hint_icon.png',
                        width: 64,
                        height: 64,
                      ),
                    ),
                    onPressed: gameState.hintUsed
                        ? null
                        : () {
                            context.read<GameState>().setHintIndex(
                              _controller.text.length,
                            );
                          },
                  ),
                ],
              ),
              // Heart bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Image.asset(
                    i < gameState.lives
                        ? 'assets/images/heart.png'
                        : 'assets/images/heart_black.png',
                    width: 36,
                    height: 36,
                  );
                }),
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
                    maxLength: hintIndex != null ? wordLength - 1 : wordLength,
                    onChanged: (value) {
                      setState(() {});

                      String effective = value;
                      if (hintIndex != null && word.isNotEmpty) {
                        final h = hintIndex!;
                        if (effective.length >= h) {
                          effective =
                              effective.substring(0, h) +
                              word[h].toLowerCase() +
                              effective.substring(h);
                        }
                      }

                      if (effective.length == wordLength) {
                        context.read<GameState>().checkAnswer(effective);
                        final gs = context.read<GameState>();
                        if (gs.isCorrect) {
                          Future.delayed(const Duration(milliseconds: 800), () {
                            if (!mounted) return;
                            _controller.clear();
                            context.read<GameState>().loadQuestion();
                            _focusNode.requestFocus();
                          });
                        } else {
                          Future.delayed(const Duration(milliseconds: 600), () {
                            if (!mounted) return;
                            _controller.clear();
                            setState(() {});
                            if (context.read<GameState>().lives <= 0) {
                              _showGameOver();
                            } else {
                              _focusNode.requestFocus();
                            }
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
                children: List.generate(wordLength, (i) {
                  final displayLetter = i < effectiveTyped.length
                      ? effectiveTyped[i].toUpperCase()
                      : '';

                  Color tileColor;
                  if (effectiveTyped.length == wordLength) {
                    tileColor = gameState.isCorrect
                        ? Colors.green[300]!
                        : Colors.red[300]!;
                  } else if (i == hintIndex) {
                    tileColor = Colors.blue[200]!;
                  } else if (i < effectiveTyped.length) {
                    tileColor = Colors.orange[200]!;
                  } else {
                    tileColor = Colors.grey[300]!;
                  }

                  return AnimatedScale(
                    scale: i == effectiveTyped.length - 1 ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeOut,
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: tileColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          displayLetter,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
