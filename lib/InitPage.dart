import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './SignInPage.dart';
import './MainPage.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final _authentication = FirebaseAuth.instance;
  static final storage = FlutterSecureStorage();
  String? _userID = '';
  String? _userPW = '';

  void initState()
  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async{
    _userID = await storage.read(key: "_userID");
    _userPW = await storage.read(key: "_userPW");

    print("& : $_userID");
    print("& : $_userPW");

    if(_userID != null && _userPW != null) {
      try{
        final user = await _authentication.signInWithEmailAndPassword(
            email: _userID!, password: _userPW!);
        if(user.user!=null){
         // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()),(route)=>false);
         Navigator.pushAndRemoveUntil(context, PageTransition(curve: Curves.easeInOut,type: PageTransitionType.fade, child: MainPage()),(route)=>false);
        }
      }
      catch(e){
        print(e);
        final message = e.toString();
        Fluttertoast.showToast(msg:message,fontSize:10);
      }
    }
    else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInPage()),(route)=>false);
    }
  }


  // void _initCheck() async {
  //   var userID_key = 'userID';
  //   var userPW_key = 'userPW';
  //   var autoSignIn_key = 'autoSignIn';
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   var userID_value = pref.getString(userID_key);
  //   var autoSignIn_value = pref.getString(autoSignIn_key);
  //   var userPW_value = pref.getString(userPW_key);
  //   setState(() async {
  //     print("=============================${userID_value}=======================================");
  //     print("=============================${userPW_value}=======================================");
  //     if(userID_value != null && autoSignIn_value == 'autoSignIn')
  //     {
  //       // ID저장
  //
  //     }
  //     else
  //     {
  //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInPage()),(route)=>false);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/image/logo.png',width: 150,height: 150,),
            Text("Somoim",style: TextStyle(fontSize: 20,color: Colors.black),)],
          ),
        ),
      )
    );
  }
}

