import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DetailPageOutline extends StatefulWidget {
  String partyId = '';
  DetailPageOutline(this.partyId, {Key? key}) : super(key: key);

  @override
  State<DetailPageOutline> createState() => _DetailPageOutlineState(partyId);
}

class _DetailPageOutlineState extends State<DetailPageOutline> {

  String partyId = '';
  String partyName='';
  String partySubtitle = '';
  String partyContents = '';
  String partyCategory = '';
  String currentMemberCnt = '';
  String maxMemberCnt = '';
  String partyMaker = '';

  _DetailPageOutlineState(String partyId)
  {
    this.partyId = partyId;
    //print(partyId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> getPartyInfo() async{
    final docs = await FirebaseFirestore.instance.collection("partyName").doc(partyId).get()
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
                  height: 300,
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
            ],
          );
        }
      ),
    );
  }
}
