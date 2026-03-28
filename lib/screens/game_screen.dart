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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GameState>().loadQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // top bar ...
            const SizedBox(height: 40),
            Container(
              height: 400,
              margin: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/game_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: gameState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            gameState.currentQuestion?.definition ?? '',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.frederickaTheGreat(
                              fontSize: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            // letter tiles ...
          ],
        ),
      ),
    );
  }
}
