import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_celo_composer/module/custom_widgets/format_date.dart';
import 'package:flutter_celo_composer/module/models/chat_model.dart';
import 'package:flutter_celo_composer/module/services/secure_storage.dart';
import 'package:flutter_celo_composer/module/view/widgets/custom_textfield.dart';
import 'package:flutter_celo_composer/module/view/widgets/message_bubble.dart';
import 'package:flutter_celo_composer/module/view_model/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  String? userAddress;
  TextEditingController textController = TextEditingController();
  List<ChatDetailModel> messages = [
    // Add your messages here, for example:
    // Message('0x123', 'Hello', DateTime.now()),
  ];

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ref.read(celoProvider).fetchChats(context);
      userAddress = await UserSecureStorage().getUserAddress();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: ref.watch(celoProvider).messages.length,
              itemBuilder: (dynamic context, int index) {
                ChatDetailModel message =
                    ref.read(celoProvider).messages[index];
                final bool isMe =
                    message.sender!.toLowerCase() == userAddress?.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: MessageBubble(
                      sender: message.sender ?? '',
                      text: message.content ?? '',
                      date: convertDate(message.timestamp ?? DateTime.now()),
                      isMe: isMe),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: CustomTextField(
                    text: '',
                    maxLines: 3,
                    minLines: 1,
                    hint: 'Type a message',
                    controller: textController,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _sendMessage,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Icon(
                      Icons.send,
                      size: 40,
                      color: Colors.black54,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // This is where you trigger the function to send a message.
      //   },
      //   child: Icon(Icons.send),
      // ),
    );
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    if (textController.text.isNotEmpty) {
      final message = textController.text.trim();
      ref.read(celoProvider).sendChat(userAddress ?? '', message, context);
      textController.clear();
    }
  }
}
