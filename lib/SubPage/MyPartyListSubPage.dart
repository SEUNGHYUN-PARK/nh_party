import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${_userName}님의 관심사를 바탕으로 정리해봤어요",style: TextStyle(fontWeight: FontWeight.w600),),
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
              child: Container(
                height: MediaQuery.of(context).size.height*0.83,
                child: FutureBuilder(
                  future: getMyCategory(_chooseFav),
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
                      if(category_mdl.length == 0){
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text('해당 카테고리의 소모임이 없습니다!')]
                        );
                      }
                      else{
                        // return CarouselSlider.builder(
                        //   itemCount:category_mdl.length,
                        //   itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                        //       ListTile(
                        //         title:Text("${category_mdl[itemIndex].partyName} (${category_mdl[itemIndex].currentMemberCnt}/${category_mdl[itemIndex].maxMemberCnt})"),
                        //         subtitle: Text("${category_mdl[itemIndex].partySubtitle}"),
                        //         leading: Icon(Icons.account_box_sharp),
                        //         onTap: (){
                        //           print("${category_mdl[itemIndex].partyName}");
                        //           Navigator.push(context,MaterialPageRoute(builder: (context){
                        //             return DetailPageMain("${category_mdl[itemIndex].partyId}");
                        //           })
                        //           );
                        //         },
                        //       ),
                        //   options: CarouselOptions(
                        //     height: 400,
                        //     aspectRatio: 16/9,
                        //     viewportFraction: 0.8,
                        //     initialPage: 0,
                        //     enableInfiniteScroll: true,
                        //     reverse: false,
                        //     autoPlay: true,
                        //     autoPlayInterval: Duration(seconds: 3),
                        //     autoPlayAnimationDuration: Duration(milliseconds: 800),
                        //     autoPlayCurve: Curves.fastOutSlowIn,
                        //     enlargeCenterPage: true,
                        //     scrollDirection: Axis.horizontal,
                        //   ),
                        // );
                        return AnimationLimiter(
                            child: ListView.builder(
                              itemCount:category_mdl.length,
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
                                                  print("${category_mdl[position].partyName}");
                                                  Navigator.push(context,MaterialPageRoute(builder: (context){
                                                    return DetailPageMain("${category_mdl[position].partyId}");
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
                                                      child: category_mdl[position].partyCategory == "운동" ? Image(image: AssetImage("assets/image/category/exercise.png"),height: 92,width: 92,) :
                                                      category_mdl[position].partyCategory == "먹방" ? Image(image: AssetImage("assets/image/category/mukbang.png"),height: 92,width: 92) :
                                                      category_mdl[position].partyCategory == "여행" ? Image(image: AssetImage("assets/image/category/trip.png"),height: 92,width: 92) :
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
                                                              Text(category_mdl[position].partyName!,
                                                                  style : headerTextStyle
                                                              ),
                                                              Container(
                                                                  height: 10.0
                                                              ),
                                                              Text(category_mdl[position].partySubtitle!,
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
                                                                  Text("${category_mdl[position].currentMemberCnt!} / ${category_mdl[position].maxMemberCnt!}",style: regularTextStyle,)
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
            ),
          ],
        ) ,
    );
  }
}
