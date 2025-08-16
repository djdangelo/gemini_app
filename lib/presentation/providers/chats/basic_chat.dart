import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:gemini_app/config/gemini/gemini_impl.dart';
import 'package:gemini_app/presentation/providers/chats/is_gemini_writing.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';
import 'package:image_picker/image_picker.dart';
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

  void addMessage({
    required PartialText partialText,
    required User user,
    List<XFile> images = const [],
  }) {
    if (images.isNotEmpty) {
      _addTextMessageAndImages(partialText, user, images);
      return;
    }
    ;
    _addTextMessage(partialText, user);
  }

  void _addTextMessage(PartialText partialText, User user) {
    _createTextMessage(partialText.text, user);
    //_geminiTextResponse(partialText.text);
    _geminiTextResponseStream(partialText.text);
  }

  void _addTextMessageAndImages(
      PartialText partialText, User user, List<XFile> images) async {
    for (XFile image in images) {
      _createImageMessage(image, user);
    }
    await Future.delayed(const Duration(milliseconds: 10));
    _createTextMessage(partialText.text, user);
    //_geminiTextResponse(partialText.text);
    _geminiTextResponseStream(partialText.text, images: images);
  }

  void _geminiTextResponse(String prompt) async {
    _setGeminiWritingStatus(true);
    final response = await gemini.getResponse(prompt);
    _setGeminiWritingStatus(false);
    _createTextMessage(response, geminiUser);
  }

  void _geminiTextResponseStream(
    String prompt, {
    List<XFile> images = const [],
  }) {
    _createTextMessage('Gemini esta pensando...', geminiUser);
    gemini.getResponseStream(prompt, files: images).listen((response) {
      if (response.isEmpty) return;
      final updateMessages = [...state];
      final updateMessage =
          (updateMessages.first as TextMessage).copyWith(text: response);
      updateMessages[0] = updateMessage;
      state = updateMessages;
    });
  }

  void _setGeminiWritingStatus(bool isWriting) {
    final isGeminiWriting = ref.watch(isGeminiWritingProvider.notifier);
    isWriting
        ? isGeminiWriting.setIsWriting()
        : isGeminiWriting.setIsNotWriting();
  }

  void _createTextMessage(String textMessage, User author) {
    final message = TextMessage(
      author: author,
      id: uuid.v4(),
      text: textMessage,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    state = [message, ...state];
  }

  void _createImageMessage(XFile image, User author) async {
    final message = ImageMessage(
      author: author,
      id: uuid.v4(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      uri: image.path,
      name: image.name,
      size: await image.length(),
    );
    state = [message, ...state];
  }
}
