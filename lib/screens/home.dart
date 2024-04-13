import 'package:chat_app/screens/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Home Page'), actions: [_logoutButton(context)]),
      body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Container(
              height: double.maxFinite,
            ),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF559BCF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(200, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => ChatScreen()));
                      },
                      child: const Text(
                        'Chat Room',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ]),
    );
  }
}

Widget _logoutButton(BuildContext context) {
  return IconButton(
    icon: Icon(
      Icons.logout,
      color: Theme.of(context).colorScheme.primary,
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
