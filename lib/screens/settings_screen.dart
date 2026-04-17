import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brain_blitz/services/bgm_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _musicEnabled;

  @override
  void initState() {
    super.initState();
    _musicEnabled = BgmService.instance.isStarted;
  }

  void _signOut(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> _toggleMusic(bool value) async {
    setState(() => _musicEnabled = value);
    if (value) {
      await BgmService.instance.start();
    } else {
      await BgmService.instance.stop();
    }
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Sign Out',
            textAlign: TextAlign.center,
            style: GoogleFonts.pressStart2p(
              fontSize: 12,
              color: Colors.blue[900],
            ),
          ),
          content: Text(
            'Are you sure?',
            textAlign: TextAlign.center,
            style: GoogleFonts.pressStart2p(
              fontSize: 10,
              color: Colors.blue[900],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.pressStart2p(
                  fontSize: 10,
                  color: Colors.blue[900],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _signOut(context);
              },
              child: Text(
                'Sign Out',
                style: GoogleFonts.pressStart2p(
                  fontSize: 10,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B0082),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 500,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'SETTINGS',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 22,
                      color: Colors.orange,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Play Music',
                                style: GoogleFonts.pressStart2p(
                                  fontSize: 11,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                            Switch(
                              value: _musicEnabled,
                              activeColor: Colors.blue[900],
                              onChanged: _toggleMusic,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showSignOutDialog(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.exit_to_app,
                                  color: Colors.blue[900],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Sign Out',
                                  style: GoogleFonts.pressStart2p(
                                    fontSize: 11,
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
