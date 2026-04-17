import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:brain_blitz/state/game_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brain_blitz/screens/settings_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FlutterTts _tts = FlutterTts();
  final GlobalKey _tilesKey =
      GlobalKey(); // Track tile position for scrolling

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('en-US');
    _tts.setSpeechRate(0.4);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GameState>().loadQuestion();
        _focusNode.requestFocus(); //  Request focus to show keyboard
      }
    });
  }

  Future<void> _speakWord() async {
    final word = context.read<GameState>().currentQuestion?.word;
    if (word != null) {
      await _tts.speak(word);
      _restoreKeyboardFocus();
    }
  }

  void _restoreKeyboardFocus() {
    _focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _tts.stop();
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
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'GAME OVER',
            textAlign: TextAlign.center,
            style: GoogleFonts.pressStart2p(
              fontSize: 20.sp,
              color: Colors.orange,
            ),
          ),
        ),
        content: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'You reached Level ${context.read<GameState>().level}',
            textAlign: TextAlign.center,
            style: GoogleFonts.pressStart2p(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
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
                fontSize: 12.sp,
                color: Colors.orange,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
            child: Text(
              'QUIT',
              style: GoogleFonts.pressStart2p(
                fontSize: 12.sp,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 👇 Helper: Scroll to tiles when keyboard opens
  void _scrollToTiles() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = this.context;
      if (!mounted) return;
      final renderBox =
          _tilesKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final offset = renderBox.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.of(context).size.height;
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        // If tiles are below keyboard bottom, scroll up
        if (offset.dy + renderBox.size.height > screenHeight - keyboardHeight) {
          Scrollable.ensureVisible(
            _tilesKey.currentContext!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final gameState = context.watch<GameState>();
    final word = gameState.currentQuestion?.word ?? '';
    final wordLength = word.length;
    final typed = _controller.text;
    final hintIndex = gameState.hintIndex;
    final int? inputMaxLength = wordLength > 0
        ? (hintIndex != null
              ? (wordLength - 1).clamp(1, wordLength)
              : wordLength)
        : null;

    // Responsive tile size: fill screen width minus padding, clamped
    final screenWidth = MediaQuery.of(context).size.width;
    final tileSize = wordLength > 0
        ? ((screenWidth - 48) / wordLength).clamp(16.0, 52.0)
        : 36.0;
    final tileFontSize = (tileSize * 0.5).clamp(8.0, 22.0);

    // Inject hint letter into typed string for display and answer checking
    String effectiveTyped = typed;
    if (hintIndex != null && word.isNotEmpty) {
      final h = hintIndex;
      if (effectiveTyped.length >= h) {
        effectiveTyped =
            effectiveTyped.substring(0, h) +
            word[h].toLowerCase() +
            effectiveTyped.substring(h);
      }
    }

    // 👇 Listen for keyboard changes to scroll to tiles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (keyboardHeight > 0 && effectiveTyped.isNotEmpty) {
        _scrollToTiles();
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true, // 👈 Enable keyboard resizing
      body: SafeArea(
        child: GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: SingleChildScrollView(
            // 👇 Remove reverse: true - causes scrolling issues with keyboard
            padding: EdgeInsets.only(
              bottom: keyboardHeight > 0 ? keyboardHeight + 20.h : 20.h,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Top bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/settings_icon.png',
                              width: 40.w,
                              height: 40.w,
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'LEVEL ${gameState.level}',
                            style: GoogleFonts.pressStart2p(
                              fontSize: 24.sp,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Opacity(
                            opacity: gameState.hintUsed ? 0.3 : 1.0,
                            child: Image.asset(
                              'assets/images/hint_icon.png',
                              width: 40.w,
                              height: 40.w,
                            ),
                          ),
                          onPressed: gameState.hintUsed
                              ? null
                              : () {
                                  context.read<GameState>().setHintIndex(
                                    _controller.text.length,
                                  );
                                  _restoreKeyboardFocus();
                                },
                        ),
                      ],
                    ),
                    // Heart bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(gameState.lives, (i) {
                        return Image.asset(
                          i < gameState.lives
                              ? 'assets/images/heart.png'
                              : 'assets/images/heart_black.png',
                          width: 36.w,
                          height: 36.w,
                        );
                      }),
                    ),
                    SizedBox(
                      height: 360.h,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/game_background.png',
                                width: double.infinity,
                                height: 260.h,
                                fit: BoxFit.fill,
                              ),
                              Image.asset(
                                'assets/images/wood.jpg',
                                width: double.infinity,
                                height: 100.h,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                          Positioned(
                            left: 60.w,
                            right: 60.w,
                            top: 40.h,
                            height: 180.h,
                            child: gameState.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : AutoSizeText(
                                    gameState.currentQuestion?.definition ?? '',
                                    textAlign: TextAlign.center,
                                    minFontSize: 16.sp,
                                    maxFontSize: 24.sp,
                                    stepGranularity: 1.sp,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 8,
                                    wrapWords: true,
                                    textScaleFactor: 1.0,
                                    style: GoogleFonts.frederickaTheGreat(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 10.w,
                            child: GestureDetector(
                              onTap: gameState.isLoading ||
                                      gameState.currentQuestion == null
                                  ? null
                                  : _speakWord,
                              child: Image.asset(
                                gameState.hasAnswered
                                    ? (gameState.isCorrect
                                          ? 'assets/images/proud_wiz.png'
                                          : 'assets/images/sad_wiz.png')
                                    : 'assets/images/regular_wiz.png',
                                width: 120.w,
                                height: 200.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // 👇 Hidden text field (still hidden, but now keyboard-aware)
                    SizedBox(
                      height: 0,
                      child: Opacity(
                        opacity: 0,
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          maxLength: inputMaxLength,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                          enableSuggestions: false,
                          autocorrect:
                              false, // 👈 Prevent autocorrect interference
                          onChanged: (value) {
                            setState(() {});

                            String effective = value;
                            if (hintIndex != null && word.isNotEmpty) {
                              final h = hintIndex;
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
                                Future.delayed(
                                  const Duration(milliseconds: 800),
                                  () {
                                    if (!mounted) return;
                                    _controller.clear();
                                    context.read<GameState>().loadQuestion();
                                    _focusNode.requestFocus();
                                  },
                                );
                              } else {
                                Future.delayed(
                                  const Duration(milliseconds: 600),
                                  () {
                                    if (!mounted) return;
                                    _controller.clear();
                                    setState(() {});
                                    if (context.read<GameState>().lives <= 0) {
                                      _showGameOver();
                                    } else {
                                      _focusNode.requestFocus();
                                    }
                                  },
                                );
                              }
                            }
                          },
                          decoration: const InputDecoration(counterText: ''),
                        ),
                      ),
                    ),

                    // 👇 Letter tiles - now tracked with GlobalKey for scrolling
                    Padding(
                      key:
                          _tilesKey, // 👈 Track this widget for keyboard scrolling
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: GestureDetector(
                        onTap: () => _restoreKeyboardFocus(),
                        child: Row(
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
                              width: tileSize,
                              height: tileSize,
                              margin: EdgeInsets.all(
                                (tileSize * 0.08).clamp(2.0, 5.0),
                              ),
                              decoration: BoxDecoration(
                                color: tileColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    displayLetter,
                                    style: TextStyle(
                                      fontSize: tileFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
