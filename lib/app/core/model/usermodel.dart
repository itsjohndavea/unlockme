import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String email;
  final String password;

  UserModel({this.id, required this.email, required this.password});

  toJson() {
    return {
      "email": email,
      "password": password,
    };
  }

  factory UserModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id, email: data['email'], password: data['password']);
  }
}
