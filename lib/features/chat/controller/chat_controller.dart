import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/common/enums/message_enum.dart';
import 'package:messenger/common/providers/message_reply_provider.dart';
import 'package:messenger/features/auth/controller/auth_controller.dart';
import 'package:messenger/features/chat/repository/chat_repository.dart';
import 'package:messenger/models/chat_contact.dart';
import 'package:messenger/models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> getChatMessages(String receiverUserId) {
    return chatRepository.getChatMessages(receiverUserId);
  }

  void sendTextMessage(
      BuildContext context, String text, String receiverUserId) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUser: value!,
            messageReply: messageReply));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(BuildContext context, File file, String receiverUserId,
      MessageEnum messageEnum) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: receiverUserId,
            senderUserData: value!,
            ref: ref,
            messageEnum: messageEnum,
            messageReply: messageReply));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen(
      BuildContext context, String receiverUserId, String messageId) {
    chatRepository.setChatMessageSeen(context, receiverUserId, messageId);
  }
}
