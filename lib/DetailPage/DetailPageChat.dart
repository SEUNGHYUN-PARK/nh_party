import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nh_party/chat/message.dart';
import 'package:nh_party/chat/new_message.dart';

class DetailPageChat extends StatefulWidget {
  String partyId = '';
  DetailPageChat(this.partyId,{Key? key}) : super(key: key);

  @override
  State<DetailPageChat> createState() => _DetailPageChatState(this.partyId);
}

class _DetailPageChatState extends State<DetailPageChat> {

  String partyId='';

  _DetailPageChatState(String partyId){
    this.partyId=partyId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Messages(partyId)
          ),
          NewMessage(partyId),
        ]
      ),
    );
  }
}
