import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../Model/member.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailPageMember extends StatefulWidget {
  String _partyId = '';
  DetailPageMember(this._partyId, {Key? key}) : super(key: key);

  @override
  State<DetailPageMember> createState() => _DetailPageMemberState(_partyId);
}

class _DetailPageMemberState extends State<DetailPageMember> {

  List<Member> member = [];
  List<Member> waiting = [];
  String _partyId = '';
  String _partyName='';
  String _partySubtitle = '';
  String _currentMemberCnt = '';
  String _maxMemberCnt = '';
  String _partyMaker = '';
  String _partyCategory = '';
  String _userName = '';
  String _memberList = '';
  String _partyContents = '';
  String _timeStamp = '';
  final _authentication = FirebaseAuth.instance;


  _DetailPageMemberState(String partyId)
  {
    this._partyId = partyId;
    // print(partyId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  Future<bool> getPartyInfo() async{

    member.clear();
    waiting.clear();

    // 소모임 기본정보 Load
    final docs = await FirebaseFirestore.instance.collection("somoim").doc(_partyId).get()
        .then((DocumentSnapshot doc){
      _currentMemberCnt = doc["currentMemberCnt"];
      _maxMemberCnt  = doc["maxMemberCnt"];
      _partyName     = doc["partyName"];
      _partySubtitle = doc["partySubtitle"];
      _partyMaker    = doc["partyMaker"];
      _partyCategory = doc["partyCategory"];
      _partyContents = doc["partyContents"];
      _timeStamp = doc["timeStamp"];
    }
    );

    print(_partyId);

    // 소모임 가입자 정보 Load
    CollectionReference<Map<String,dynamic>> res = FirebaseFirestore.instance.collection("somoim/${_partyId}/memberList/${_partyId}/member");
    QuerySnapshot<Map<String,dynamic>> qrysnp = await res.get(); //

    for (var doc in qrysnp.docs)
    {
      Member m = Member.fromQuerySnapShot(doc);
      member.add(m);
      print("${m.name},${m.memberID}");
    }

    // 소모임 가입대기자 정보 Load
    CollectionReference<Map<String,dynamic>> res_wait = FirebaseFirestore.instance.collection("somoim/${_partyId}/memberList/${_partyId}/waiting");
    QuerySnapshot<Map<String,dynamic>> qrysnp_wait = await res_wait.get(); //

    for (var doc in qrysnp_wait.docs)
    {
      Member m = Member.fromQuerySnapShot(doc);
      waiting.add(m);
      print("${m.name},${m.memberID}");
    }

    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getPartyInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Column(
              children: [
                Padding(padding: EdgeInsets.all(10)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("${_partyName} (현재 맴버 수 / 최대 맴버 수) (${_currentMemberCnt} / ${_maxMemberCnt})")]
                ),
                Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                    height: 200,
                    child: ListView.builder(itemBuilder: (context,position){
                      return Card(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.rice_bowl),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // children: [Text("이름 : "), Text("${userName}") , Text("직책 : "), Text("normalUser")],
                              children: [Text("이름 : ") , Text("${member[position].name}") ],
                            ),
                          ],
                        ),
                      );
                    },
                      itemCount: member.length,
                    )
                ),

                // if로 묶을거임 partymaker 가 나면 보여주기
                Padding(padding: EdgeInsets.all(1)),
                if(_partyMaker ==_authentication.currentUser!.uid)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("신규회원 신청목록")], //,Icon(Icons.add)
                ),
                if(_partyMaker ==_authentication.currentUser!.uid)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: waiting.length,
                    itemBuilder: (context,position){
                      return Card(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.rice_bowl),
                            Row(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("이름"),
                                  Text("${waiting[position].name}"),
                                  TextButton(
                                    onPressed: () async{
                                      final memberRef = FirebaseFirestore.instance.collection('somoim/${_partyId}/memberList/${_partyId}/member').doc(waiting[position].memberID);
                                      await memberRef
                                          .set({
                                        'memberID' : waiting[position].memberID,
                                        'name' : waiting[position].name,
                                        'leaderYN' : "N" //소모임장은 Y 필요에 따라 포지션 자체를 넣어도 됨
                                      });

                                      final mySomoimRef = FirebaseFirestore.instance.collection('user/${waiting[position].memberID}/mySomoim').doc(_partyId);
                                      await mySomoimRef.set({
                                        'partyName' : _partyName,
                                        'partySubtitle' : _partySubtitle,
                                        'partyContents' : _partyContents,
                                        'partyCategory' : _partyCategory,
                                        'currentMemberCnt': (int.parse(_currentMemberCnt)+1).toString(),
                                        'maxMemberCnt' : _maxMemberCnt,
                                        'partyMaker' : _partyMaker,
                                        'partyId' : _partyId,
                                        'timeStamp' : _timeStamp,
                                      });

                                      String tmp ='exercise';

                                      if(_partyCategory == '운동')
                                      {
                                        tmp = 'exercise';
                                      }
                                      else if(_partyCategory == '먹방'){
                                        tmp = 'mukbang';
                                      }
                                      else if(_partyCategory == '게임'){
                                        tmp = 'game';
                                      }
                                      else if(_partyCategory == '여행'){
                                        tmp = 'trip';
                                      }
                                      FirebaseFirestore.instance.collection('user/${waiting[position].memberID}/waitSomoim')
                                        .doc(_partyId)
                                        .delete()
                                        .then(
                                          (doc)=>print("waitSomoim deleted"),
                                          onError: (e) => print("$e"));
                                      FirebaseFirestore.instance.collection('category/category/${tmp}')
                                        .doc(_partyId)
                                        .update({"currentMemberCnt":(int.parse(_currentMemberCnt)+1).toString()})
                                        .then(
                                          (doc) => print("category update"),
                                          onError: (e) => print("$e"));
                                      FirebaseFirestore.instance.collection('somoim')
                                          .doc(_partyId)
                                          .update({"currentMemberCnt":(int.parse(_currentMemberCnt)+1).toString()})
                                          .then(
                                            (doc) => print("somoim update")
                                            ,onError: (e) => print("$e"));
                                      FirebaseFirestore.instance.collection('somoim/${_partyId}/memberList/${_partyId}/waiting')
                                          .doc(waiting[position].memberID)
                                          .delete()
                                          .then(
                                            (doc)=>print("Document deleted")
                                            ,onError: (e) => print("$e"));

                                      setState(() {});

                                    },
                                    child: Center(child: Text("승인", textAlign: TextAlign.right),)
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance.collection('somoim/${_partyId}/memberList/${_partyId}/waiting').doc(waiting[position].memberID).delete();
                                      setState(() {});
                                    },
                                    child: Center(child: Text("거절", textAlign: TextAlign.right )))]
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ),
              ],
            );
          }
      ),
    );
  }
}