import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future signInFunc() async{
   GoogleSignInAccount? user = await googleSignIn.signIn();
   if (user == null){
     return;
   }
   final googleAuth = await user.authentication;
   final credential = GoogleAuthProvider.credential(
     accessToken: googleAuth.accessToken,
     idToken: googleAuth.idToken
   );
   // добаление пользователя и вход с уже созданным юзером
   UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
   DocumentSnapshot userInDb = await firestore.collection('users').doc(userCredential.user!.uid).get();


   if (userInDb.exists){
     print('there is such user');
   }else{
     await firestore.collection('users').doc(userCredential.user!.uid).set({
       'email' : userCredential.user!.email,
       'name'  : userCredential.user!.displayName,
       'image' : userCredential.user!.photoURL,
       'uid'   : userCredential.user!.uid,
       'date'  :DateTime.now(),
     });
   }

   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>MyApp()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://avatars.mds.yandex.net/i?id=14e2abf66db52e302c25745d8e5b3c7b-5194768-images-thumbs&n=13"))),
              ),
            ),
            Text("Chat App" , style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            ElevatedButton(onPressed: () async {
               await signInFunc();
            }, child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network("https://catherineasquithgallery.com/uploads/posts/2021-02/1614277155_6-p-chernii-fon-gugl-6.jpg",height: 35,width: 40,),
                SizedBox(width: 14,),
                Text("sign in with google", style: TextStyle(fontSize: 20),)
              ],
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black87),
              padding: MaterialStateProperty.all(EdgeInsets.zero)
            ),)
          ],
        ),
      ),
    );
  }
}
