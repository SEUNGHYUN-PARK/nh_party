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
      appBar: AppBar(title: Text("비밀번호 찾기"),),
    );
  }
}
