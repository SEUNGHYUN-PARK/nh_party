import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../../MainPage.dart';
import '../../config/palette.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _authentication = FirebaseAuth.instance;
  final List<String> _valueList_first = ['운동','먹방','게임','여행'];
  final List<String> _valueList_second = ['먹방','게임','여행'];
  final List<String> _valueList_third = ['게임','여행'];
  bool showSpinner = false;
  String _userName = '';
  String _firstFav = '운동';
  String _secondFav = '먹방';
  String _thirdFav = '게임';

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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("관심분야 변경",
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
            child: Column(
              children: [
                SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20,left: 30,right:30,bottom: 3),
                      child: Expanded(
                          child: InputDecorator(
                            key: ValueKey(1),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Palette.textColor1
                                    )
                                ),
                                labelText: "관심 분야1"
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: _firstFav,
                                items: _valueList_first.map((value){
                                  return DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: (value){
                                  setState(() {
                                    _firstFav = value!;
                                  });
                                },
                                hint: Text("선택하세요"),
                              ),
                            ),
                          )
                      ),
                    )
                ), // 관심사1 텍스트박스
                SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15,left: 30,right:30,bottom: 3),
                      child: Expanded(
                          child: InputDecorator(
                            key: ValueKey(2),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Palette.textColor1
                                    )
                                ),
                                labelText: "관심 분야2"
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: _secondFav,
                                items: _valueList_second.map((value){
                                  return DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: (value){
                                  setState(() {
                                    _secondFav = value!;
                                  });
                                },
                                hint: Text("선택하세요"),
                              ),
                            ),
                          )
                      ),
                    )
                ), // 관심사2 텍스트박스3
                SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15,left: 30,right:30,bottom: 3),
                      child: Expanded(
                          child: InputDecorator(
                            key: ValueKey(3),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Palette.textColor1
                                    )
                                ),
                                labelText: "관심 분야3"
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                value: _thirdFav,
                                items: _valueList_third.map((value){
                                  return DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: (value){
                                  setState(() {
                                    _thirdFav = value!;
                                  });
                                },
                                hint: Text("선택하세요"),
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

                          try{

                            FirebaseFirestore.instance.collection('user')
                                .doc(_authentication.currentUser!.uid)
                                .collection('myInfo')
                                .doc(_authentication.currentUser!.uid)
                                .update({"firstFav": _firstFav})
                                .then(
                                    (doc) => print("firstFav update")
                                ,onError: (e) => print("$e"));

                            FirebaseFirestore.instance.collection('user')
                                .doc(_authentication.currentUser!.uid)
                                .collection('myInfo')
                                .doc(_authentication.currentUser!.uid)
                                .update({"secondFav":_secondFav})
                                .then(
                                    (doc) => print("secondFav update")
                                ,onError: (e) => print("$e"));

                            FirebaseFirestore.instance.collection('user')
                                .doc(_authentication.currentUser!.uid)
                                .collection('myInfo')
                                .doc(_authentication.currentUser!.uid)
                                .update({"thirdFav":_thirdFav})
                                .then(
                                    (doc) => print("somoim update")
                                ,onError: (e) => print("$e"));

                            setState(() {
                              showSpinner=false;
                            });

                            Navigator.push(context,MaterialPageRoute(builder: (context){
                              return MainPage();
                            }));

                          }
                          catch(e){
                            final message = e.toString();
                            Fluttertoast.showToast(msg:message,fontSize:10);
                            setState(() {
                              showSpinner=false;
                            });
                          }
                        },
                        child: Text("수정하기",style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            elevation: 0
                        ),
                      ),
                    )
                )
              ],
            )
        )
    );
  }
}
