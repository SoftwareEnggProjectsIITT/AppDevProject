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
      body: StreamBuilder<QuerySnapshot>(
        stream: getConversations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No conversations yet"));
          }

          final conversations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final convo = conversations[index];
              final conversationId = convo.id;
              final title = convo['title'] ?? "Untitled";
              //final category = convo['category'] ?? "General";
              final category = "General";
              return ConvCard(
                title: title,
                category: category,
                showChat: () => openChat(conversationId),
              );
            },
          );
        },
      ),
    );
  }
}