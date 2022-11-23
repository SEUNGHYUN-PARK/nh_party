import 'package:cloud_firestore/cloud_firestore.dart';

class AppoinmentModel {
  AppoinmentModel({
    this.name,
    this.date,
    this.time,
    this.place,
    this.person,
  });

  String? name;
  String? date;
  String? time;
  String? place;
  String? person;
  DocumentReference? reference;

  AppoinmentModel.fromJson(dynamic json, this.reference) {
    name = json['name'];
    date = json['date'];
    time = json['time'];
    place = json['place'];
    person = json['person'];
  }

  AppoinmentModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot) : this.fromJson(snapshot.data(), snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['date'] = date;
    map['time'] = time;
    map['place'] = place;
    map['person'] = person;
    return map;
  }
}