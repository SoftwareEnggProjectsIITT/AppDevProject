import 'package:flutter/material.dart';
import 'package:frontend/providers/notifiers.dart';
import 'package:frontend/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/widget_tree.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(), // Here we can use things like userChanges(), 
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(snapshot.data != null)  {
                return const WidgetTree();
              }
              return const LoginScreen();
            }
          ),
        );
      }
    );
  }
}
