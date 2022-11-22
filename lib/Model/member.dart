import 'package:cloud_firestore/cloud_firestore.dart';
class Member {
  DocumentReference? ref;
  String? memberID;
  String? name;

  Member({
    this.memberID,
    this.name,

  });

  Member.fromJson(dynamic json, this.ref):
        memberID = json["memberID"],
        name = json["name"]
  ;

  Map<String, dynamic> toJson() => {
    'memberID': memberID,
    'name': name,
  };
  Member.fromSnapShot(DocumentSnapshot<Map<String,dynamic>> snp)
      : this.fromJson(snp.data(), snp.reference);
  Member.fromQuerySnapShot(
      QueryDocumentSnapshot<Map<String,dynamic>> snp)
      : this.fromJson(snp.data(), snp.reference);
}