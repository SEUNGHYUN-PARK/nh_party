import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Model/member.dart';
import 'appointment/DetailPageAppointmentNew.dart';

class DetailPageOutline extends StatefulWidget {
  String partyId = '';
  DetailPageOutline(this.partyId, {Key? key}) : super(key: key);

  @override
  State<DetailPageOutline> createState() => _DetailPageOutlineState(partyId);
}

class _DetailPageOutlineState extends State<DetailPageOutline> {

  final _authentication = FirebaseAuth.instance;

  String _partyId = '';
  String _partyName='';
  String _partySubtitle = '';
  String _partyContents = '';
  String _partyCategory = '';
  String _currentMemberCnt = '';
  String _maxMemberCnt = '';
  String _partyMaker = '';
  String _timeStamp = '';
  bool _isMember = false; // 가입 상태면 true 미가입상태면 false
  String _name = '';

  _DetailPageOutlineState(String partyId)
  {
    this._partyId = partyId;
    //print(partyId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyInfo();
    setMemberYN();
  }


  Future<bool> getMyInfo() async{
    final myid = _authentication.currentUser!.uid;
    final docs = await FirebaseFirestore.instance.collection("user/${myid}/myInfo").doc(myid).get()
        .then((DocumentSnapshot doc){
      _name = doc["userName"];
    }
    );
    return true;
  }

  Future<bool> setMemberYN() async{

    CollectionReference<Map<String,dynamic>> res = FirebaseFirestore.instance.collection("somoim/${_partyId}/memberList/${_partyId}/member");
    QuerySnapshot<Map<String,dynamic>> qrysnp = await res.get(); //

    for (var doc in qrysnp.docs)
    {
      Member m = Member.fromQuerySnapShot(doc);
      if(_authentication.currentUser!.uid == m.memberID)
      {
        _isMember=true;
      }
      print("${m.name},${m.memberID}");
    }
    return true;

    return true;
  }

  Future<bool> getPartyInfo() async{
    final docs = await FirebaseFirestore.instance.collection("somoim").doc(_partyId).get()
                 .then((DocumentSnapshot doc){
                   _currentMemberCnt = doc["currentMemberCnt"];
                   _maxMemberCnt = doc["maxMemberCnt"];
                   _partyName = doc["partyName"];
                   _partySubtitle = doc["partySubtitle"];
                   _partyContents = doc["partyContents"];
                   _partyCategory = doc["partyCategory"];
                   _partyMaker = doc["partyMaker"];
                   _partyId = doc["partyId"];
                   _timeStamp = doc["timeStamp"];
      }
    );
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
              Padding(padding: EdgeInsets.all(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("${_partyName} (${_currentMemberCnt} / ${_maxMemberCnt})")],
              ),
              Padding(padding: EdgeInsets.all(20)),
              Text("${_partySubtitle}",textAlign: TextAlign.left,),
              Padding(padding: EdgeInsets.all(20)),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("모임일정            "),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailPageAppointmentNew(_partyId)),
                        );
                      },
                      child: Icon(Icons.add))
                ],
              ),
              SizedBox(
                  height: 300,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('somoim')
                        .doc(_partyId)
                        .collection('appointment')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final docs = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Column(children: <Widget>[
                              Row(children: <Widget>[
                                Text(
                                  docs[index]['name'],
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Text(
                                  "(" + docs[index]['person'] + "명)",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ]),
                              Row(children: <Widget>[
                                Text(
                                  docs[index]['date'],
                                  style: TextStyle(fontSize: 10.0),
                                ),
                                Text(
                                  " " + docs[index]['time'],
                                  style: TextStyle(fontSize: 10.0),
                                ),
                              ]),
                              Row(children: <Widget>[
                                Text(
                                  docs[index]['place'],
                                  style: TextStyle(fontSize: 10.0),
                                ),
                              ]),
                            ]),
                          );
                        },
                      );
                    },
                  )),
              if(!_isMember)
              ElevatedButton(
                onPressed: () async{

                  final waitingRef = FirebaseFirestore.instance.collection('somoim/${_partyId}/memberList/${_partyId}/waiting').doc(_authentication.currentUser!.uid);
                  await waitingRef
                      .set({
                    'memberID' : _authentication.currentUser!.uid,
                    'name' : _name,
                    'leaderYN' : "N" //소모임장은 Y 필요에 따라 포지션 자체를 넣어도 됨
                  });

                  final waitSomoimRef = FirebaseFirestore.instance.collection('user/${_authentication.currentUser!.uid}/waitSomoim').doc(_partyId);
                  await waitSomoimRef.set({
                    'partyName' : _partyName,
                    'partySubtitle' : _partySubtitle,
                    'partyContents' : _partyContents,
                    'partyCategory' : _partyCategory,
                    'currentMemberCnt': _currentMemberCnt,
                    'maxMemberCnt' : _maxMemberCnt,
                    'partyMaker' : _authentication.currentUser!.uid,
                    'partyId' : _partyId,
                    'timeStamp' : _timeStamp,
                  });

                  final message = '소모임 가입 신청 완료. 소모임장의 확인 후 이용 가능해요';
                  Fluttertoast.showToast(msg:message,fontSize:10);
                },
                child: Text("소모임 가입 신청"))
            ],
          );
        }
      ),
    );
  }
}
