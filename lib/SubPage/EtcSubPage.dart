import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../DetailPage/DetailPageMain.dart';
import '../Model/Somoim.dart';
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
  List<Somoim> mdl = [];

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

  Future<bool> getMySomoim() async{
    CollectionReference<Map<String,dynamic>> res = FirebaseFirestore.instance.collection("user/${_authentication.currentUser!.uid}/mySomoim/");
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyInfo();
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
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person),
              Text("$_userName??? ???????????????!"),
              SizedBox(width: 10,),
              OutlinedButton(
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UserInfoPage();
                  }));
                },
                child: Text("???????????? ??????",style: TextStyle(fontSize: 10),),
              ),
              SizedBox(width: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Text("????????????",style: TextStyle(fontSize: 10),),
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
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left:20),
                child: Text("?????? ?????????",textAlign: TextAlign.start,),
              ),
            ],
          ),

          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height*0.83,
              child: FutureBuilder(
                future: getMySomoim(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData == false){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator()
                      ],
                    );
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
                          children: [Text('?????? ???????????? ????????????!')]
                      );
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
                                                    child: mdl[position].partyCategory == "??????" ? Image(image: AssetImage("assets/image/category/exercise.png"),height: 92,width: 92,) :
                                                    mdl[position].partyCategory == "??????" ? Image(image: AssetImage("assets/image/category/mukbang.png"),height: 92,width: 92) :
                                                    mdl[position].partyCategory == "??????" ? Image(image: AssetImage("assets/image/category/trip.png"),height: 92,width: 92) :
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
              ),
            ),
          )
        ],
      )
    );
  }
}
