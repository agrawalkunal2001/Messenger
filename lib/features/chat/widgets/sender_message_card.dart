import 'package:flutter/material.dart';
import 'package:messenger/colors.dart';
import 'package:messenger/common/enums/message_enum.dart';
import 'package:messenger/features/chat/widgets/display_text_image_gif.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String time;
  final MessageEnum type;
  const SenderMessageCard(
      {Key? key, required this.message, required this.time, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: senderMessageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: type == MessageEnum.text
                    ? const EdgeInsets.only(
                        left: 10, right: 30, top: 5, bottom: 20)
                    : const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 25),
                child: DisplayTextImageGIF(message: message, type: type),
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Row(
                  children: <Widget>[
                    Text(
                      time,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white60),
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
    );
  }
}
