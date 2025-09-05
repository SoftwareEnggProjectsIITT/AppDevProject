import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // IMPORTANT: Replace this placeholder with your actual API key
  // You can get one from Google AI Studio: https://aistudio.google.com/app/apikey
  final String apiKey = "AIzaSyDP9jQN9apO9nH-e8i5JnVxLSmA3FaOGAM";
  final String dataUrl = "https://www.indiacode.nic.in/";
  final String systemPrompt = "";
  Future<String> getReply(String prompt) async {
    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent");
     final headers = {
    "Content-Type": "application/json",
    "X-goog-api-key": apiKey,
  };
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["candidates"][0]["content"]["parts"][0]["text"];
        return reply;
      } else {
        // Log the full response body for better debugging
        return ("Failed to get reply: ${response.statusCode} - ${response.body}");
        
      }
    } catch (e) {
      // Catch any network or parsing errors
      return ("An error occurred: $e");
    }
  }
}
