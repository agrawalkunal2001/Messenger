import 'package:flutter/material.dart';
import 'package:messenger/colors.dart';
import 'package:messenger/info.dart';
import 'package:messenger/widgets/chat_list.dart';

class MobileChatScreen extends StatelessWidget {
  const MobileChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(info[0]['name'].toString()),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const Expanded(
            child: ChatList(),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.88,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: mobileChatBoxColor,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 17),
                        child: Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const <Widget>[
                            Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                            Icon(
                              Icons.currency_rupee,
                              color: Colors.grey,
                            ),
                            Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      hintText: "Message",
                      hintStyle: const TextStyle(fontSize: 15),
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
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.mic,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
