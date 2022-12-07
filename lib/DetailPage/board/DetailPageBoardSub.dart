import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nh_party/Model/board.dart';

import 'comment/comments.dart';
import 'comment/new_comment.dart';

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
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentsController = TextEditingController();

  _DetailPageBoardSubState(String partyId, String postId){
    this._partyId = partyId;
    this._postId = postId;
    print(_partyId);
    print(_postId);
  }

  Future<bool> getPostInfo() async{
    final docs = await FirebaseFirestore.instance.collection("somoim/${_partyId}/board/${_partyId}/post").doc(_postId).get()
        .then((DocumentSnapshot doc){
      _postId = doc["postId"];
      _title = doc["title"];
      _contents = doc["contents"];

      _titleController.text = _title;
      _contentsController.text = _contents;
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
      appBar: AppBar(
        title : Text("게시글 조회",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios)
        ),
      ),
      body: FutureBuilder(
        future: getPostInfo() ,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Padding(
            padding: EdgeInsets.only(left: 30,right: 30),
            child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            labelText: "게시글 제목",
                            border: OutlineInputBorder()
                        ),
                        child: TextFormField(
                          readOnly: true,
                          controller: _titleController,
                          decoration: InputDecoration(border: InputBorder.none),
                          onSaved: (value) {
                            setState(() {
                              _title = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            labelText: "게시글 내용",
                            border: OutlineInputBorder()
                        ),
                        child: TextFormField(
                          controller: _contentsController,
                          maxLines: 7,
                          readOnly: true,
                          decoration: InputDecoration(border: InputBorder.none),
                          onSaved: (value) {
                            setState(() {
                              _contents = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 180,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "댓글",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                            )
                          ),
                          child: Comments(_partyId,_postId)
                        )
                      ),
                      NewComments(_partyId,_postId),
                    ],
                  ),
                )
            ),
          );
        },

      ),
    );
  }
}
