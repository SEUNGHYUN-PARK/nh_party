import 'package:flutter/material.dart';
import 'package:nh_party/SubPage/MakePartySubPage.dart';

class AllPartyListSubPage extends StatefulWidget {
  const AllPartyListSubPage({Key? key}) : super(key: key);

  @override
  State<AllPartyListSubPage> createState() => _AllPartyListSubPageState();
}

class _AllPartyListSubPageState extends State<AllPartyListSubPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child: Center(
          child: ListView.builder(
              itemBuilder: (context,position) {
                return Card(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.liquor,size: 50,color: Colors.red,),
                      Padding(padding: EdgeInsets.only(right: 3)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text("모임명"),Text("모임소개글")],
                      ),
                      Column(

                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text("현인원/인원한도")],
                      ),
                      Column(

                      )
                    ],
                  ),
                );
              },
            itemCount: 3,
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
