import 'package:flutter/material.dart';
import 'package:frontend/widget_tree.dart';
import 'package:frontend/models/auth.dart';
import 'package:frontend/providers/notifiers.dart';
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
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _auth.signInWithGoogle();

      if (!mounted) return; // check again after await

      if (user != null) {
        userNotifier.value = user;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WidgetTree()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Sign-in failed or was cancelled.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Authentication failed")));
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPageBuilder(
        isLoading: _isLoading,
        handleSignIn: _handleGoogleSignIn,
      ),
    );
  }
}
