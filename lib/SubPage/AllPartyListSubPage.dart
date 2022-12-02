import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
    CollectionReference<Map<String,dynamic>> res = FirebaseFirestore.instance.collection("somoim");
    QuerySnapshot<Map<String,dynamic>> qrysnp = await res.get(); //
    //.orderBy("timeStamp",descending: true)
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
    final baseTextStyle = const TextStyle(
        fontFamily: 'NanumBarunGothic'
    );
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 9.0,
        fontWeight: FontWeight.w400
    );
    final subHeaderTextStyle = regularTextStyle.copyWith(
        fontSize: 12.0
    );
    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w600
    );

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
                  return AnimationLimiter(
                      child: ListView.builder(
                        itemCount:mdl.length,
                        itemBuilder: (context,position) {
                          return AnimationConfiguration.staggeredList(
                            position: position,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical : 16.0,
                                        horizontal: 24.0,
                                      ),
                                      child : GestureDetector(
                                        onTap: (){
                                          print("${mdl[position].partyName}");
                                          Navigator.push(context,MaterialPageRoute(builder: (context){
                                            return DetailPageMain("${mdl[position].partyId}");
                                          }));
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 124,
                                              margin: EdgeInsets.only(left: 46),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff333366),
                                                  shape:BoxShape.rectangle,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  boxShadow : <BoxShadow>[BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 10.0,
                                                      offset: Offset(0.0,10.0)
                                                  )]
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(vertical: 16),
                                              alignment: FractionalOffset.centerLeft,
                                              child: mdl[position].partyCategory == "운동" ? Image(image: AssetImage("assets/image/category/exercise.png"),height: 92,width: 92,) :
                                                     mdl[position].partyCategory == "먹방" ? Image(image: AssetImage("assets/image/category/mukbang.png"),height: 92,width: 92) :
                                                     mdl[position].partyCategory == "여행" ? Image(image: AssetImage("assets/image/category/trip.png"),height: 92,width: 92) :
                                                     Image(image: AssetImage("assets/image/category/game.png"),height: 92,width: 92)
                                              ,
                                            ),
                                            SizedBox(
                                              height: 130,
                                              width: 400,
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(100, 16, 16, 16),
                                                constraints: BoxConstraints.expand(),
                                                child: SizedBox(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 4.0,
                                                      ),
                                                      Text(mdl[position].partyName!,
                                                          style : headerTextStyle
                                                      ),
                                                      Container(
                                                          height: 10.0
                                                      ),
                                                      Text(mdl[position].partySubtitle!,
                                                          style : subHeaderTextStyle
                                                      ),
                                                      Container(
                                                          margin: EdgeInsets.symmetric(vertical: 8.0),
                                                          height:2.0,
                                                          width: 18.0,
                                                          color :  Color(0xff00c6ff)
                                                      ),
                                                      Row(
                                                        children: [
                                                          Image.asset("assets/image/group.png",height:25.0),
                                                          Container(width: 8.0),
                                                          Text("${mdl[position].currentMemberCnt!} / ${mdl[position].maxMemberCnt!}",style: regularTextStyle,)
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ));
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
