import 'package:frontend/services/manage_messages.dart';

Future<void> getReply () async {
  final reply = "Hello World";
  sendMessage(reply, "ai");
}