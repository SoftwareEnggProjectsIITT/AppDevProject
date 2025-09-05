import 'package:frontend/providers/notifiers.dart';
import 'package:frontend/services/reply_service.dart';
import 'package:frontend/services/manage_messages.dart';

Future<String> getReply(String query) async {
  final GeminiService geminiService = GeminiService();
  late String reply;
  reply = await geminiService.getData(query);
  await sendMessage(convNotifier.value!, reply, "ai");
  return reply;
}
