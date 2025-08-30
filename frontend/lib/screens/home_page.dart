import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            color: Colors.blue,
            child: const Center(
              child: Text(
                'Home Page',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            color: Colors.green,
            child: const Center(
              child: Text(
                'Welcome to the Home Page!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            color: Colors.orange,
            child: const Center(
              child: Text(
                'Enjoy your stay!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ],
      )
    );
  }
}
