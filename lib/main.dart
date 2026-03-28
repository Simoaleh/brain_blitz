import 'package:flutter/material.dart';
import 'package:brain_blitz/screens/home_screen.dart';

void main() => runApp(const BrainBlitzApp());

class BrainBlitzApp extends StatelessWidget {
  const BrainBlitzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 62, 17, 77),
      ),
      home: const HomeScreen(),
    );
  }
}
