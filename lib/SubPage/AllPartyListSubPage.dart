import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nh_party/SubPage/MakePartySubPage.dart';
import '../DetailPage/DetailPageMain.dart';
import '../Model/party.dart';

class AllPartyListSubPage extends StatefulWidget {
  const AllPartyListSubPage({Key? key}) : super(key: key);

  @override
  State<AllPartyListSubPage> createState() => _AllPartyListSubPageState();
}

class _AllPartyListSubPageState extends State<AllPartyListSubPage> {
  List<Party> mdl = [];

  Future<bool> getAllData() async{
    CollectionReference<Map<String,dynamic>> res = FirebaseFirestore.instance.collection("partyName");
    QuerySnapshot<Map<String,dynamic>> qrysnp = await res.orderBy("timeStamp",descending: true).get(); //

    mdl = [];
    for (var doc in qrysnp.docs)
    {
      Party m = Party.fromQuerySnapShot(doc);
      mdl.add(m);
      print("${m.partyName},${m.partySubtitle}");
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child: Center(
          child: FutureBuilder(
            future: getAllData(),
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
                  return Text('소모임을 추가하세요');
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
          ) ,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child : Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MakePartySubPage()));
        },
      ),
    );
  }
}
