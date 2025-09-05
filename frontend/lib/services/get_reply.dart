import 'package:frontend/providers/notifiers.dart';
import 'package:frontend/services/manage_messages.dart';

Future<String> getReply(String query) async {
  late String reply;
  await Future.delayed(Duration(seconds: 1), () {
    reply = "I am sorry but I don't know the answer of $query.";
  });

  await sendMessage(convNotifier.value!, reply, "ai");
  return reply;
}
