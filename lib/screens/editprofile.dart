import 'package:chat_app/widgets/rename.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Color warningColor = const Color.fromARGB(255, 181, 20, 9);

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Column(children: [
        RenameField(),
      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: _logoutButton(context),
      ),
    );
  }
}

Widget _logoutButton(BuildContext context) {
  return TextButton.icon(
    label: Text(
      'Logout',
      style: TextStyle(color: warningColor),
    ),
    icon: Icon(
      Icons.logout,
      color: warningColor,
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[700]),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: Text(
                'Logout',
                style: TextStyle(color: warningColor),
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
