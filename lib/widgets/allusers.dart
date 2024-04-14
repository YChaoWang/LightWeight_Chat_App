import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
            return InkWell(
              onTap: () {
                // 點擊用戶時，導航到用戶的聊天頁面
                Navigator.of(context).pushNamed('/chat', arguments: {
                  'otherUserId': userDoc.id,
                });
              },
              child: ListTile(
                leading: imageUrl.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                      )
                    : Icon(Icons.account_circle), // 如果圖像 URL 為空，顯示默認圖像
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
