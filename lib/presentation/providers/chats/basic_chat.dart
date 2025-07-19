import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:gemini_app/presentation/providers/chats/is_gemini_writing.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'basic_chat.g.dart';

final uuid = Uuid();

@riverpod
class BasicChat extends _$BasicChat {
  @override
  List<Message> build() {
    return [];
  }

  void addMessage({required PartialText partialText, required User user}) {
    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User user) {
    final message = TextMessage(
      author: user,
      id: uuid.v4(),
      text: partialText.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = [message, ...state];
    _geminiTextResponse(partialText.text);
  }

  void _geminiTextResponse(String prompt) async {
    final isGeminiWriting = ref.watch(isGeminiWritingProvider.notifier);
    final geminiUser = ref.watch(geminiUserProvider);

    isGeminiWriting.setIsWriting();
    await Future.delayed(const Duration(seconds: 2));
    isGeminiWriting.setIsNotWriting();
    final message = TextMessage(
      author: geminiUser,
      id: uuid.v4(),
      text: 'HolaMundo',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = [message, ...state];
  }
}
