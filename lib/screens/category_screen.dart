import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brain_blitz/widgets/menu_button.dart';
import 'package:brain_blitz/screens/game_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? selectedCategory;

  final List<String> categories = ['Technology', 'Chemistry', 'Programming'];
  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              Text(
                selectedCategory == null
                    ? 'SELECT\nCATEGORY'
                    : 'SELECT\nDIFFICULTY',
                textAlign: TextAlign.center,
                style: GoogleFonts.pressStart2p(
                  fontSize: 24,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 32),
              if (selectedCategory == null) ...[
                ...categories.map(
                  (category) => MenuButton(
                    label: category.toUpperCase(),
                    onTap: () => setState(() => selectedCategory = category),
                  ),
                ),
              ] else ...[
                ...difficulties.map(
                  (difficulty) => MenuButton(
                    label: difficulty.toUpperCase(),
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const GameScreen()),
                      (route) => route.settings.name == '/home',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                MenuButton(
                  label: 'BACK',
                  onTap: () => setState(() => selectedCategory = null),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
