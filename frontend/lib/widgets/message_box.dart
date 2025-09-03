import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MessageBox extends StatefulWidget {
  final void Function(String) onSend;
  const MessageBox({super.key, required this.onSend});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInput = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _voiceInput = val.recognizedWords;
            _controller.text = _voiceInput;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Ask your query...",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : Colors.grey),
              onPressed: _listen,
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
