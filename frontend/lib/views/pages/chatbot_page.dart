import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            color: Colors.pink,
            child: const Center(
              child: Text(
                'Chatbot Page',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            color: Colors.indigo,
            child: const Center(
              child: Text(
                'Talk to our Chatbot!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            color: Colors.cyan,
            child: const Center(
              child: Text(
                'Get instant help and support.',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ],
      )
    );
  }
}
