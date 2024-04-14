import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.otherUserId});
  final String otherUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ChatRoom'),
        ),
        body: Column(
          children: [
            Expanded(child: ChatMessages(otherUserId: otherUserId)),
            NewMessage(otherUserId: otherUserId),
          ],
        ));
  }
}
