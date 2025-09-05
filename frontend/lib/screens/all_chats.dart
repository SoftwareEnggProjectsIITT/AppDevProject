import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/providers/notifiers.dart';
import 'package:frontend/screens/chat_screen.dart';
import 'package:frontend/services/manage_messages.dart';
import 'package:frontend/widgets/conv_card.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  String _searchQuery = "";

  void openChat(String conversationId) {
    convNotifier.value = conversationId;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(conversationId: conversationId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search conversations...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase().trim();
                });
              },
            ),
          ),

          // Conversation list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getConversations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No conversations yet"));
                }

                final conversations = snapshot.data!.docs.where((convo) {
                  final title = (convo['title'] ?? "Untitled").toString().toLowerCase();
                  return title.contains(_searchQuery);
                }).toList();

                if (conversations.isEmpty) {
                  return const Center(child: Text("No matches found"));
                }

                return ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final convo = conversations[index];
                    final conversationId = convo.id;
                    final title = convo['title'] ?? "Untitled";
                    return ConvCard(
                      title: title,
                      showChat: () => openChat(conversationId),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

