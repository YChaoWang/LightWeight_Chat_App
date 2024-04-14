import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RenameField extends StatefulWidget {
  @override
  _RenameFieldState createState() => _RenameFieldState();
}

class _RenameFieldState extends State<RenameField> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isButtonEnabled = false;
  @override
  void initState() {
    super.initState();
    // 添加文本字段的输入更改监听器
    _usernameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = true; // 更新按鈕的狀態
    });
  }

  void _renameUsername() async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      print(_usernameController.text);
      print(user.email);
      if (user != null) {
        if (_usernameController.text.isNotEmpty &&
            _usernameController.text.trim().length >= 4) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(
            {
              'email': user.email,
              'imageUrl': "",
              'username': _usernameController.text,
            },
          );

          FocusScope.of(context).unfocus();
          _usernameController.clear();

          setState(() {
            _isButtonEnabled = false;
          });
          // Username renamed successfully
          // Do something else, like navigating to another screen
        }
      } else {
        print('No user logged in.');
      }
    } catch (e) {
      // Handle any errors that occur during the renaming process
      print('Error renaming username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Rename and change to anonymous user without avatar?',
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 4),
          TextField(
            onChanged: (value) {
              // 更新按钮的可点击状态
              _updateButtonState();
            },
            controller: _usernameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue, width: 4.0)),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "Enter a new username",
              hintStyle: TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _isButtonEnabled ? _renameUsername : null,
            child: Text('Rename'),
          ),
        ],
      ),
    );
  }
}
