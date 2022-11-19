import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nh_party/Model/board.dart';

class DetailPageBoardSub extends StatefulWidget {
  String _partyId = '';
  String _postId = '';

  DetailPageBoardSub(this._partyId,this._postId,{Key? key}) : super(key: key);

  @override
  State<DetailPageBoardSub> createState() => _DetailPageBoardSubState(_partyId,_postId);
}

class _DetailPageBoardSubState extends State<DetailPageBoardSub> {
  String _partyId = '';
  String _postId = '';
  String _title = '';
  String _contents = '';

  _DetailPageBoardSubState(String partyId, String postId){
    this._partyId = partyId;
    this._postId = postId;
  }

  Future<bool> getPostInfo() async{
    final docs = await FirebaseFirestore.instance.collection("somoim/${_partyId}/board/${_partyId}/post").doc().get()
        .then((DocumentSnapshot doc){
      _postId = doc["postId"];
      _title = doc["title"];
      _contents = doc["contents"];
    }
    );
    return true;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getPostInfo() ,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Text("${_title}"),
              ],
            ),
          );
        },

      ),
    );
  }
}
