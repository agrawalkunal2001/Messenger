import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:messenger/common/widgets/loader.dart';
import 'package:messenger/features/chat/controller/chat_controller.dart';
import 'package:messenger/features/chat/widgets/my_message_card.dart';
import 'package:messenger/features/chat/widgets/sender_message_card.dart';
import 'package:messenger/info.dart';
import 'package:messenger/models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({
    Key? key,
    required this.receiverUserId,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: ref
            .read(chatControllerProvider)
            .getChatMessages(widget.receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          }); // For automatic scrolling on new messages

          return ListView.builder(
            controller: messageController,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);
              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  time: timeSent,
                  type: messageData.type,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                time: timeSent,
                type: messageData.type,
              );
            },
            itemCount: snapshot.data!.length,
          );
        });
  }
}
