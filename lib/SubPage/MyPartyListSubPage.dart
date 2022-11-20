import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../DetailPage/DetailPageMain.dart';
import '../Model/Somoim.dart';

class MyPartyListSubPage extends StatefulWidget {
  const MyPartyListSubPage({Key? key}) : super(key: key);

  @override
  State<MyPartyListSubPage> createState() => _MyPartyListSubPageState();
}

class _MyPartyListSubPageState extends State<MyPartyListSubPage> {
  final user = FirebaseAuth.instance.currentUser;

  String _email = '';
  String _userName='';
  String _firstFav = '';
  String _secondFav = '';
  String _thirdFav = '';
  String _chooseFav ='';

  List<Somoim> mdl = [];
  List<Somoim> category_mdl = [];

  Future<bool> getMySomoim() async{
    CollectionReference<Map<String,dynamic>> res = FirebaseFirestore.instance.collection("user/${user!.uid}/mySomoim/");
    QuerySnapshot<Map<String,dynamic>> qrysnp = await res.get(); //

    mdl.clear();
    for (var doc in qrysnp.docs)
    {
      Somoim m = Somoim.fromQuerySnapShot(doc);
      mdl.add(m);
      print("${m.partyId},${m.partyName}");
    }
    return true;
  }

  Future<bool> getMyInfo() async{
    final docs = await FirebaseFirestore.instance.collection("user/${user!.uid}/myInfo").doc(user!.uid).get()
        .then((DocumentSnapshot doc){
      _email = doc["email"];
      _userName = doc["userName"];
      _firstFav = doc["firstFav"];
      _secondFav = doc["secondFav"];
      _thirdFav = doc["thirdFav"];
      // 최초 카테고리 추천 리스트 load를 위한 값 세팅
        if(_firstFav == '운동'){
          _chooseFav = 'exercise';
        }
        else if(_firstFav == '먹방'){
          _chooseFav = 'mukbang';
        }
        else if (_firstFav == '게임'){
          _chooseFav = 'game';
        }
        else if (_firstFav == '여행'){
          _chooseFav = 'trip';
        }
        setState(() {

        });
    }
    );
    return true;
  }

  Future<bool> getMyCategory(String _chooseFav) async{
    CollectionReference<Map<String,dynamic>> res = FirebaseFirestore.instance.collection("category/category/${_chooseFav}/");
    QuerySnapshot<Map<String,dynamic>> qrysnp = await res.get(); //

    category_mdl.clear();
    for (var doc in qrysnp.docs)
    {
      Somoim m = Somoim.fromQuerySnapShot(doc);
      category_mdl.add(m);
    }
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
              children: [
                Padding(
                  padding: EdgeInsets.only(left:20),
                  child: Text("가입한 모임",textAlign: TextAlign.start,),
                ),
              ],
            ),
            Center(
              child: SizedBox(
                height: 250,
                child: FutureBuilder(
                  future: getMySomoim(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.hasData == false){
                      return CircularProgressIndicator();
                    }
                    else if (snapshot.hasError){
                      return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Error : ${snapshot.error}',
                            style: TextStyle(fontSize: 15),
                          )
                      );
                    }
                    else{
                      if(mdl.length == 0){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text('나의 소모임을 추가하세요!')]
                        );
                      }
                      else{
                        return ListView.builder(
                          itemCount:mdl.length,
                          itemBuilder: (context,position) {
                            return Column(
                              children: [
                                ListTile(
                                  title:Text("${mdl[position].partyName} (${mdl[position].currentMemberCnt}/${mdl[position].maxMemberCnt})"),
                                  subtitle: Text("${mdl[position].partySubtitle}"),
                                  leading: Icon(Icons.account_box_sharp),
                                  onTap: (){
                                    print("${mdl[position].partyName}");
                                    Navigator.push(context,MaterialPageRoute(builder: (context){
                                      return DetailPageMain("${mdl[position].partyId}");
                                    })
                                    );
                                  },
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.black,
                                )
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left:20),
                  child: Text("${_userName}님의 관심사별 모임찾기"),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    if(_firstFav == '운동'){
                      _chooseFav = 'exercise';
                    }
                    else if(_firstFav == '먹방'){
                      _chooseFav = 'mukbang';
                    }
                    else if (_firstFav == '게임'){
                      _chooseFav = 'game';
                    }
                    else if (_firstFav == '여행'){
                      _chooseFav = 'trip';
                    }
                    setState(() {});
                  },
                  child: Text("      ${_firstFav}      "),),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    onPressed: (){
                      if(_secondFav == '운동'){
                        _chooseFav = 'exercise';
                      }
                      else if(_secondFav == '먹방'){
                        _chooseFav = 'mukbang';
                      }
                      else if (_secondFav == '게임'){
                        _chooseFav = 'game';
                      }
                      else if (_secondFav == '여행'){
                        _chooseFav = 'trip';
                      }
                      setState(() {});

                    },
                    child: Text("      ${_secondFav}      ")),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    onPressed: (){
                      if(_thirdFav == '운동'){
                        _chooseFav = 'exercise';
                      }
                      else if(_thirdFav == '먹방'){
                        _chooseFav = 'mukbang';
                      }
                      else if (_thirdFav == '게임'){
                        _chooseFav = 'game';
                      }
                      else if (_thirdFav == '여행'){
                        _chooseFav = 'trip';
                      }
                      setState(() {});
                    },
                    child: Text("      ${_thirdFav}      ")),
              ],
            ),
            Center(
              child: SizedBox(
                height: 170,
                child: FutureBuilder(
                  future: getMyCategory(_chooseFav),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.hasData == false){
                      return CircularProgressIndicator();
                    }
                    else if (snapshot.hasError){
                      return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Error : ${snapshot.error}',
                            style: TextStyle(fontSize: 15),
                          )
                      );
                    }
                    else{
                      if(category_mdl.length == 0){
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text('해당 카테고리의 소모임이 없습니다!')]
                        );
                      }
                      else{
                        return ListView.builder(
                          itemCount:category_mdl.length,
                          itemBuilder: (context,position) {
                            return Column(
                              children: [
                                ListTile(
                                  title:Text("${category_mdl[position].partyName} (${category_mdl[position].currentMemberCnt}/${category_mdl[position].maxMemberCnt})"),
                                  subtitle: Text("${category_mdl[position].partySubtitle}"),
                                  leading: Icon(Icons.account_box_sharp),
                                  onTap: (){
                                    print("${category_mdl[position].partyName}");
                                    Navigator.push(context,MaterialPageRoute(builder: (context){
                                      return DetailPageMain("${category_mdl[position].partyId}");
                                    })
                                    );
                                  },
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.black,
                                )
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ) ,
    );
  }
}
