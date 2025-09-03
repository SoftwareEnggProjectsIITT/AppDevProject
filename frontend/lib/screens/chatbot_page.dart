import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/providers/chat_provider.dart';
import 'package:frontend/services/get_reply.dart';
import 'package:frontend/services/manage_messages.dart';
import 'package:frontend/widgets/message_box.dart';
import 'package:frontend/widgets/reply.dart';
import 'package:frontend/widgets/reply_loader.dart';

class ChatbotPage extends ConsumerWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localMessages = ref.watch(chatProvider);
    final isAiResponding = localMessages.any((msg) => msg.isLoading);
    void send(text) async {
      if (text.trim().isNotEmpty) {
        ref
            .read(chatProvider.notifier)
            .addMessage(ChatMessage(text: text, sender: 'user'));
        ref
            .read(chatProvider.notifier)
            .addMessage(ChatMessage(text: '', sender: 'ai', isLoading: true));
        sendMessage(text, 'user');
        
        final reply = await getReply();
        ref
            .read(chatProvider.notifier).replaceLoadingMessage(reply);
      }
    }

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: getMessages(),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];

              // Convert Firestore docs into ChatMessage
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

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: allMessages.length,
                itemBuilder: (context, index) {
                  final msg = allMessages[allMessages.length - 1 - index];
                  final isUser = msg.sender == 'user';

                  if (msg.isLoading) {
                    // Loader bubble for AI
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: ReplyLoader(),
                    );
                  }

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