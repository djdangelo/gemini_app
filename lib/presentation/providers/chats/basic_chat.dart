import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:gemini_app/config/gemini/gemini_impl.dart';
import 'package:gemini_app/presentation/providers/chats/is_gemini_writing.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'basic_chat.g.dart';

final uuid = Uuid();

@riverpod
class BasicChat extends _$BasicChat {
  final gemini = GeminiImpl();
  late User geminiUser;

  @override
  List<Message> build() {
    geminiUser = ref.read(geminiUserProvider);
    return [];
  }

  void addMessage({required PartialText partialText, required User user}) {
    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User user) {
    final message = _createTextMessage(partialText.text, user);
    _geminiTextResponse(partialText.text);
    _setState(message);
  }

  void _geminiTextResponse(String prompt) async {
    _setGeminiWritingStatus(true);
    final response = await gemini.getResponse(prompt);
    _setGeminiWritingStatus(false);
    final message = _createTextMessage(response, geminiUser);
    _setState(message);
  }

  void _setGeminiWritingStatus(bool isWriting) {
    final isGeminiWriting = ref.watch(isGeminiWritingProvider.notifier);
    isWriting
        ? isGeminiWriting.setIsWriting()
        : isGeminiWriting.setIsNotWriting();
  }

  TextMessage _createTextMessage(String textMessage, User author) {
    final message = TextMessage(
      author: author,
      id: uuid.v4(),
      text: textMessage,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    return message;
  }

  void _setState(TextMessage message) {
    state = [message, ...state];
  }
}
