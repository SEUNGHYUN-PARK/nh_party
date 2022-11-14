import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'MainPage.dart';
import 'config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);


  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formkey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  bool showSpinner = false;
  String _userEmail = '';
  String _userPassword = '';
  String _userName = '';
  String _first_fav = '';
  String _second_fav = '';
  String _third_fav = '';

  void _tryValidation(){
   final isValid = _formkey.currentState!.validate();
   if(isValid){
     _formkey.currentState!.save();
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("회원가입",
          style: TextStyle(color: Colors.black,),),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom:30),
            child: Column(
              children: [
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20,left: 30,right:30,bottom: 5),
                    child: Row(
                      children: [
                        Text(
                            "이메일"
                        ),
                        Text(
                            "* ",
                            style: TextStyle(color: Colors.red,)),
                      ],
                    )
                  )
                ), // 이메일
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(top:5, left: 30,right:30,bottom: 8),
                    child: Expanded(
                        child: TextFormField(
                          onSaved: (value){
                            _userEmail = value!;
                          },
                          onChanged: (value){
                            _userEmail = value;
                          },
                          validator: (value){
                            if(value!.isEmpty || !value.contains('@')) {
                              return '이메일을 확인해주세요';
                            }
                            return null;
                          },
                          key:  ValueKey(1),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Palette.textColor1
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Colors.greenAccent
                                ),
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: 'example@gmail.com',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Palette.textColor1
                              ),
                          ),
                        )
                    ),
                  )
                ), // 이메일 텍스트박스
                SizedBox(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10,left: 30,right:30,bottom: 3),
                        child: Row(
                          children: [
                            Text(
                                "비밀번호"
                            ),
                            Text(
                                "* ",
                                style: TextStyle(color: Colors.red,)),
                          ],
                        )
                    )
                ), // 비밀번호
                SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5,left: 30,right:30,bottom: 8),
                      child: Expanded(
                          child: TextFormField(
                            obscureText: true,
                            validator: (value){
                              if(value!.isEmpty || value.length < 6) {
                                return '비밀번호를 확인해주세요';
                              }
                              return null;
                            },
                            onChanged: (value){
                              _userEmail = value;
                            },
                            onSaved: (value){
                              _userPassword = value!;
                            },
                            key:  ValueKey(2),
                            style: TextStyle(),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Palette.textColor1
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Colors.greenAccent
                                ),
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: '6자 이상 입력',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Palette.textColor1
                              ),
                            ),
                          )
                      ),
                    )
                ), // 비밀번호 텍스트박스
                SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2,left: 30,right:30,bottom: 8),
                      child: Expanded(
                          child: TextFormField(
                            obscureText: true,
                            validator: (value){
                              if(value!.isEmpty || value.length < 6) {
                                return '비밀번호를 확인해주세요';
                              }
                              return null;
                            },
                            onChanged: (value){
                              //윗 텍스트박스랑 동일하지않다면 에레메세지 출력
                            },
                            key:  ValueKey(3),
                            style: TextStyle(),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Palette.textColor1
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Colors.greenAccent
                                ),
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: '비밀번호 확인',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Palette.textColor1
                              ),
                            ),
                          )
                      ),
                    )
                ), // 비밀번호 확인 텍스트박스
                SizedBox(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10,left: 30,right:30,bottom: 5),
                        child: Row(
                          children: [
                            Text(
                                "이름"
                            ),
                            Text(
                                "* ",
                                style: TextStyle(color: Colors.red,)),
                          ],
                        )
                    )
                ), // 이름
                SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5,left: 30,right:30,bottom: 3),
                      child: Expanded(
                          child: TextFormField(
                            validator: (value){
                              if(value!.isEmpty) {
                                return '이름을 확인해주세요';
                              }
                              return null;
                            },
                            onSaved: (value){
                              _userName = value!;
                            },
                            onChanged: (value){
                              _userName = value;
                            },
                            key:  ValueKey(4),
                            style: TextStyle(),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Palette.textColor1
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Colors.greenAccent
                                ),
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: '실명을 입력해주세요',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Palette.textColor1
                              ),
                            ),
                          )
                      ),
                    )
                ), // 이름 텍스트박스
                SizedBox(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10,left: 30,right:30,bottom: 5),
                        child: Row(
                          children: [
                            Text(
                                "관심분야1"
                            ),
                          ],
                        )
                    )
                ), // 관심사1
                SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5,left: 30,right:30,bottom: 3),
                      child: Expanded(
                          child: TextFormField(
                            onSaved: (value){
                              _first_fav = value!;
                            },
                            onChanged: (value){
                              _first_fav = value;
                            },
                            key:  ValueKey(5),
                            style: TextStyle(),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Palette.textColor1
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Colors.greenAccent
                                ),
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: '관심 분야를 입력해주세요',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Palette.textColor1
                              ),
                            ),
                          )
                      ),
                    )
                ), // 관심사1 텍스트박스
                SizedBox(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10,left: 30,right:30,bottom: 5),
                        child: Row(
                          children: [
                            Text(
                                "관심분야2"
                            ),
                          ],
                        )
                    )
                ), // 관심사2
                SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5,left: 30,right:30,bottom: 3),
                      child: Expanded(
                          child: TextFormField(
                            onSaved: (value){
                              _second_fav = value!;
                            },
                            onChanged: (value){
                              _second_fav = value;
                            },
                            key:  ValueKey(6),
                            style: TextStyle(),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Palette.textColor1
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Colors.greenAccent
                                ),
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: '관심 분야를 입력해주세요',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Palette.textColor1
                              ),
                            ),
                          )
                      ),
                    )
                ), // 관심사2 텍스트박스
                SizedBox(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10,left: 30,right:30,bottom: 5),
                        child: Row(
                          children: [
                            Text(
                                "관심분야3"
                            ),
                          ],
                        )
                    )
                ), // 관심사3
                SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5,left: 30,right:30,bottom: 3),
                      child: Expanded(
                          child: TextFormField(
                            onSaved: (value){
                              _third_fav = value!;
                            },
                            onChanged: (value){
                              _third_fav = value;
                            },
                            key:  ValueKey(7),
                            style: TextStyle(),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Palette.textColor1
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:Colors.greenAccent
                                ),
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: '관심 분야를 입력해주세요',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Palette.textColor1
                              ),
                            ),
                          )
                      ),
                    )
                ), // 관심사3 텍스트박스
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async{
                          setState(() {
                            showSpinner=true;
                          });
                          _tryValidation();

                          try{
                            final newUser = await _authentication.createUserWithEmailAndPassword(
                                email: _userEmail, password: _userPassword);

                            await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid)
                            .set({
                              'userName' : _userName,
                              'email' : _userEmail,
                              'firstFav' : _first_fav,
                              'secondFav' : _second_fav,
                              'thirdFav' : _third_fav

                            });

                            if(newUser.user != null){
                              Navigator.push(context,MaterialPageRoute(builder: (context){
                                return MainPage();
                              }));
                              setState(() {
                                showSpinner=false;
                              });
                            }
                          }
                          catch(e){
                            final message = '이미 등록된 계정이 있습니다.';
                            Fluttertoast.showToast(msg:message,fontSize:10);
                          }
                        },
                        child: Text("가입하기",style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            elevation: 0
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
