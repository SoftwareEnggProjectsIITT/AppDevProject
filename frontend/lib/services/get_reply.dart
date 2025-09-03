import 'package:frontend/services/manage_messages.dart';

Future<String> getReply() async {
  var reply;
  // The Duration object specifies the delay
  await Future.delayed(Duration(seconds: 2), () {
    reply = "I am sorry but I don't know the answer of this question.";
  });

  sendMessage(reply, "ai");
  return reply;
}
