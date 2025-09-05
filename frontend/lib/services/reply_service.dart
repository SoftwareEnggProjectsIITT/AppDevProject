import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = "AIzaSyDP9jQN9apO9nH-e8i5JnVxLSmA3FaOGAM";
  final String systemPromptWithoutError = "Convert this text into markdown without changing its contents.\n\n";
  final String systemPromptWithError = "Answer this with respect to indian laws and rules only.\n\n";

  Future<String> getData(String query) async {
    var request = http.Request(
      'POST',
      Uri.parse(
        'https://appdevproject-umx9.onrender.com/chats/ask_question?query=$query',
      ),
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);
      return await getReply(data['message'], systemPromptWithoutError);
    } else if(response.statusCode == 200){
      return await getReply(query, systemPromptWithError);
    }
    else {
      return response.reasonPhrase ?? "Unknown error";
    }
  }

  Future<String> getReply(String prompt, String systemPrompt) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent",
    );
    final headers = {
      "Content-Type": "application/json",
      "X-goog-api-key": apiKey,
    };
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": systemPrompt + prompt},
          ],
        },
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final reply = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];
        return reply ?? "No reply from Gemini";
      } else {
        return ("Failed to get reply: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      return ("An error occurred: $e");
    }
  }
}
