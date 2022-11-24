import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../SignInPage.dart';
import 'mypage/userinfopage.dart';

class EtcSubPage extends StatefulWidget {
  const EtcSubPage({Key? key}) : super(key: key);

  @override
  State<EtcSubPage> createState() => _EtcSubPageState();
}

class _EtcSubPageState extends State<EtcSubPage> {
  final _authentication = FirebaseAuth.instance;
  static final storage = FlutterSecureStorage();
  String _userName = '';
  String _firstFav = '';
  String _secondFav = '';
  String _thirdFav = '';

  Future<bool> getMyInfo() async{
    final docs = await FirebaseFirestore.instance.collection("user/${_authentication.currentUser!.uid}/myInfo").doc(_authentication.currentUser!.uid).get()
        .then((DocumentSnapshot doc){
      _userName = doc["userName"];
      _firstFav = doc["firstFav"];
      _secondFav = doc["secondFav"];
      _thirdFav = doc["thirdFav"];
    });
    setState(() {});
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person),
              Text(_userName),
              SizedBox(width: 30,),
              ElevatedButton(
                child: Text("로그아웃"),
                onPressed: () async {
                  _authentication.signOut();
                  String? setting = await storage.read(key: 'setting');
                  if(setting == 'autoSignIn&rememberId'){
                    storage.delete(key: "_userID");
                    storage.delete(key: "_userPW");
                    storage.delete(key: "setting");
                  }
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInPage()));
              },),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UserInfoPage();
                  }));
                },
                child: Text("정보 수정하기"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    textStyle: TextStyle(
                      fontSize: 13,
                    )),
              ),
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
