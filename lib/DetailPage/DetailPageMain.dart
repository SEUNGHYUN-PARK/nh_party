import 'package:flutter/material.dart';
import 'package:nh_party/DetailPage/DetailPageOutline.dart';

import '../MainPage.dart';

class DetailPageMain extends StatefulWidget {
  const DetailPageMain({Key? key}) : super(key: key);

  @override
  State<DetailPageMain> createState() => _DetailPageMainState();
}

class _DetailPageMainState extends State<DetailPageMain> with SingleTickerProviderStateMixin {

  List<Widget> _tabs = [Tab(text: "정보",),
                        Tab(text: "게시판",),
                        Tab(text: "멤버",),
                        Tab(text: "채팅")];
  TabController? _tabController;

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("상세페이지",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        bottom: TabBar(
          tabs: _tabs,
          controller: _tabController,
        ),
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
      ),
      body: TabBarView(
        children: <Widget>[DetailPageOutline(),Text("게시판"),Text("멤버"),Text("채팅")],
        controller: _tabController,
      ),
    );
  }
}