import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './InitPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'nh_party',
      home: InitPage(),
    );
  }
}


