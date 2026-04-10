import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:brain_blitz/state/game_state.dart';
import 'package:brain_blitz/screens/login_screen.dart';
import 'package:brain_blitz/screens/home_screen.dart';
import 'package:brain_blitz/services/bgm_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameState(),
      child: const BrainBlitzApp(),
    ),
  );
}

class BrainBlitzApp extends StatefulWidget {
  const BrainBlitzApp({super.key});

  @override
  State<BrainBlitzApp> createState() => _BrainBlitzAppState();
}

class _BrainBlitzAppState extends State<BrainBlitzApp> {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      BgmService.instance.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF4B0082)),
      builder: (context, child) => Listener(
        onPointerDown: (_) {
          if (kIsWeb && !BgmService.instance.isStarted) {
            BgmService.instance.start();
          }
        },
        child: child,
      ),
      home: const LoginScreen(),
      routes: {'/home': (_) => const HomeScreen()},
    );
  }
}
