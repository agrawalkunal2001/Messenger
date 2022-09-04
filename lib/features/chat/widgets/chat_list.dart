import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:messenger/common/widgets/loader.dart';
import 'package:messenger/features/chat/controller/chat_controller.dart';
import 'package:messenger/info.dart';
import 'package:messenger/models/message.dart';
import 'package:messenger/widgets/my_message_card.dart';
import 'package:messenger/widgets/sender_message_card.dart';

class ChatList extends ConsumerWidget {
  final String receiverUserId;
  const ChatList({
    Key? key,
    required this.receiverUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(chatControllerProvider).getChatMessages(receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  time: timeSent,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                time: timeSent,
              );
            },
            itemCount: snapshot.data!.length,
          );
        });
  }
}
