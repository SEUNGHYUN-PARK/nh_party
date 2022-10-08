import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './SignInPage.dart';
import './MainPage.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  //String userID = "";

  void initState()
  {
    super.initState();
    _initCheck();
  }

  void _initCheck() async {
    var userID_key = 'userID';
    var autoSignIn_key = 'autoSignIn';
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var userID_value = pref.getString(userID_key);
      var autoSignIn_value = pref.getString(autoSignIn_key);
      if(userID_value != null && autoSignIn_value == 'autoSignIn')
      {
        // ID저장
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()),(route)=>false);
      }
      else
      {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInPage()),(route)=>false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Image.asset('image/logo.png')],
          ),
        ),
      )
    );
  }
}

