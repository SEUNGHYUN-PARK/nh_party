import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Model/board.dart';

import 'board/DetailPageBoardNew.dart';
import 'board/DetailPageBoardSub.dart';


class DetailPageBoard extends StatefulWidget {
  String partyId='';
  DetailPageBoard(this.partyId,{Key? key}) : super(key: key);

  @override
  State<DetailPageBoard> createState() => _DetailPageBoardState(partyId);
}

class _DetailPageBoardState extends State<DetailPageBoard> {

  String partyId = '';

  _DetailPageBoardState(String partyId){
    this.partyId = partyId;
  }
  List<Board> mdl = [];

  Future<bool> getAllData() async{
    CollectionReference<Map<String,dynamic>> res = FirebaseFirestore.instance.collection("somoim/${partyId}/board/${partyId}/post");
    QuerySnapshot<Map<String,dynamic>> qrysnp = await res.orderBy("timeStamp",descending: true).get(); //

    mdl = [];
    for (var doc in qrysnp.docs)
    {
      Board m = Board.fromQuerySnapShot(doc);
      mdl.add(m);
      print("${m.partyId},${m.title}");
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      body: FutureBuilder(
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
              return Text('게시글을 추가하세요');
            }
            else{
              return ListView.builder(
                itemCount:mdl.length,
                itemBuilder: (context,position) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context){
                      return DetailPageBoardSub("${mdl[position].partyId}","${mdl[position].postId}");
                    }));
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          shape:BoxShape.rectangle,
                        ),
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:[
                                      Icon(Icons.eco,size: 30,),]
                                ),
                              ),
                            ),
                            Container(
                              width : 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    mdl[position].title!,
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    mdl[position].contents!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 15.0,color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width : 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    mdl[position].timeStamp!.toString().substring(0,8),
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                },
              );
            }
          }
        },
      ) ,
      floatingActionButton: FloatingActionButton(
        child : Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPageBoardNew(partyId)));
        },
      ),
    );
  }
}
