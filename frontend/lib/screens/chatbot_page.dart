import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/widgets/message_box.dart';
import 'package:frontend/widgets/reply.dart';

final messagesProvider = StateProvider<List<String>>((ref) => []);

class ChatbotPage extends ConsumerWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messagesProvider);

    return Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                return Align(
                  alignment: (messages.length - 1 - index).isEven
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: (messages.length - 1 - index).isOdd
                      ? Reply(reply: msg)
                      : Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            const Color.fromARGB(255, 48, 143, 51),
                            const Color.fromARGB(255, 48, 143, 51),
                          ])
                        ),
                        child: Text(msg, style: TextStyle(color: Colors.white),)
                      )
                );
              },
            ),
          ),
          MessageBox(
            onSend: (text) {
              if (text.trim().isNotEmpty) {
                ref.read(messagesProvider.notifier).update((state) => [...state, text]);
              }
            },
          ),
        ],
      );
  }
}
