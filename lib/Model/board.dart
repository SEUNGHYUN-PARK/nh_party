import 'package:cloud_firestore/cloud_firestore.dart';
class Board {
  DocumentReference? ref;
  String? partyId;
  String? postId;
  String? writer;
  String? title;
  String? contents;
  String? timeStamp;

  Board({
    this.partyId,
    this.postId,
    this.writer,
    this.title,
    this.contents,
    this.timeStamp,
  });

  Board.fromJson(dynamic json, this.ref):
        partyId = json["partyId"],
        postId = json["postId"],
        writer = json["writer"],
        title = json["title"],
        contents = json["contents"],
        timeStamp = json["timeStamp"]
  ;

  Map<String, dynamic> toJson() => {
    'partyId': partyId,
    'postId': postId,
    'writer': writer,
    'title': title,
    'contents': contents,
    'timeStamp': timeStamp,
  };
  Board.fromSnapShot(DocumentSnapshot<Map<String,dynamic>> snp)
      : this.fromJson(snp.data(), snp.reference);
  Board.fromQuerySnapShot(
      QueryDocumentSnapshot<Map<String,dynamic>> snp)
      : this.fromJson(snp.data(), snp.reference);
}