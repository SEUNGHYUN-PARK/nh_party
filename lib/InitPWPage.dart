import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'config/palette.dart';

class InitPWPage extends StatefulWidget {
  const InitPWPage({Key? key}) : super(key: key);

  @override
  State<InitPWPage> createState() => _InitPWPageState();
}

class _InitPWPageState extends State<InitPWPage> {

  final _authentication = FirebaseAuth.instance;
  String _userEmail="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("비밀번호 찾기",
          style: TextStyle(color: Colors.black,),),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Text("가입하신 이메일을 입력하시면",
                style: TextStyle(fontSize: 13),),
              Text("비밀번호 재설정을 위한 링크를 보내드립니다.",
                style: TextStyle(fontSize: 13),),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey(1),
                  validator:(value){
                    if(value!.isEmpty || !value.contains('@'))
                    {
                      return '이메일 주소를 확인해주세요';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _userEmail = value!;
                  },
                  onChanged: (value){
                    _userEmail = value;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:Palette.textColor1
                          ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:Palette.textColor1
                          ),
                      ),
                      hintText: 'example@gmail.com',
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: Palette.textColor1
                      ),
                      contentPadding: EdgeInsets.all(10.0)
                  ),
                ),
              ),
              ElevatedButton(child: Text("확인"),
                onPressed: (){
                _authentication.setLanguageCode("ko");
                _authentication.sendPasswordResetEmail(email: _userEmail);
                },)
            ],
          ),
        )
      ),
    );
  }
}
