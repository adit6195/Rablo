import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userPhone;
  String userName;
  String pass;
  String email;
  bool isAdmin;
  bool isActive;
  Timestamp lastUsed;
  Timestamp signUp;

  UserModel({
    required this.userName,
    required this.userPhone,
    required this.pass,
    required this.email,
    required this.isAdmin,
    required this.isActive,
    required this.lastUsed,
    required this.signUp,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': userName,
      'phone': userPhone,
      'password': pass,
      'email': email,
      'is_admin': isAdmin,
      'is_active': isActive,
      'last_used': lastUsed,
      "sign_up": signUp,
    };
  }

  factory UserModel.fromfirestore(DocumentSnapshot user) {
    dynamic map = user.data();
    return UserModel(
        userName: map['name'],
        userPhone: map['phone'],
        pass: map['password'],
        email: map['email'],
        isAdmin: map['is_admin'],
        isActive: map['is_active'],
        lastUsed: map['last_used'],
        signUp: map['sign_up'],);
  }

  String toJson() => json.encode(toMap());
  factory UserModel.fromJson(String sourse) =>
      UserModel.fromfirestore(json.decode(sourse));
}
