import 'package:flutter/material.dart';
import 'package:brain_blitz/screens/login_screen.dart';
import 'package:brain_blitz/services/account_service.dart';
import 'package:brain_blitz/widgets/menu_button.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final error = AccountService.instance.register(
      nameController.text.trim(),
      usernameController.text.trim(),
      passwordController.text,
    );
    if (error != null) {
      setState(() => errorMessage = error);
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/wizard_face.png',
                    width: 250,
                    height: 250,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Brain Blitz',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'In-Game Name',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your in-game name',
                    hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                      color: Colors.orange,
                    ),
                    filled: true,
                    fillColor: Colors.white10,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF3A3A3A),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.orange,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your username',
                    hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                      color: Colors.orange,
                    ),
                    filled: true,
                    fillColor: Colors.white10,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF3A3A3A),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.orange,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      size: 20,
                      color: Colors.orange,
                    ),
                    filled: true,
                    fillColor: Colors.white10,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF3A3A3A),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.orange,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    width: 350,
                    child: MenuButton(label: 'Sign Up', onTap: _submit),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
