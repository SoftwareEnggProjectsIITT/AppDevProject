import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/services/manage_messages.dart';
import 'package:frontend/widgets/message_box.dart';
import 'package:frontend/widgets/reply.dart';

class ChatbotPage extends ConsumerWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: getMessages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No messages yet"));
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[docs.length - 1 - index];
                  final data = doc.data() as Map<String, dynamic>;
                  final msg = data['text'] ?? '';
                  final sender = data['sender'] ?? 'unknown';

                  final isUser = sender == 'user';

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: isUser
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 48, 143, 51),
                                Color.fromARGB(255, 48, 143, 51),
                              ]),
                            ),
                            child: Text(msg,
                                style: const TextStyle(color: Colors.white)),
                          )
                        : Reply(reply: msg),
                  );
                },
              );
            },
          ),
        ),
        MessageBox(
          onSend: (text) {
            if (text.trim().isNotEmpty) {
              sendMessage(text, 'user');
            }
          },
        ),
      ],
    );
  }
}
