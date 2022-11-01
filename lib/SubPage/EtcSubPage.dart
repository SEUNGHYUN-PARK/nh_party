import 'package:flutter/material.dart';

class EtcSubPage extends StatefulWidget {
  const EtcSubPage({Key? key}) : super(key: key);

  @override
  State<EtcSubPage> createState() => _EtcSubPageState();
}

class _EtcSubPageState extends State<EtcSubPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.person),
              Text("ㅇㅇㅇ님"),
              ElevatedButton(onPressed: (){}, child: Text("수정"))
            ],
          ),
          Text("내가 찜한 목록"),
          Expanded(
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
          )


        ],
      )

    );
  }
}