import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './MainPage.dart';
import './SignUpPage.dart';
import './InitPWPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  DateTime timeBackPressed = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String _userID ="";
  String _userPW ="";
  bool _isAutoSignIn = false;
  bool _isSaveId = false;
  TextEditingController _textEditingController = TextEditingController();
  @override
  void initState()
  {
    super.initState();
    _getUserID();
  }

  void _getUserID() async
  {
    var key = 'userID';
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _userID = pref.getString(key)!;
      _textEditingController.text = _userID;
    });
    if(_userID != null || _userID != "")
    {
      _isSaveId = true;
    }
  }

  bool checkUserInfo()
  {
    return true;
  }

  void _setAutoSignIn()  async
  {
    var autoSignIn_key = 'autoSignIn';
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(autoSignIn_key, 'autoSignIn');
  }

  void _setUserID(String _userID)  async
  {
    var userID_key = 'userID';
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(userID_key, _userID);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if(isExitWarning)
        {
          final message = '뒤로가기 한번 더 누르시면 앱이 종료됩니다.';
          Fluttertoast.showToast(msg:message,fontSize:10);
          return false;
        }
        else
        {
          SystemNavigator.pop(animated: true);
          return true;
        }
      },
      child: Scaffold(
          body: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: Image.asset('image/logo.png',height: 150,width: 250,),
                    ),
                    Container(
                      width: 300,
                      padding: EdgeInsets.only(left: 50,right: 50),
                      child: TextFormField(
                        controller: _textEditingController,
                        decoration: InputDecoration(labelText: 'ID'),
                        validator: (String? value) {
                          if(value==null||value.isEmpty)
                          {
                            return "ID를 입력해주세요";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            _userID = value!;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 300,
                      padding: EdgeInsets.only(left: 50,right: 50),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Password"),
                        validator: (value) {
                          if(value == null || value.isEmpty)
                          {
                            return "Password를 입력해주세요";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            _userPW = value!;
                          });
                        },
                      ),
                    ),
                    TextButton(
                        onPressed: (){
                          if(_formKey.currentState!.validate()) //빈칸 체크
                              {
                            _formKey.currentState!.save();
                            //계정정보 체크
                            //if 성공 자동저장 및 아이디저장 기능 구현 + 메인 화면 이동
                            //else 실패 toast message로 계정정보 불일치 항목 출력
                            if(checkUserInfo()) {
                              if (_isAutoSignIn)
                              {
                                _setAutoSignIn();
                              }
                              if (_isSaveId)
                              {
                                _setUserID(_userID);
                              }
                            }
                            //                        final message = '계정정보를 다시 확인해주세요';
                            //                         Fluttertoast.showToast(msg:message,fontSize:10);
                            //
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()),(route)=>false);
                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage()));
                          }
                        },
                        child: Text("Login")
                    ),
                    Container(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("자동로그인"),
                          Checkbox(
                              value: _isAutoSignIn, onChanged: (value){
                            setState(() {
                              _isAutoSignIn = value!;
                            });
                          }),
                          Text("ID저장"),
                          Checkbox(
                              value: _isSaveId, onChanged: (value){
                            setState(() {
                              _isSaveId = value!;
                            });
                          })
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage()));
                            }, child: Text("회원가입"))
                          ],
                        )
                    ),
                    Container(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => InitPWPage()));
                          }, child: Text("비밀번호 찾기")),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
      ),
    );
  }
}
