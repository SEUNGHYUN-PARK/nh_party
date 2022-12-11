import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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

  Future<bool> getPageInfo() async{

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
    return FutureBuilder(
      future : getPageInfo(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Scaffold(
          body: Container(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                            top:30,
                            child:Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width-40,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Color(0xff333366),
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 15,
                                        spreadRadius: 5
                                    )
                                  ]
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(top : 80),
                                      child: Text("${_partyName}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 30,color: Colors.white),textAlign: TextAlign.center,)
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child : Text("${_partySubtitle} (${_currentMemberCnt}/${_maxMemberCnt})",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: Color(0xffb6b2df)),textAlign: TextAlign.center,)
                                  ),
                                ],
                              ),
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(top:10),
                          alignment: FractionalOffset.topCenter,
                          child: _partyCategory == "운동" ? Image(image: AssetImage("assets/image/category/exercise.png"),height: 92,width: 92,) :
                          _partyCategory == "먹방" ? Image(image: AssetImage("assets/image/category/mukbang.png"),height: 92,width: 92) :
                          _partyCategory == "여행" ? Image(image: AssetImage("assets/image/category/trip.png"),height: 92,width: 92) :
                          _partyCategory == "게임" ? Image(image: AssetImage("assets/image/category/game.png"),height: 92,width: 92) : null,
                        ),
                        if(!_isMember)
                          Positioned(
                            top:310,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("소모임의 멤버가 아니시네요!"),
                                  Text("하단의 소모임 가입 신청 버튼을 눌러주세요"),
                                  Text("소모임장의 승인 후 이용 가능하십니다"),
                                  Container(
                                    child: ElevatedButton(
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
                                        child: Text("소모임 가입 신청")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if(_isMember)
                        Positioned(
                          top:250,
                          child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left:20),
                                  child: Text("모임일정",style: TextStyle(fontSize:20,fontWeight: FontWeight.w400),)),
                              ],
                          ),
                        ),
                        if(_isMember)
                        Positioned(
                          top: 280,
                          left: 15,
                          width: MediaQuery.of(context).size.width-40,
                          child: Container(
                            alignment: FractionalOffset.center,
                            child: SizedBox(
                                height: 200,
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
                                    return AnimationLimiter(
                                      child: ListView.builder(
                                        itemCount: docs.length,
                                        itemBuilder: (context, index) {
                                          return AnimationConfiguration.staggeredList(
                                            position: index,
                                            duration: const Duration(milliseconds: 375),
                                            child: SlideAnimation(
                                              verticalOffset: 50.0,
                                              child: FadeInAnimation(
                                                child: Center(
                                                  child: Card(
                                                    child : Container(
                                                      height: 50,
                                                      margin: EdgeInsets.symmetric(vertical: 5,horizontal:5),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(context).size.width/11,
                                                            child: Padding(
                                                              padding: EdgeInsets.all(4.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children:[Icon(Icons.calendar_month,size: 30,),]
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width : (MediaQuery.of(context).size.width)/3,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  docs[index]['name'] + "(" + docs[index]['person'] + "명)",
                                                                  style: TextStyle(fontSize: 15.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: (MediaQuery.of(context).size.width)/2.5,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Text(
                                                                  docs[index]['date'] + " " + docs[index]['time'],
                                                                  style: TextStyle(fontSize: 10.0),
                                                                ),
                                                                Text(
                                                                  docs[index]['place'],
                                                                  style: TextStyle(fontSize: 10.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ),
          floatingActionButton: _isMember ? FloatingActionButton(
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) =>DetailPageAppointmentNew(_partyId)));
            },
            child: Icon(Icons.add),
          ) : null,
        );
      }
    );
  }
}
