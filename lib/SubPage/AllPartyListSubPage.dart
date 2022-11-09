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
              itemCount:10,
              itemBuilder: (context,position) {
                return Column(
                  children: [
                    ListTile(
                      title:Text("테니스 같이 치실분 모집합니다 (1/5)"),
                      subtitle: Text("같이 테니스쳐요~~"),
                      leading: Icon(Icons.account_box_sharp),
                      onTap: (){
                        print("눌러짐");
                      },
                    ),
                    Container(
                      height: 1,
                      color: Colors.black,
                    )
                  ],
                );
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
