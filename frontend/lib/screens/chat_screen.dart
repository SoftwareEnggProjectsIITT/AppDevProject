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
  final ScrollController _scrollController = ScrollController();
  bool _showBackToRecentButton = false;

  String? _conversationTitle;

  Future<void> _loadConversationTitle() async {
    final title = await getConversationTitle(widget.conversationId);
    setState(() {
      _conversationTitle = title ?? "Untitled";
    });
  }

  @override
  void initState() {
    super.initState();
    _loadConversationTitle();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300) {
        if (!_showBackToRecentButton) {
          setState(() => _showBackToRecentButton = true);
        }
      } else {
        if (_showBackToRecentButton) {
          setState(() => _showBackToRecentButton = false);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToRecent() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

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
      title: Text(_conversationTitle ?? "Loading..."),
    ),
    body: Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  
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
                        color: Theme.of(context).colorScheme.surfaceContainerHigh,
                        child: const Center(
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
                
                    final itemCount =
                        allMessages.length + (isAiResponding ? 1 : 0);
                
                    return ListView.builder(
                      controller: _scrollController,
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
                        final msg = allMessages[
                            allMessages.length - 1 - (index - offset)];
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
            ),
            MessageBox(
              isActive: !isAiResponding,
              onSend: (text) {
                send(text);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
        if (_showBackToRecentButton)
          Positioned(
            bottom: 75,
            right: 10,
            child: Center(
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: _scrollToRecent,
                child: const Icon(Icons.arrow_downward, size: 20),
              ),
            ),
          ),
      ],
    ),
  );
}
}
