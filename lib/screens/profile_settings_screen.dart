import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:brain_blitz/state/user_state.dart';
import 'package:brain_blitz/services/account_service.dart';
import 'login_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    // Load current user data
    final currentUser = AccountService.instance.getCurrentUser();
    _nameController = TextEditingController(
      text: currentUser?['name'] ?? 'Player',
    );
    _usernameController = TextEditingController(
      text: currentUser?['username'] ?? 'player123',
    );
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'DELETE ACCOUNT',
              textAlign: TextAlign.center,
              style: GoogleFonts.pressStart2p(
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ),
          ),
          content: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'This cannot be undone!',
              textAlign: TextAlign.center,
              style: GoogleFonts.pressStart2p(
                fontSize: 10.sp,
                color: Colors.white,
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CANCEL',
                style: GoogleFonts.pressStart2p(
                  fontSize: 10.sp,
                  color: Colors.orange,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: Text(
                'DELETE',
                style: GoogleFonts.pressStart2p(
                  fontSize: 10.sp,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.pressStart2p(
                fontSize: 12.sp,
                color: Colors.green,
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: GoogleFonts.pressStart2p(
                  fontSize: 10.sp,
                  color: Colors.orange,
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
                    'PROFILE',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 22.sp,
                      color: Colors.orange,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    // Name Field
                    _buildTextField('NAME', _nameController),
                    SizedBox(height: 16.h),

                    // Username Field
                    _buildTextField('USERNAME', _usernameController),
                    SizedBox(height: 16.h),

                    // Password Field
                    _buildTextField(
                      'NEW PASSWORD',
                      _passwordController,
                      isPassword: true,
                    ),
                    SizedBox(height: 16.h),

                    // Confirm Password Field
                    _buildTextField(
                      'CONFIRM PASSWORD',
                      _confirmPasswordController,
                      isPassword: true,
                    ),
                    SizedBox(height: 24.h),

                    // Save Button
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (_passwordController.text !=
                                    _confirmPasswordController.text &&
                                _passwordController.text.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Passwords do not match',
                                    style: GoogleFonts.pressStart2p(
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            // Update AccountService
                            AccountService.instance.updateUser(
                              _nameController.text,
                              _usernameController.text,
                              _passwordController.text,
                            );
                            // Update UserState
                            context.read<UserState>().setUser(
                              name: _nameController.text,
                              username: _usernameController.text,
                            );
                            _showSuccessDialog('CHANGES SAVED!');
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
                                  Icons.save,
                                  color: Colors.blue[900],
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'SAVE CHANGES',
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
                    SizedBox(height: 16.h),

                    // Delete Account Button
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showDeleteAccountDialog(context),
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
                                  Icons.delete_forever,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'DELETE ACCOUNT',
                                  style: GoogleFonts.pressStart2p(
                                    fontSize: 11.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.pressStart2p(
            fontSize: 10.sp,
            color: Colors.orange,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange, width: 2),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: GoogleFonts.pressStart2p(
              fontSize: 10.sp,
              color: Colors.blue[900],
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              hintText: label,
              hintStyle: GoogleFonts.pressStart2p(
                fontSize: 10.sp,
                color: Colors.blue[900]!.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
