import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class LoginWidget extends StatefulWidget {
  static const String routeName = 'login';
  static const String routePath = '/login';

  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _showSplash = true;
  bool isCreatingAccount = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  void _forgotPassword(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Reset Password'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Enter your email'),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Send Reset Link'),
            onPressed: () async {
              final email = controller.text.trim();
              if (email.isNotEmpty) {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reset link sent to $email')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _signInWithProvider(String providerName) {
    print('Signing in with $providerName...');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: _showSplash
          ? Center(
              child: Image.asset(
                'assets/images/DoorwWay_Splash.gif',
                fit: BoxFit.contain,
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    'assets/images/Clouds_Background_Image.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 30 : 60,
                      vertical: isMobile ? 60 : 80,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Nuvana',
                          style: TextStyle(
                            fontSize: isMobile ? 38 : 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5C6AC4),
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Faith and clarity for the searching soul.',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            color: Colors.orange.shade200,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _forgotPassword(context),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: handle auth based on isCreatingAccount
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              backgroundColor: Color(0xFF5C6AC4),
                            ),
                            child: Text(
                              isCreatingAccount ? 'Create Account' : 'Log In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isCreatingAccount = !isCreatingAccount;
                            });
                          },
                          child: Text(
                            isCreatingAccount
                                ? 'Already have an account? Log in'
                                : 'Don’t have an account? Create one',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton('google_icon.png', 'Google', () => _signInWithProvider('Google')),
                            _buildSocialButton('apple_icon.png', 'Apple', () => _signInWithProvider('Apple')),
                            _buildSocialButton('instagram_icon.png', 'Instagram', () => _signInWithProvider('Instagram')),
                            _buildSocialButton('facebook_icon.png', 'Facebook', () => _signInWithProvider('Facebook')),
                          ],
                        ),
                        SizedBox(height: 30),
                        AnimatedAlign(
                          alignment: Alignment.center,
                          duration: Duration(milliseconds: 800),
                          curve: Curves.easeOutBack,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'Reflect on the Resurrection today — read John 20.',
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                color: Color(0xFF5C6AC4),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSocialButton(String assetName, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/$assetName'),
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
