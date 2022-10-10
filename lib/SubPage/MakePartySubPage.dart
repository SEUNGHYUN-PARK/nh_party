import 'package:flutter/material.dart';



class MakePartySubPage extends StatefulWidget {
  const MakePartySubPage({Key? key}) : super(key: key);

  @override
  State<MakePartySubPage> createState() => _MakePartySubPageState();
}

class _MakePartySubPageState extends State<MakePartySubPage> {
  final _makePartyKey = GlobalKey<FormState>();
  String _title = "";
  final List<String> _valueList = ['운동','먹킷리스트','여행','게임','번개'];
  String _selectedValue = "운동";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("소모임 만들기")),
      body: Container(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
            child: Form(
              key: _makePartyKey,
              child: Column(
                children: <Widget>[
                  DropdownButton(
                    value: _selectedValue,
                    items: _valueList.map((value){
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "소모임명"),
                    validator: (String? value){
                      if(value==null||value.isEmpty)
                      {
                        return "소모임명을 입력해주세요";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _title = value!;
                      });
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 7,
                    minLines: 1,
                    decoration: InputDecoration(labelText: "소모임 취지, 대략적인 계획"),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "해시태그1"),),
                  TextFormField(
                    decoration: InputDecoration(labelText: "해시태그2"),),
                  TextFormField(
                    decoration: InputDecoration(labelText: "해시태그3"),),
                  Padding(padding: EdgeInsets.only(top: 20,bottom: 20)),
                  ElevatedButton(onPressed: (){}, child: Text("생성"))
                ],
              ),

            )
        ),
      )
    );
  }
}
