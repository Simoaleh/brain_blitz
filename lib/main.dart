import 'package:flutter/material.dart';
import 'package:brain_blitz/screens/home_screen.dart';

void main() => runApp(const BrainBlitzApp());

class BrainBlitzApp extends StatelessWidget {
  const BrainBlitzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF4B0082)),
      home: const HomeScreen(),
    );
  }
}
