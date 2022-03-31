import 'package:chat_app/widgets/message_widget.dart';
import 'package:chat_app/widgets/single_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';


class ChatScreen extends StatelessWidget {

  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  ChatScreen({
    required this.friendImage,
    required this.currentUser,
    required this.friendId,
    required this.friendName,
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(friendImage,height: 35,),
            ),
            const SizedBox(width: 5,),
            Text(friendName,style: TextStyle(fontSize: 20),)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(currentUser.uid).collection("messages").doc(friendId).collection('chats').orderBy("date",descending: true).snapshots(),
              builder: (context,AsyncSnapshot snapshot){
                if (snapshot.hasData){
                  if(snapshot.data.docs.length < 1){
                    return const Center(
                      child: Text("say smth"),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index){
                      bool isMe = snapshot.data.docs[index]['senderId'] == currentUser.uid;
                      return SingleMessage(message: snapshot.data.docs[index]['message'], isMe: isMe);
                    });
                  
                }return Center(
                  child: CircularProgressIndicator(),
                );
              },
              
            ),
          )),
          MessageTextField(currentUser.uid,friendId)
        ],
      ),
    );
  }
}
