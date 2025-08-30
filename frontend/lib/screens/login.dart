import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/views/widget_tree.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.trim(),
          password: _password.trim(),
        );
      } else {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _email.trim(),
              password: _password.trim(),
            );

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WidgetTree()),);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Authentication failed")));
    }

    setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png', width: 200,),
                  const SizedBox(height: 20,),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || !value.contains('@') || value.trim().isEmpty) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _email = newValue!;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if(value == null || value.length < 6) {
                        return "Password must be reger at least 6 characters";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _password = newValue!;
                    },
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                      onPressed: _isLoading ? null : () async {
                        await _submit();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 30),
                        padding: EdgeInsets.all(15),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        
                      ),
                      child:_isLoading ? CircularProgressIndicator() : Text(
                        _isLogin ? 'LOGIN' : 'SIGN UP',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700,),
                      ),
                    ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin ? 'Don\'t have an account? ' : 'Already have an account? ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin ? 'Sign Up' : 'Login',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25,),
                  ElevatedButton.icon(
                      onPressed: _isLoading ? null : () {},
                      icon: Image.asset('assets/images/google_logo.png', height: 25,),
                      label: Text(
                        "Sign in with Google",
                        style: TextStyle(fontWeight: FontWeight.w600,),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 30),
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}