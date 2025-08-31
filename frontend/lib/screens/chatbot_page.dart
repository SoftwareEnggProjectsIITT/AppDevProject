import 'package:flutter/material.dart';
import 'package:frontend/widgets/message_box.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Expanded(child: Container()), // Your chat list here
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MessageBox(
                onSend: (msg) {
                  print("User sent: $msg");
                  // 👉 Save to Firestore or send to AI here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
