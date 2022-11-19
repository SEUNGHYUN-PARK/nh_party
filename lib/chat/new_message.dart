import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  String? partyId = '';
  NewMessage(this.partyId,{Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState(partyId);
}

class _NewMessageState extends State<NewMessage> {

  String? partyId = '';
  final _controller = TextEditingController();
  var _userEnterMessage = '';

  _NewMessageState(String? partyId)
  {
    this.partyId = partyId;
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('user')
        .doc(user!.uid).get();
    FirebaseFirestore.instance.collection('somoim/${partyId}/chat').add({
      'text' : _userEnterMessage,
      'time' : Timestamp.now(),
      'userID' : user.uid,
      'userName' : userData.data()!['userName']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:10),
      padding: EdgeInsets.all(8),
      child:Row(
        children: [
          Expanded(
            child: TextField(
              maxLines:null,
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'send a message...'
              ),
              onChanged: (value){
                setState(() {
                  _userEnterMessage = value;
                });
              },
            )
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color:Colors.blue
          )
        ],
      )
    );
  }
}
