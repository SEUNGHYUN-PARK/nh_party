import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nh_party/DetailPage/DetailPageMain.dart';
import 'package:intl/intl.dart';

class MakePartySubPage extends StatefulWidget {
  const MakePartySubPage({Key? key}) : super(key: key);

  @override
  State<MakePartySubPage> createState() => _MakePartySubPageState();
}

class _MakePartySubPageState extends State<MakePartySubPage> {
  final _formkey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  final List<String> _valueList = ['운동','먹방','게임','여행'];
  String _partyName = "";
  String _partyContents = "";
  String _partyCategory = "";
  String _maxMemberCnt = "";
  String _partySubtitle = "";
  String _selectedValue = "운동";

  void _tryValidation(){
    final isValid = _formkey.currentState!.validate();
    if(isValid){
      _formkey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("소모임 만들기",
          style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30,left: 30,right: 30),
        child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        labelText: "소모임명",
                        border: OutlineInputBorder()
                    ),
                    child: TextFormField(
                      key : ValueKey(1),
                      decoration: InputDecoration(border: InputBorder.none),
                      validator: (String? value){
                        if(value==null||value.isEmpty)
                        {
                          return "소모임명을 입력해주세요";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _partyName = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        labelText: "소모임 한줄 소개",
                        border: OutlineInputBorder()
                    ),
                    child: TextFormField(
                      key : ValueKey(2),
                      decoration: InputDecoration(border: InputBorder.none),
                      validator: (String? value){
                        if(value==null||value.isEmpty)
                        {
                          return "소모임명을 입력해주세요";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _partySubtitle = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        labelText: "소모임 내용",
                        border: OutlineInputBorder()
                    ),
                    child: TextFormField(
                      key : ValueKey(3),
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(border: InputBorder.none),
                      validator: (String? value){
                        if(value==null||value.isEmpty)
                        {
                          return "소모임 취지 및 활동 내용을 입력해주세요";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _partyContents = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        labelText: "최대 정원",
                        border: OutlineInputBorder()
                    ),
                    child: TextFormField(
                      key : ValueKey(4),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                      decoration: InputDecoration(border: InputBorder.none),
                      validator: (String? value){
                        if(value==null||value.isEmpty)
                        {
                          return "최대 정원 수를 입력해주세요";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _maxMemberCnt = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      child: InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            border: OutlineInputBorder(),
                            labelText: "소모임 분류"
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
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
                                _partyCategory = _selectedValue;
                              });
                            },
                            hint: Text("선택하세요"),

                          ),
                        ),
                      )
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () async {
                        _tryValidation();
                        try{
                          var timeStamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
                          final partyRef = FirebaseFirestore.instance.collection('somoim').doc();
                          await partyRef
                              .set({
                            'partyName' : _partyName,
                            'partySubtitle' : _partySubtitle,
                            'partyContents' : _partyContents,
                            'partyCategory' : _selectedValue,
                            'currentMemberCnt': "1",
                            'maxMemberCnt' : _maxMemberCnt,
                            'partyMaker' : _authentication.currentUser!.uid,
                            'partyId' : partyRef.id,
                            'timeStamp' : timeStamp,
                          });

                          var tmp = '';
                          if(_selectedValue == "운동"){
                            tmp = 'exercise';
                          }
                          else if(_selectedValue == "먹방"){
                            tmp = 'mukbang';
                          }
                          else if(_selectedValue == "게임"){
                            tmp = 'game';
                          }
                          else if (_selectedValue == "여행"){
                            tmp = 'trip';
                          }


                          final categoryRef = FirebaseFirestore.instance.collection('category').doc('category').collection('${tmp}').doc(partyRef.id);
                          await categoryRef
                              .set({
                            'partyName' : _partyName,
                            'partySubtitle' : _partySubtitle,
                            'partyContents' : _partyContents,
                            'partyCategory' : _selectedValue,
                            'currentMemberCnt': "1",
                            'maxMemberCnt' : _maxMemberCnt,
                            'partyMaker' : _authentication.currentUser!.uid,
                            'partyId' : partyRef.id,
                            'timeStamp' : timeStamp,
                          });

                          if(partyRef != null){
                            Navigator.push(context,MaterialPageRoute(builder: (context){
                              return DetailPageMain(partyRef.id);
                            })
                            );
                          }
                        }
                        catch(e){
                          final message = e.toString();
                          Fluttertoast.showToast(msg:message,fontSize:10);
                        }
                      }, child: Text("생성"),),
                  )
                ],
              ),
            )
        ),
      )
    );
  }
}
