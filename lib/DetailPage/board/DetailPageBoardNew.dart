import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../DetailPageMain.dart';


class DetailPageBoardNew extends StatefulWidget {
  String partyId = '';
  DetailPageBoardNew(this.partyId,{Key? key}) : super(key: key);

  @override
  State<DetailPageBoardNew> createState() => _DetailPageBoardNewState(partyId);
}

class _DetailPageBoardNewState extends State<DetailPageBoardNew> {
  final _formkey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;

  String _partyId = '';
  String _title = '';
  String _contents = '';

  _DetailPageBoardNewState(partyId){
    this._partyId = partyId;
  }

  void _tryValidation(){
    final isValid = _formkey.currentState!.validate();
    if(isValid){
      _formkey.currentState!.save();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title : Text("게시글 추가",style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            color: Colors.black,
            icon: Icon(Icons.arrow_back_ios),

          ),
        ),
      body: Padding(
        padding: EdgeInsets.only(top: 30,left: 30,right: 30),
        child: SingleChildScrollView(
            child: Form(
              key: _formkey,
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
                      key : ValueKey(1),
                      decoration: InputDecoration(border: InputBorder.none),
                      validator: (String? value){
                        if(value==null||value.isEmpty)
                        {
                          return "게시글 제목을 입력해주세요";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _title = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        labelText: "게시글 내용",
                        border: OutlineInputBorder()
                    ),
                    child: TextFormField(
                      key : ValueKey(2),
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(border: InputBorder.none),
                      validator: (String? value){
                        if(value==null||value.isEmpty)
                        {
                          return "게시글 내용을 입력해주세요";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _contents = value!;
                        });
                      },
                    ),
                  ),

                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () async {
                        _tryValidation();
                        try{
                          final boardRef = FirebaseFirestore.instance.collection('somoim/${_partyId}/board/${_partyId}/post').doc();
                          await boardRef
                              .set({
                            'partyId' : _partyId,
                            'postId' : boardRef.id,
                            'writer' : _authentication.currentUser!.uid,
                            'title' : _title,
                            'contents' : _contents,
                            'timeStamp' : DateFormat('yyyyMMddHHmmss').format(DateTime.now()),
                          });

                          if(boardRef != null){
                            Navigator.push(context,MaterialPageRoute(builder: (context){
                              return DetailPageMain(_partyId);
                            })
                            );
                          }
                        }
                        catch(e){
                          final message = e.toString();
                          Fluttertoast.showToast(msg:message,fontSize:10);
                        }
                      }, child: Text("생성"),),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}
