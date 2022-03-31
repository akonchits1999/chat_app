import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String email;
  String name;
  String image;
  Timestamp date;
  String uid;



  UserModel({
    required this.email,
    required this.name,
    required this.image,
    required this.date,
    required this.uid
 });

  factory UserModel.fromJson(DocumentSnapshot snapshot){
    return UserModel(
      email: (snapshot.data() as dynamic)['email'],
      name:(snapshot.data() as dynamic)['name'],
      image: (snapshot.data() as dynamic)['image'],
      date: (snapshot.data() as dynamic)['date'],
      uid: (snapshot.data() as dynamic)['uid'],
    );
  }
}