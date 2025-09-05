import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/notifiers.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 96, 59, 181),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(25, 5, 99, 125),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const FirebaseAuthWrapper(),
    );
  }
}

class FirebaseAuthWrapper extends StatefulWidget {
  const FirebaseAuthWrapper({super.key});

  @override
  State<FirebaseAuthWrapper> createState() => _FirebaseAuthWrapperState();
}

class _FirebaseAuthWrapperState extends State<FirebaseAuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Keep userNotifier in sync with Firebase user changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      userNotifier.value = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<User?>(
      valueListenable: userNotifier,
      builder: (context, user, _) {
        if (user == null) {
          return const LoginScreen();
        }
        return const WidgetTree();
      },
    );
  }
}
