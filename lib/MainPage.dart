import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nh_party/SubPage/AllPartyListSubPage.dart';
import 'package:nh_party/SubPage/EtcSubPage.dart';
import 'package:nh_party/SubPage/MyPartyListSubPage.dart';
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
          title: Text("Somoim",style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: TabBarView(
          children: _widgetList,
          controller: _tabController,
        ),
         bottomNavigationBar: TabBar(
           tabs: <Widget>[
             Tab(icon: Icon(Icons.groups)),
             Tab(icon: Icon(Icons.category)),
             Tab(icon: Icon(Icons.account_circle))
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
