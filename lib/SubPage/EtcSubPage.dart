import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SignInPage.dart';

class EtcSubPage extends StatefulWidget {
  const EtcSubPage({Key? key}) : super(key: key);

  @override
  State<EtcSubPage> createState() => _EtcSubPageState();
}

class _EtcSubPageState extends State<EtcSubPage> {
  final _authentication = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.person),
              Text("ㅇㅇㅇ님"),
              ElevatedButton(onPressed: () async {
                _authentication.signOut();

                var autoSignIn_key = 'autoSignIn';
                var userID_key = 'userID';
                var userPW_key = 'userPW';
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove(autoSignIn_key);
                pref.remove(userID_key);
                pref.remove(userPW_key);

                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInPage()));

              }, child: Text("로그아웃"))
            ],
          ),
          Text("내가 찜한 목록"),
          Expanded(
              child:ListView.builder(itemBuilder: (context,position){
                return Card(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.rice_bowl),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text("모임명"),Text("모임소개글")],
                      ),
                    ],
                  ),
                );
              },
              itemCount: 5,
              )
          )


        ],
      )

    );
  }
}
