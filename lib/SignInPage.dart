import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './MainPage.dart';
import './SignUpPage.dart';
import './InitPWPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  DateTime timeBackPressed = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  String _userID ="";
  String _userPW ="";
  bool _isAutoSignIn = false;
  bool _isSaveId = false;
  bool showSpinner = false;
  TextEditingController _textEditingController = TextEditingController();

  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

  @override
  void initState()
  {
    super.initState();
    _getUserID();
  }

  void _getUserID() async
  {
    var tmp="";
    var key = 'userID';
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      tmp = pref.getString(key)!;
      _textEditingController.text = tmp;
    });

    if(tmp != "")
    {
      _isSaveId = true;
    }
    else
    {
      _isSaveId = false;
    }
  }

  void _setAutoSignIn(String _userID, String _userPW)  async
  {
    var autoSignIn_key = 'autoSignIn';
    var userID_key = 'userID';
    var userPW_key = 'userPW';
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(autoSignIn_key, 'autoSignIn');
    pref.setString(userID_key, _userID);
    pref.setString(userPW_key, _userPW);
  }

  void _setUserID(String _userID)  async
  {
    var userID_key = 'userID';
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(userID_key, _userID);
  }

  void _removePreference() async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('userID');
    pref.remove('userPW');
    pref.remove('autoSignIn');
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
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 50),
                        child: Image.asset('image/logo.png',height: 150,width: 250,),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: 300,
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: TextFormField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            labelText: '이메일',
                            labelStyle: TextStyle(fontSize: 10),
                          ),
                          keyboardType: TextInputType.emailAddress,
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
                          onChanged: (value){
                            _userID = value;
                          },
                        ),
                      ),
                      Container(
                        width: 300,
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(fontSize: 10),
                          ),
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
                          onChanged: (value){
                            _userPW = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            _tryValidation();
                            try{
                              final newUser = await _authentication.signInWithEmailAndPassword(
                                  email: _userID, password: _userPW);
                              if(newUser.user!=null){
                                if (_isAutoSignIn)
                                {
                                  print(_userID);
                                  print(_userPW);
                                  _setAutoSignIn(_userID,_userPW);
                                }
                                if(_isSaveId)
                                {
                                  _setUserID(_userID);
                                }
                                else if(!_isSaveId)
                                {
                                  _removePreference();
                                }

                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()),(route)=>false);

                                setState(() {
                                  showSpinner = false;
                                });

                              }
                            }
                            catch(e){
                              print(e);
                              final message = e.toString();
                              Fluttertoast.showToast(msg:message,fontSize:10);
                            }




                            //계정정보 체크
                            //if 성공 자동저장 및 아이디저장 기능 구현 + 메인 화면 이동
                            //else 실패 toast message로 계정정보 불일치 항목 출력

                            //                        final message = '계정정보를 다시 확인해주세요';
                            //                         Fluttertoast.showToast(msg:message,fontSize:10);
                            //

                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage()));
                          },
                          child: Text("Login")
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "자동로그인",
                              style: TextStyle(fontSize: 15),
                            ),
                            Checkbox(
                              value: _isAutoSignIn,
                              onChanged: (value){
                                setState(() {
                                  _isAutoSignIn = value!;
                                });
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "ID저장",
                              style: TextStyle(fontSize: 15),
                            ),

                            Checkbox(
                                value: _isAutoSignIn ? true : _isSaveId,
                                onChanged: _isAutoSignIn ? null : (value){
                                  setState(() {
                                    _isSaveId = value!;
                                  });
                                }
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextButton(onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage()));
                              }, child: Text("아직 회원이 아니세요??",style: TextStyle(fontSize: 10),))
                            ],
                          )
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => InitPWPage()));
                            }, child: Text("비밀번호가 기억나지않으세요?",style: TextStyle(fontSize: 10),)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ),
          ),
      ),
    );
  }
}
