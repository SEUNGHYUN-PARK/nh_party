import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nh_party/DetailPage/DetailPageChat.dart';
import 'package:nh_party/DetailPage/DetailPageMember.dart';
import 'package:nh_party/DetailPage/DetailPageOutline.dart';

import '../MainPage.dart';
import '../Model/member.dart';
import 'DetailPageBoard.dart';

class DetailPageMain extends StatefulWidget {
  String partyId='';
  DetailPageMain(this.partyId,{Key? key}) : super(key: key);

  @override
  State<DetailPageMain> createState() => _DetailPageMainState(partyId);
}

class _DetailPageMainState extends State<DetailPageMain> with SingleTickerProviderStateMixin {

  List<Widget> _tabs = [Tab(text: "정보",),
                        Tab(text: "게시판",),
                        Tab(text: "멤버",),
                        Tab(text: "채팅")];
  TabController? _tabController;
  String partyId  = '';
  final _authentication = FirebaseAuth.instance;
  bool _checker = false;

  @override
  void initState()
  {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _checkMember();
  }

  @override
  void dispose()
  {
    _tabController!.dispose();
    super.dispose();

  }

  _DetailPageMainState(String partyId)
  {
    this.partyId = partyId;

  }

  Future<bool> _checkMember() async{
    CollectionReference<Map<String,dynamic>> res = FirebaseFirestore.instance.collection("somoim/${partyId}/memberList/${partyId}/member");
    QuerySnapshot<Map<String,dynamic>> qrysnp = await res.get(); //

    _checker = false;

    for (var doc in qrysnp.docs)
    {
      Member m = Member.fromQuerySnapShot(doc);
      if(m.memberID == _authentication.currentUser!.uid) {
        print("memberID : ${m.memberID}");
        print("currentUser_UID : ${_authentication.currentUser!.uid}");
        _checker = true;
      }
    }
    setState(() {

    });
    return true;
  }


  @override
  Widget build(BuildContext context) {
    print("checker 값 : ${_checker}");
    return Scaffold(
      appBar: AppBar(
        title : Text("상세페이지",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context){
              return MainPage();
            })
            );
          },
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),

        ),
        bottom: _checker ? TabBar(
          tabs: _tabs,
          controller: _tabController,
          labelColor: Colors.black,
        ) : null,
      ),
      body: _checker ? TabBarView(
        children: <Widget>[DetailPageOutline(partyId),DetailPageBoard(partyId),DetailPageMember(partyId),DetailPageChat(partyId)],
        controller: _tabController,
      ) : DetailPageOutline(partyId),
    );


  }
}