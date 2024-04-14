import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key, required this.otherUserId});
  final String otherUserId;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();
    final user = FirebaseAuth.instance.currentUser!; // fetch the current user
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
      'receiverId': widget.otherUserId,
    });
    // send to Firebase
    print(enteredMessage);
  }

  @override
  Widget build(BuildContext context) {
    return widget.otherUserId.isEmpty
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        controller: _messageController,
                        textCapitalization: TextCapitalization.sentences,
                        autocorrect: true,
                        enableSuggestions: true,
                        decoration: InputDecoration(
                          labelText: 'Send a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: IconButton(
                    alignment: Alignment.topCenter,
                    icon: const Icon(
                      Icons.send,
                      size: 26,
                      color: Colors.blue,
                    ),
                    onPressed: _submitMessage,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          );
  }
}
