import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nh_party/SubPage/AllPartyListSubPage.dart';
import 'package:nh_party/SubPage/EtcSubPage.dart';
import 'package:nh_party/SubPage/MyPartyListSubPage.dart';
import 'DetailPage/DetailPageMain.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{
  DateTime timeBackPressed = DateTime.now();
  List<Widget> _widgetList = [AllPartyListSubPage(),MyPartyListSubPage(),EtcSubPage()];
  TabController? _tabController;
  final _authentication = FirebaseAuth.instance;
  final partyRef = FirebaseFirestore.instance;
  User? loggedUser;

  void getCurrentUser(){
    try{
      final user = _authentication.currentUser;
      if(user!=null){
        loggedUser = user;
        print(loggedUser!.email);
      }
    }
    catch(e) {
      print(e);
    }
  }

  @override
  void initState()
  {
    super.initState();
    _tabController = TabController(length: _widgetList.length, vsync: this);
    getCurrentUser();

  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          final message = '뒤로가기 한번 더 누르시면 앱이 종료됩니다.';
          Fluttertoast.showToast(msg: message, fontSize: 10);
          return false;
        }
        else {
          SystemNavigator.pop(animated: true);
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("소모임",style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                color: Colors.black,
                onPressed: (){
                  print("search button is clicked");
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) =>DetailPageMain()));
                })
          ],
        ),
        body: TabBarView(
          children: _widgetList,
          controller: _tabController,
        ),
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            Tab(icon: Icon(Icons.groups),child: Text("소모임",style: TextStyle(fontSize: 10))),
            Tab(icon: Icon(Icons.view_list),child: Text("나의 소모임",style: TextStyle(fontSize: 10))),
            Tab(icon: Icon(Icons.more_horiz),child: Text("마이 페이지",style: TextStyle(fontSize: 10)))
          ],
          indicatorColor: Colors.transparent,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          controller: _tabController
        ),
      )
    );
  }
}
