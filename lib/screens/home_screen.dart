import 'package:flutter/material.dart';
import 'package:brain_blitz/widgets/menu_button.dart';
import 'package:brain_blitz/screens/game_screen.dart';
import 'package:brain_blitz/screens/leaderboards.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const Text(
                'Brain\nBlitz!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 40),

              // Menu buttons
              MenuButton(
                label: 'SPELLING BEE',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GameScreen()),
                ),
              ),
              MenuButton(label: 'Mathematical', onTap: () {}),
              MenuButton(label: 'Multiplayer', onTap: () {}),
              MenuButton(
                label: 'Leaderboards',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LeaderboardsScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
