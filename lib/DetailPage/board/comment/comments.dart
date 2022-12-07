import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Comments extends StatelessWidget {
  String? _partyId = '';
  String? _postId = '';

  Comments(String? partyId, String? postId)
  {
    this._partyId = partyId;
    this._postId = postId;
  }

  @override
  Widget build(BuildContext context) {
    print(_partyId);
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('somoim/${_partyId}/board/${_partyId}/post/${_postId}/comments')
          .orderBy('time',descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context,index){
              return Container(
                padding: EdgeInsets.only(top : 5, bottom: 5),
                margin: EdgeInsets.only(top : 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                    docs[index]['userName'],
                      style: TextStyle(fontSize: 10.0,),
                    ),
                    Text(
                      docs[index]['text'],
                      style: TextStyle(fontSize: 20.0,)),
                  ],
                )
              );
            }
        );
      },
    );
  }
}
