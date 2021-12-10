import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  String? uid;
  String? email;

  UserModel({this.uid, this.email});
  //tomar datos del servidor
  factory UserModel.fromMap(map){
    return UserModel(
      uid:map['uid'],
      email: map['email']
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'uid':uid,
      'email':email
    };
  }
}