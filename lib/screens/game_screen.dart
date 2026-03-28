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
                  'LEVEL 1',
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
                  // Chalkboard
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
                  // Definition text on chalkboard
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
                  // Wizard overlapping chalkboard bottom-left
                  Positioned(
                    bottom: 0,
                    left: 20,
                    child: Image.asset(
                      'assets/images/regular_wiz.png',
                      width: 120,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Letter tiles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                gameState.currentQuestion?.word.length ?? 0,
                (_) => Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
