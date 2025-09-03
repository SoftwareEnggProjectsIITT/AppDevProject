import 'package:frontend/services/manage_messages.dart';

Future<String> getReply(String query) async {
  var reply;
  // The Duration object specifies the delay
  await Future.delayed(Duration(seconds: 5), () {
    reply = "I am sorry but I don't know the answer of $query.";
  });

  sendMessage(reply, "ai");
  return reply;
}
