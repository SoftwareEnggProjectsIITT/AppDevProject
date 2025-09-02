import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/widget_tree.dart';
import 'package:frontend/models/auth.dart';
import 'package:frontend/providers/notifiers.dart';
import 'package:frontend/widget_tree.dart';
import 'package:frontend/widgets/login_page_builder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Auth _auth = Auth();
  bool _isLoading = false;

  /// Handles the Google Sign-in process and navigates to the next screen.
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _auth.signInWithGoogle();
      if (user != null) {
        userNotifier.value = user;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const WidgetTree(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Sign-in failed or was cancelled.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Authentication failed")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
            children: [
              LoginPageBuilder(),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  onPressed:_isLoading ? null : _handleGoogleSignIn,
                  icon: Image.asset('assets/images/google_logo.png', height: 24,),
                  label: const Text("Sign in with Google"),
                ),
              ),
            ],
          )
      );
  }
}
