import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nh_party/SubPage/AllPartyListSubPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{
  DateTime timeBackPressed = DateTime.now();

  List<Widget> _widgetList = [AllPartyListSubPage(),Text("2"),Text("3")];
  TabController? _tabController;

  @override
  void initState()
  {
    super.initState();
    _tabController = TabController(length: _widgetList.length, vsync: this);
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
          title: Text("소모임"),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){
              print("menu button is clicked");
            },
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                  print("search button is clicked");
                })
          ],
        ),
        body: TabBarView(
          children: _widgetList,
          controller: _tabController,
        ),
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            Tab(icon: Icon(Icons.groups)),
            Tab(icon: Icon(Icons.view_list),),
            Tab(icon: Icon(Icons.more_horiz),),
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
