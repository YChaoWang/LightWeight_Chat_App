import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/editprofile.dart';
import 'package:chat_app/widgets/allusers.dart';
import 'package:chat_app/widgets/rename.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Text('Home Page'),
            _editProfileButton(context),
          ])),
      body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Container(
              child: AllUsers(),
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
                  const Text('Chat with users above?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                  const SizedBox(height: 20),
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
                        'Join',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ]),
    );
  }
}

Widget _editProfileButton(BuildContext context) {
  return IconButton(
    icon: Icon(
      Icons.person,
      size: 30,
    ),
    onPressed: () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => EditProfileScreen()));
      // Navigator.of(context).pushNamed(EditProfileScreen.routeName);
    },
  );
}
