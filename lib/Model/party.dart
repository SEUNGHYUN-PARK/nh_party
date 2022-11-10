import 'package:cloud_firestore/cloud_firestore.dart';
class Party {
  DocumentReference? ref;
  String? partyName;
  String? partySubtitle;
  String? partyContents;
  String? partyCategory;
  String? currentMemberCnt;
  String? maxMemberCnt;
  String? partyMaker;
  String? partyId;
  String? timeStamp;

  Party({
    this.partyName,
    this.partySubtitle,
    this.partyContents,
    this.partyCategory,
    this.currentMemberCnt,
    this.maxMemberCnt,
    this.partyMaker,
    this.partyId,
    this.timeStamp,
  });
  Party.fromJson(dynamic json, this.ref):
        partyName = json["partyName"],
        partySubtitle = json["partySubtitle"],
        partyContents = json["partyContents"],
        partyCategory = json["partyCategory"],
        currentMemberCnt = json["currentMemberCnt"],
        maxMemberCnt = json["maxMemberCnt"],
        partyMaker = json["partyMaker"],
        partyId = json["partyId"],
        timeStamp = json["timeStamp"]
  ;

  Map<String, dynamic> toJson() => {
    'partyName': partyName,
    'partySubtitle': partySubtitle,
    'partyContents': partyContents,
    'partyCategory': partyCategory,
    'currentMemberCnt': currentMemberCnt,
    'maxMemberCnt': maxMemberCnt,
    'partyMaker': partyMaker,
    'partyId': partyId,
    'timeStamp': timeStamp,
  };
  Party.fromSnapShot(DocumentSnapshot<Map<String,dynamic>> snp)
      : this.fromJson(snp.data(), snp.reference);
  Party.fromQuerySnapShot(
      QueryDocumentSnapshot<Map<String,dynamic>> snp)
      : this.fromJson(snp.data(), snp.reference);
}