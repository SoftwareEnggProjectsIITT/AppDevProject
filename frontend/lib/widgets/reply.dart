import 'package:flutter/material.dart';
import 'package:frontend/models/tts.dart';
import 'package:markdown_widget/markdown_widget.dart';

class Reply extends StatefulWidget {
  const Reply({super.key, required this.reply});

  final String reply;

  @override
  State<Reply> createState() => _ReplyState();
}

class _ReplyState extends State<Reply> {
  Tts? _tts;
  var _isSpeaking = false;

  @override
  void dispose() async {
    super.dispose();
    await _tts!.stop();
  }

  void _toggleSpeech() async {
    if (_isSpeaking) {
      await _tts!.stop();
      setState(() {
        _isSpeaking = false;
      });
    } else {
      setState(() {
        _isSpeaking = true; // mark speaking started
      });
      await _tts!.speak();
    }
  }

  @override
  void initState() {
    super.initState();
    _tts = Tts(text: widget.reply);

    _tts!.fTts.awaitSpeakCompletion(true);

    _tts!.fTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false; // reset when finished
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),

            child: Container(
              margin: EdgeInsets.only(right: 25),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surfaceContainerLow,
              ),
              child: Column(
                children: MarkdownGenerator().buildWidgets(widget.reply),
              ),
            ),
          ),
          IconButton(
            onPressed: _toggleSpeech,
            icon: Icon(
              _isSpeaking ? Icons.pause : Icons.volume_up,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
