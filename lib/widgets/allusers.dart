import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllUsers extends StatefulWidget {
  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  String? currentUserID;
  @override
  void initState() {
    super.initState();
    // Get the current user's userID when the widget initializes
    currentUserID = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 1.0),
                //bottom: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            child: Text('All Users')),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // 將快照中的文檔轉換為 Widget 列表
          final users = snapshot.data!.docs;
          final userList = users.map((userDoc) {
            final userData = userDoc.data() as Map<String, dynamic>;
            final username = userData['username'] ?? '';
            final email = userData['email'] ?? '';
            final imageUrl =
                userData['image_url'] ?? ''; // 假設圖像 URL 存儲在 'image_url' 字段中

            return Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: userDoc.id == currentUserID
                    ? const Color.fromARGB(255, 139, 195, 242)
                    : const Color.fromARGB(255, 197, 37, 37),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                  ),
                ),
              ),
              child: ListTile(
                leading: imageUrl.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 40,
                      ), // 如果圖像 URL 為空，顯示默認圖像
                title: Text(username),
                subtitle: Text(email),
              ),
            );
          }).toList();
          // 顯示所有用戶的列表
          return ListView(
            children: userList,
          );
        },
      ),
    );
  }
}
