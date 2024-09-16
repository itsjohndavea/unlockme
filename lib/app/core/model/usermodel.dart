import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String email;
  final String password;
  final String mobileNo;

  UserModel(
      {this.id,
      required this.email,
      required this.password,
      required this.mobileNo});

  toJson() {
    return {
      "email": email,
      "password": password,
      "mobileNumber": mobileNo,
    };
  }

  factory UserModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        email: data['email'],
        password: data['password'],
        mobileNo: data['mobileNumber']);
  }
}
