import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/chat.dart';
import 'package:frontend/services/get_reply.dart';
import 'package:frontend/services/manage_messages.dart';
import 'package:frontend/widgets/message_box.dart';
import 'package:frontend/widgets/reply.dart';
import 'package:frontend/widgets/reply_loader.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  bool isAiResponding = false;

  void send(String text) async {
    if (text.trim().isEmpty) return;
    sendMessage(text, "user");
    setState(() {
      isAiResponding = true;
    });
    await getReply(text);
    setState(() {
      isAiResponding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: getMessages(),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];
              final allMessages = docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ChatMessage(
                  text: data['text'] ?? '',
                  sender: data['sender'] ?? 'unknown',
                );
              }).toList();

              if (allMessages.isEmpty) {
                return const Center(
                  child: Text(
                    "What's in your mind today?",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                );
              }

              final itemCount = allMessages.length + (isAiResponding ? 1 : 0);

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  // if loader is shown, show it as the newest (index==0)
                  if (isAiResponding && index == 0) {
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: ReplyLoader(),
                    );
                  }
                  final offset = isAiResponding ? 1 : 0;
                  final msg = allMessages[allMessages.length - 1 - (index - offset)];
                  final isUser = msg.sender == 'user';

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: isUser
                        ? Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 48, 143, 51),
                                  Color.fromARGB(255, 48, 143, 51),
                                ],
                              ),
                            ),
                            child: Text(
                              msg.text,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : Reply(reply: msg.text),
                  );
                },
              );
            },
          ),
        ),
        MessageBox(
          isActive: !isAiResponding,
          onSend: (text) {
            send(text);
          },
        ),
      ],
    );
  }
}
