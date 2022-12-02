import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './MainPage.dart';
import './SignUpPage.dart';
import './InitPWPage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  DateTime timeBackPressed = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  String? _userID ="";
  String? _userPW ="";
  bool _isAutoSignIn = false;
  bool _isSaveId = false;
  bool showSpinner = false;
  TextEditingController _idController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  static final storage = new FlutterSecureStorage();

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    _userID = await storage.read(key: "_userID");
    String? setting = await storage.read(key: "setting");
    print("$_userID  /  $setting");
    if (setting == 'rememberId') {
      _idController.text = _userID!;
      setState(() {
        _isSaveId=true;
      });
    }
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
                        child: Image.asset('assets/image/logo.png',height: 150,width: 250,),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: 300,
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: TextFormField(
                          controller: _idController,
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
                          onChanged: (value){
                            _userID = value;
                          },
                          onSaved: (value){
                            _userID = value;
                          },
                        ),
                      ),
                      Container(
                        width: 300,
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: TextFormField(
                          controller: _pwController,
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
                          onChanged: (value){
                            _userPW = value;
                          },
                          onSaved: (value){
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
                                  email: _userID!, password: _userPW!);
                              print("_isSaveId : $_isSaveId");
                              print("_isAutoSignIn : $_isAutoSignIn");

                              if(newUser.user!=null){

                                if(_isAutoSignIn) {
                                  _isSaveId = true;
                                  // 자동로그인시 ID저장항목의 Disable이 자동으로 설정되지만 실제 값도 null로 설정
                                  // 따라서 값을 강제적으로 설정해줘야함
                                }

                                if(_isSaveId)
                                {
                                  await storage.write(key: "_userID", value: _userID!);
                                  await storage.write(key: "setting", value: "rememberId");
                                  if(_isAutoSignIn) {
                                    await storage.write(key: "_userPW", value: _pwController.text.toString());
                                    await storage.write(key: "setting", value: "autoSignIn&rememberId");
                                  }
                                }
                                else{
                                  await storage.delete(key: "setting");
                                  await storage.delete(key: "_userID");
                                  await storage.delete(key: "_userPW");
                                }
                                final tmp = await storage.read(key: "_userID");
                                final tmp2 = await storage.read(key: "_userPW");
                                final tmp3 = await storage.read(key: "setting");

                                print("$tmp / $tmp2 / $tmp3");
                                print(_idController.toString());
                                print(_pwController.toString());

                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()),(route)=>false);

                                setState(() {
                                  showSpinner = false;
                                });

                              }
                            }
                            catch(e){
                              setState(() {
                                showSpinner = false;
                              });
                              print(e);
                              final message = e.toString();
                              Fluttertoast.showToast(msg:message,fontSize:10);
                            }

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
