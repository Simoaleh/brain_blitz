import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brain_blitz/state/game_state.dart';
import 'package:brain_blitz/screens/login_screen.dart';
import 'package:brain_blitz/screens/home_screen.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => GameState(),
    child: const BrainBlitzApp(),
  ),
);

class BrainBlitzApp extends StatelessWidget {
  const BrainBlitzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF4B0082)),
      home: LoginScreen(),
      routes: {'/home': (_) => const HomeScreen()},
    );
  }
}
