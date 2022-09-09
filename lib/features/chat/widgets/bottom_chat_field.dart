import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:messenger/colors.dart';
import 'package:messenger/common/enums/message_enum.dart';
import 'package:messenger/common/providers/message_reply_provider.dart';
import 'package:messenger/common/utils/utils.dart';
import 'package:messenger/features/chat/controller/chat_controller.dart';
import 'package:messenger/features/chat/widgets/message_reply_preview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUseriD;
  const BottomChatField({
    required this.receiverUseriD,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Mic permission denied!");
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, messageController.text.trim(), widget.receiverUseriD);
      setState(() {
        messageController.text = '';
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = "${tempDir.path}/flutter_sound.aac";
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.receiverUseriD, messageEnum);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void showEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      hideEmojiContainer();
      showKeyboard();
    } else {
      showEmojiContainer();
      hideKeyboard();
    }
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
    focusNode.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessaeReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            showEmojiKeyboardContainer();
                          },
                          icon: Icon(Icons.emoji_emotions),
                          color: Colors.grey,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.gif,
                            size: 35,
                          ),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            selectVideo();
                          },
                          icon: Icon(Icons.attach_file),
                          color: Colors.grey,
                        ),
                        IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: Icon(Icons.camera_alt),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  hintText: "Message",
                  hintStyle: const TextStyle(fontSize: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, right: 5, left: 2),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFF128C7E),
                child: GestureDetector(
                  onTap: () {
                    sendTextMessage();
                  },
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 320,
                child: EmojiPicker(onEmojiSelected: ((category, emoji) {
                  messageController.text = messageController.text + emoji.emoji;
                  if (!isShowSendButton) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  }
                })),
              )
            : const SizedBox(),
      ],
    );
  }
}
