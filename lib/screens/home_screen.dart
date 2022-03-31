import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {

  final UserModel userModel;

  HomeScreen(this.userModel);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('chat app'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(onPressed:  () async{
            //firestore.collection('users').doc(userCredential.user!.uid).get();
            await GoogleSignIn().signOut();
            //await FirebaseAuth.instance.currentUser?.delete();
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>AuthScreen()), (route) => false);


          }, icon:const Icon(Icons.logout))
        ],

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.email),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen(widget.userModel)));

        },
      ),
    );
  }
}
