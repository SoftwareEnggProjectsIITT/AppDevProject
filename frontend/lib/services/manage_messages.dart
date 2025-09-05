import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendMessage(String conversationId, String text, String sender) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final chatRef = FirebaseFirestore.instance
      .collection('chats')
      .doc(user.uid)
      .collection('conversations')
      .doc(conversationId)
      .collection('messages');

  await chatRef.add({
    'sender': sender,
    'text': text,
    'timestamp': FieldValue.serverTimestamp(),
  });
}


Stream<QuerySnapshot> getMessages(String conversationId) {
  final user = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance
      .collection('chats')
      .doc(user!.uid)
      .collection('conversations')
      .doc(conversationId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots();
}

Future<String> createConversation(String title) async {
  final user = FirebaseAuth.instance.currentUser;

  final convoRef = FirebaseFirestore.instance
      .collection('chats')
      .doc(user!.uid)
      .collection('conversations')
      .doc();

  await convoRef.set({
    'title': title,
    'createdAt': FieldValue.serverTimestamp(),
  });

  return convoRef.id;
}

Stream<QuerySnapshot> getConversations() {
  final user = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance
      .collection('chats')
      .doc(user!.uid)
      .collection('conversations')
      .orderBy('createdAt', descending: true)
      .snapshots();
}

Future<String?> getConversationTitle(String conversationId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final convoDoc = await FirebaseFirestore.instance
      .collection('chats')
      .doc(user.uid)
      .collection('conversations')
      .doc(conversationId)
      .get();

  if (convoDoc.exists) {
    return convoDoc.data()?['title'] as String?;
  }
  return null;
}
