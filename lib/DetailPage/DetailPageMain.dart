import 'package:flutter/material.dart';
import 'package:nh_party/DetailPage/DetailPageChat.dart';
import 'package:nh_party/DetailPage/DetailPageOutline.dart';

import '../MainPage.dart';
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

  @override
  void initState()
  {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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


  @override
  Widget build(BuildContext context) {
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
        bottom: TabBar(
          tabs: _tabs,
          controller: _tabController,
          labelColor: Colors.black,
        ),
      ),
      body: TabBarView(
        children: <Widget>[DetailPageOutline(partyId),DetailPageBoard(partyId),Text("멤버"),DetailPageChat(partyId)],
        controller: _tabController,
      ),
    );
  }
}