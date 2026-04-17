import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brain_blitz/services/bgm_service.dart';
import 'login_screen.dart';
import 'profile_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _musicEnabled;
  late bool _notificationsEnabled;
  late double _musicVolume;

  @override
  void initState() {
    super.initState();
    _musicEnabled = BgmService.instance.isStarted;
    _musicVolume = BgmService.instance.currentVolume;
    _notificationsEnabled = true;
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
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.orange,
                  size: 24.sp,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Container(
                width: 500,
                padding: EdgeInsets.symmetric(vertical: 18.h),
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
                      fontSize: 22.sp,
                      color: Colors.orange,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Button
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      width: 300.w,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfileSettingsScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.blue[900],
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'PROFILE',
                                  style: GoogleFonts.pressStart2p(
                                    fontSize: 11.sp,
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Music Toggle
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      width: 300.w,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'PLAY MUSIC',
                                style: GoogleFonts.pressStart2p(
                                  fontSize: 11.sp,
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

                    // Music Volume Slider
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      width: 300.w,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'VOLUME',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 11.sp,
                                color: Colors.blue[900],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: _musicVolume,
                                    min: 0.0,
                                    max: 1.0,
                                    activeColor: Colors.blue[900],
                                    inactiveColor: Colors.blue[200],
                                    onChanged: _musicEnabled
                                        ? (value) {
                                            setState(() {
                                              _musicVolume = value;
                                            });
                                            BgmService.instance
                                                .setVolume(value);
                                          }
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${(_musicVolume * 100).toStringAsFixed(0)}%',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 9.sp,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Notifications Toggle
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      width: 300.w,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'NOTIFICATIONS',
                                style: GoogleFonts.pressStart2p(
                                  fontSize: 11.sp,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                            Switch(
                              value: _notificationsEnabled,
                              activeColor: Colors.blue[900],
                              onChanged: (value) {
                                setState(() => _notificationsEnabled = value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Sign Out Button
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      width: 300.w,
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.exit_to_app,
                                  color: Colors.blue[900],
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'SIGN OUT',
                                  style: GoogleFonts.pressStart2p(
                                    fontSize: 11.sp,
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
