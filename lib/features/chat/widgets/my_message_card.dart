import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/colors.dart';
import 'package:messenger/common/enums/message_enum.dart';
import 'package:messenger/features/chat/widgets/display_text_image_gif.dart';
import 'package:swipe_to/swipe_to.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String time;
  final MessageEnum type;
  final VoidCallback onSwipeRight;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  const MyMessageCard(
      {Key? key,
      required this.message,
      required this.time,
      required this.type,
      required this.onSwipeRight,
      required this.repliedText,
      required this.username,
      required this.repliedMessageType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onRightSwipe: onSwipeRight,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 10, right: 30, top: 5, bottom: 20)
                      : const EdgeInsets.only(
                          left: 5, right: 5, top: 5, bottom: 25),
                  child: Column(
                    children: [
                      if (isReplying) ...[
                        Text(
                          username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: DisplayTextImageGIF(
                              message: repliedText, type: repliedMessageType),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ], // Cascade operator- If condition only allows one widget. With this operator we can pass many widgets.
                      DisplayTextImageGIF(message: message, type: type),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Row(
                    children: <Widget>[
                      Text(
                        time,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white60),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.done_all,
                        size: 20,
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
