import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/common/enums/message_enum.dart';
import 'package:messenger/common/repositories/common_firebase_storage_repository.dart';
import 'package:messenger/common/utils/utils.dart';
import 'package:messenger/models/chat_contact.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/models/user_model.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepository({required this.auth, required this.firestore});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection("Users")
        .doc(auth.currentUser!.uid)
        .collection("Chats")
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];

      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection("Users")
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatMessages(String receiverUserId) {
    return firestore
        .collection("Users")
        .doc(auth.currentUser!.uid)
        .collection("Chats")
        .doc(receiverUserId)
        .collection("Messages")
        .orderBy("timeSent")
        .snapshots()
        .map((event) {
      List<Message> messages = [];

      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactsSubCollection(
      UserModel senderUserData,
      UserModel receiverUserData,
      String text,
      DateTime timeSent,
      String receiverUserId) async {
    // Show the last message on contacts list screen
    // Users->receiverId->chats->current user Id->store message
    var receiverChatContact = ChatContact(
        // To be shown to receiver in their chat contacts screen
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection("Users")
        .doc(receiverUserId)
        .collection("Chats")
        .doc(senderUserData.uid)
        .set(receiverChatContact.toMap());
    // Users->current user Id->chats->receiverId->store message
    var senderChatContact = ChatContact(
        // To be shown to sender in their chat contacts screen
        name: receiverUserData.name,
        profilePic: receiverUserData.profilePic,
        contactId: receiverUserId,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection("Users")
        .doc(senderUserData.uid)
        .collection("Chats")
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubCollection(
      {required String receiverUserId,
      required String text,
      required DateTime timeSent,
      required String messageId,
      required String userName,
      required String receiverUserName,
      required MessageEnum messageType}) async {
    final message = Message(
        senderId: auth.currentUser!.uid,
        receiverId: receiverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false);
    // Users->senderId->chats->receiverId->messages->messageId->store message
    await firestore
        .collection("Users")
        .doc(auth.currentUser!.uid)
        .collection("Chats")
        .doc(receiverUserId)
        .collection("Messages")
        .doc(messageId)
        .set(message.toMap());
    // Users->receiverId->senderId->messages->messageId->store message
    await firestore
        .collection("Users")
        .doc(receiverUserId)
        .collection("Chats")
        .doc(auth.currentUser!.uid)
        .collection("Messages")
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String receiverUserId,
      required UserModel senderUser}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection("Users").doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactsSubCollection(
          senderUser, receiverUserData, text, timeSent, receiverUserId);

      _saveMessageToMessageSubCollection(
          receiverUserId: receiverUserId,
          text: text,
          timeSent: timeSent,
          messageId: messageId,
          messageType: MessageEnum.text,
          userName: senderUser.name,
          receiverUserName: receiverUserData.name);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String receiverUserId,
      required UserModel senderUserData,
      required ProviderRef ref,
      required MessageEnum messageEnum}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String url = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              "Chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId",
              file);

      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection("Users").doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactSubMessage;
      switch (messageEnum) {
        case MessageEnum.image:
          contactSubMessage = "📷 Photo";
          break;
        case MessageEnum.video:
          contactSubMessage = "📸 Video";
          break;
        case MessageEnum.audio:
          contactSubMessage = "🔉 Audio";
          break;
        case MessageEnum.gif:
          contactSubMessage = "GIF";
          break;
        default:
          contactSubMessage = "GIF";
      }

      _saveDataToContactsSubCollection(senderUserData, receiverUserData,
          contactSubMessage, timeSent, receiverUserId);

      _saveMessageToMessageSubCollection(
          receiverUserId: receiverUserId,
          text: url,
          timeSent: timeSent,
          messageId: messageId,
          userName: senderUserData.name,
          receiverUserName: receiverUserData.name,
          messageType: messageEnum);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}