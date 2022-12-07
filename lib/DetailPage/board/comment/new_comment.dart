import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewComments extends StatefulWidget {
  String? _postId = '';
  String? _partyId = '';
  NewComments(this._partyId,this._postId,{Key? key}) : super(key: key);

  @override
  State<NewComments> createState() => _NewCommentsState(_partyId, _postId);
}

class _NewCommentsState extends State<NewComments> {

  String? _postId = '';
  String? _partyId = '';
  final _controller = TextEditingController();
  var _userEnterComments = '';

  _NewCommentsState(String? partyId, String? postId)
  {
    this._postId = postId;
    this._partyId = partyId;
  }

  void _sendComments() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('user')
        .doc(user!.uid).collection('myInfo').doc(user.uid).get();
    FirebaseFirestore.instance.collection('somoim/${_partyId}/board/${_partyId}/post/${_postId}/comments').add({
      'text' : _userEnterComments,
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
                      labelText: '댓글을 입력해주세요',
                      labelStyle: TextStyle(fontSize: 10)
                  ),
                  onChanged: (value){
                    setState(() {
                      _userEnterComments = value;
                    });
                  },
                )
            ),
            IconButton(
                onPressed: _userEnterComments.trim().isEmpty ? null : _sendComments,
                icon: Icon(Icons.send),
                color:Colors.blue
            )
          ],
        )
    );
  }
}
