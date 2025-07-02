import 'package:flutter/material.dart';
import 'package:project_with_gimini/model/message_model.dart';
import 'package:project_with_gimini/view/widget/message_widget.dart';

class ChatBody extends StatefulWidget {
  final List<MessageModel> messages;

  const ChatBody({super.key, required this.messages});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ListView.builder(
        itemCount: widget.messages.length,
        itemBuilder: (contex, index) {
          final data = widget.messages[index];
          return MessageWidget(message: data, isMe: data.isUser);
        },
      ),
    );
  }
}
