import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendMessage(String text, String sender) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final chatRef = FirebaseFirestore.instance
      .collection('chats')
      .doc(user.uid)
      .collection('messages');

  await chatRef.add({
    'sender': sender,
    'text': text,
    'timestamp': FieldValue.serverTimestamp(),
  });
}

Stream<QuerySnapshot> getMessages() {
  final user = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance
      .collection('chats')
      .doc(user!.uid)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots();
}
