import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nh_party/chat/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('testchat/XVxXEL1ZAxZot42ohqmH/test')
          .orderBy('time',descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
            reverse: true,
            itemCount: docs.length,
            itemBuilder: (context,index){
              return Container(
                padding: EdgeInsets.all(8.0),
                child: ChatBubbles(
                  docs[index]['text'],
                  docs[index]['userID'].toString() == user!.uid,
                  docs[index]['userName']
                ),
              );
            }
        );
      },
    );
  }
}
