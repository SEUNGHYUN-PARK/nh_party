import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nh_party/Model/appointment.dart';

class DetailPageAppointmentNew extends StatefulWidget {
  String partyId = '';

  DetailPageAppointmentNew(this.partyId, {Key? key}) : super(key: key);

  @override
  State<DetailPageAppointmentNew> createState() =>
      _DetailPageAppointmentNew(partyId);
}

class _DetailPageAppointmentNew extends State<DetailPageAppointmentNew> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  void _tryValidation() {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      _formkey.currentState!.save();
    }
  }

  String partyId = '';

  _DetailPageAppointmentNew(String partyId) {
    this.partyId = partyId;
  }

  String _name = '';
  String _date = '';
  String _time = '';
  String _place = '';
  String _person = '';

  Future createNewAppointment(String partyId, Map<String, dynamic> json) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance
        .collection("somoim")
        .doc(partyId)
        .collection("appointment")
        .doc();
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await documentReference.get();

    if (!documentSnapshot.exists) {
      await documentReference.set(json);
    }
  }

  // 날짜 입력안할시에 올라오는 알럿창
  void dateDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("날짜를 입력하세요."),
              ],
            ),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  // 시간 입력안할시에 올라오는 알럿창
  void timeDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("시간을 입력하세요."),
              ],
            ),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    dateinput.text = "";
    timeinput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "정모 개설",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 30, left: 30, right: 30),
            child: SingleChildScrollView(
                child: Form(
                    key: _formkey,
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      InputDecorator(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              labelText: "정모명",
                              border: OutlineInputBorder()),
                          child: TextFormField(
                            key: ValueKey(1),
                            decoration:
                            InputDecoration(border: InputBorder.none),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "정모명을 입력해주세요";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _name = value!;
                              });
                            },
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      InputDecorator(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              labelText: "정모 날짜",
                              border: OutlineInputBorder()),
                          child: TextFormField(
                            key: ValueKey(2),
                            controller: dateinput,
                            decoration:
                            InputDecoration(border: InputBorder.none),
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );

                              if (pickedDate != null) {
                                print(pickedDate);
                                String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(formattedDate);

                                setState(() {
                                  dateinput.text = formattedDate;
                                });
                              } else {
                                dateDialog();
                              }
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "정모 날짜를 입력해주세요";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _date = value!;
                              });
                            },
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            labelText: "정모 시간",
                            border: OutlineInputBorder()),
                        child: TextFormField(
                          key: ValueKey(3),
                          decoration: InputDecoration(border: InputBorder.none),
                          controller: timeinput,
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              print(pickedTime);
                              String formattedTime =
                                  '${pickedTime.hour.toString()}:${pickedTime.minute.toString()}';
                              print(formattedTime);

                              setState(() {
                                timeinput.text = formattedTime;
                              });
                            } else {
                              timeDialog();
                            }
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "정모 시간을 입력해주세요";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _time = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            labelText: "정모 장소",
                            border: OutlineInputBorder()),
                        child: TextFormField(
                          key: ValueKey(4),
                          decoration: InputDecoration(border: InputBorder.none),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "정모 장소를 입력해주세요";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _place = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            labelText: "정모 인원",
                            border: OutlineInputBorder()),
                        child: TextFormField(
                          key: ValueKey(5),
                          decoration: InputDecoration(border: InputBorder.none),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "정모 인원을 입력해주세요";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _person = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          child: ElevatedButton(
                              child: Text("정모일정 추가"),
                              onPressed: () async {
                                _tryValidation();
                                AppoinmentModel _appointmentModel =
                                AppoinmentModel(
                                    name: _name,
                                    date: dateinput.text,
                                    time: timeinput.text,
                                    place: _place,
                                    person: _person);
                                await createNewAppointment(
                                    partyId, _appointmentModel.toJson());
                                Navigator.pop(context);
                              })),
                    ])))));
  }
}
