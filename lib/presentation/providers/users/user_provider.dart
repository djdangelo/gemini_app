import 'package:flutter_chat_types/flutter_chat_types.dart'
    as flutter_chat_types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
flutter_chat_types.User geminiUser(Ref ref) {
  const geminiUser = flutter_chat_types.User(
    id: 'id_user',
    firstName: 'Gimini',
  );
  return geminiUser;
}

@riverpod
flutter_chat_types.User user(Ref ref) {
  const user = flutter_chat_types.User(
    id: 'id_user',
    firstName: 'Dangelo',
    lastName: 'Aguilar',
  );
  return user;
}
