import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Model/member.dart';

class DetailPageOutline extends StatefulWidget {
  String partyId = '';
  DetailPageOutline(this.partyId, {Key? key}) : super(key: key);

  @override
  State<DetailPageOutline> createState() => _DetailPageOutlineState(partyId);
}

class _DetailPageOutlineState extends State<DetailPageOutline> {

  final _authentication = FirebaseAuth.instance;

  String partyId = '';
  String partyName='';
  String partySubtitle = '';
  String partyContents = '';
  String partyCategory = '';
  String currentMemberCnt = '';
  String maxMemberCnt = '';
  String partyMaker = '';
  bool isMember = false; // 가입 상태면 true 미가입상태면 false
  String _name = '';

  _DetailPageOutlineState(String partyId)
  {
    this.partyId = partyId;
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

    CollectionReference<Map<String,dynamic>> res = FirebaseFirestore.instance.collection("somoim/${partyId}/memberList/${partyId}/member");
    QuerySnapshot<Map<String,dynamic>> qrysnp = await res.get(); //

    for (var doc in qrysnp.docs)
    {
      Member m = Member.fromQuerySnapShot(doc);
      if(_authentication.currentUser!.uid == m.memberID)
      {
        isMember=true;
      }
      print("${m.name},${m.memberID}");
    }
    return true;

    return true;
  }

  Future<bool> getPartyInfo() async{
    final docs = await FirebaseFirestore.instance.collection("somoim").doc(partyId).get()
                 .then((DocumentSnapshot doc){
                   currentMemberCnt = doc["currentMemberCnt"];
                   maxMemberCnt = doc["maxMemberCnt"];
                   partyName = doc["partyName"];
                   partySubtitle = doc["partySubtitle"];
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
                children: [Text("${partyName} (${currentMemberCnt} / ${maxMemberCnt})")],
              ),
              Padding(padding: EdgeInsets.all(20)),
              Text("${partySubtitle}",textAlign: TextAlign.left,),
              Padding(padding: EdgeInsets.all(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("모임일정"),Icon(Icons.add)],
              ),
              SizedBox(
                  height: 200,
                  child: ListView.builder(itemBuilder: (context,position){
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
              ),
              if(!isMember)
              ElevatedButton(
                onPressed: () async{

                  final waitingRef = FirebaseFirestore.instance.collection('somoim/${partyId}/memberList/${partyId}/waiting').doc(_authentication.currentUser!.uid);
                  await waitingRef
                      .set({
                    'memberID' : _authentication.currentUser!.uid,
                    'name' : _name,
                    'leaderYN' : "N" //소모임장은 Y 필요에 따라 포지션 자체를 넣어도 됨
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
