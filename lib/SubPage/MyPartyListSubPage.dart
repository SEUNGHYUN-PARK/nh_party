import 'package:flutter/material.dart';

class MyPartyListSubPage extends StatefulWidget {
  const MyPartyListSubPage({Key? key}) : super(key: key);

  @override
  State<MyPartyListSubPage> createState() => _MyPartyListSubPageState();
}

class _MyPartyListSubPageState extends State<MyPartyListSubPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("가입한 모임"),
          SizedBox(
            height: 300,
              child:ListView.builder(itemBuilder: (context,position){
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
          Text("ㅇㅇㅇ님의 관심사를 바탕으로 정리해봤어요",textAlign: TextAlign.left,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ElevatedButton(onPressed: (){}, child: Text("#해시태그1")),
              ElevatedButton(onPressed: (){}, child: Text("#해시태그2")),
              ElevatedButton(onPressed: (){}, child: Text("#해시태그3")),],
          )

        ],
      ),
    );
  }
}
