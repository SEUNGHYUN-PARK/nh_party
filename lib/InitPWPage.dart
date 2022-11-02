import 'package:flutter/material.dart';

class InitPWPage extends StatefulWidget {
  const InitPWPage({Key? key}) : super(key: key);

  @override
  State<InitPWPage> createState() => _InitPWPageState();
}

class _InitPWPageState extends State<InitPWPage> {
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
      body: Container(
        
      ),
    );
  }
}
