import 'package:flutter/material.dart';

class DetailPageOutline extends StatefulWidget {
  const DetailPageOutline({Key? key}) : super(key: key);

  @override
  State<DetailPageOutline> createState() => _DetailPageOutlineState();
}

class _DetailPageOutlineState extends State<DetailPageOutline> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("소모임명 :  인원수 :   ")],
          ),
          Padding(padding: EdgeInsets.all(20)),
          Text("소모임소개글",textAlign: TextAlign.left,),
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
      ),
    );
  }
}
