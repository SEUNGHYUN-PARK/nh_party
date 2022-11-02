import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final _authentication = FirebaseAuth.instance;

  void initState()
  {
    super.initState();
    _initCheck();
  }

  void _initCheck() async {
    var userID_key = 'userID';
    var userPW_key = 'userPW';
    var autoSignIn_key = 'autoSignIn';
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() async {
      var userID_value = pref.getString(userID_key);
      var autoSignIn_value = pref.getString(autoSignIn_key);
      var userPW_value = pref.getString(userPW_key);
      if(userID_value != null && autoSignIn_value == 'autoSignIn')
      {
        // ID저장
        try{
          final user = await _authentication.signInWithEmailAndPassword(
              email: userID_value, password: userPW_value!);
          if(user.user!=null){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()),(route)=>false);
          }
        }
        catch(e){
          print(e);
          final message = e.toString();
          Fluttertoast.showToast(msg:message,fontSize:10);
        }
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

