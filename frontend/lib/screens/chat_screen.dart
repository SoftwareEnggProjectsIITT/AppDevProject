import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/models/chat.dart';
import 'package:frontend/services/get_reply.dart';
import 'package:frontend/services/manage_messages.dart';
import 'package:frontend/widgets/message_box.dart';
import 'package:frontend/widgets/reply.dart';
import 'package:frontend/widgets/reply_loader.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isAiResponding = false;
  void send(String text) async {
    if (text.trim().isEmpty) return;
    sendMessage(widget.conversationId, text, "user");
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
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: getConversationTitle(widget.conversationId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            }
            if (snapshot.hasError) {
              return const Text("Error");
            }
            return Text(snapshot.data ?? "Untitled");
          },
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
            stream: getMessages(widget.conversationId),
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
                  return Container(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    child: Center(
                      child: Text(
                        "What's in your mind today?",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }

              final itemCount = allMessages.length + (isAiResponding ? 1 : 0);

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (isAiResponding && index == 0) {
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: ReplyLoader(),
                      );
                    }
                  final offset = isAiResponding ? 1 : 0;
                  final msg =
                  allMessages[allMessages.length - 1 - (index - offset)];
                  final isUser = msg.sender == 'user';

                  return Align(
                    alignment: isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                    child: isUser
                    ? Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primaryContainer
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
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
      ),
    );
  }
}
