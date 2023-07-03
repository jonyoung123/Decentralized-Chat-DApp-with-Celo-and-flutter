import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.text,
    required this.sender,
    required this.date,
    required this.isMe,
    super.key,
  });
  final String sender;
  final String text;
  final String date;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              right: isMe ? 0 : size.width * 0.2,
              left: isMe ? size.width * 0.2 : 0),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(0),
                bottomLeft:
                    isMe ? const Radius.circular(15) : const Radius.circular(0),
                bottomRight:
                    isMe ? const Radius.circular(0) : const Radius.circular(15),
                topRight: const Radius.circular(0)),
            color: isMe ? Colors.blueGrey : Colors.grey,
            child: Padding(
                padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: isMe ? 10 : 20,
                    right: isMe ? 20 : 10),
                child: Column(
                  children: <Widget>[
                    Text(
                      sender,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      text,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isMe ? Colors.white : Colors.white,
                      ),
                    ),
                  ],
                )),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          date,
          style: const TextStyle(fontSize: 13, color: Colors.black45),
        ),
      ],
    );
  }
}
