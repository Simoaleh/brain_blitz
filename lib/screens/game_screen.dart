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
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/game_background.png',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                gameState.isLoading
                    ? const CircularProgressIndicator()
                    : Positioned(
                        left: 60,
                        right: 60,
                        top: 50,
                        bottom: 40,
                        child: Text(
                          gameState.currentQuestion?.definition ?? '',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: GoogleFonts.frederickaTheGreat(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ],
            ),
            // letter tiles ...
          ],
        ),
      ),
    );
  }
}
