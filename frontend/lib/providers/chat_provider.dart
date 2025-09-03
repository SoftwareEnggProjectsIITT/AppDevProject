import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage {
  final String text;
  final String sender;
  final bool isLoading;

  ChatMessage({
    required this.text,
    required this.sender,
    this.isLoading = false,
  });

  ChatMessage copyWith({String? text, String? sender, bool? isLoading}) {
    return ChatMessage(
      text: text ?? this.text,
      sender: sender ?? this.sender,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]);

  void addMessage(ChatMessage msg) {
    state = [...state, msg];
  }

  void replaceLoadingMessage(String newText) {
    state = [
      for (final msg in state)
        if (msg.isLoading)
          msg.copyWith(text: newText, isLoading: false)
        else
          msg,
    ];
  }

  void clear() {
    state = [];
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref,) {
  return ChatNotifier();
});
