import 'package:flutter/material.dart';
import 'package:brain_blitz/widgets/menu_button.dart';
import 'package:brain_blitz/screens/leaderboards.dart';
import 'package:brain_blitz/screens/category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 350, height: 350),
              const SizedBox(height: 40),
              const SizedBox(height: 80),
              MenuButton(
                label: 'Singleplayer',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CategoryScreen()),
                ),
              ),
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
