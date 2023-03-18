import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String id;
  String name;
  String phone;
  num wallet;
  
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.wallet,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'wallet': wallet,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      wallet: map['wallet'] as num,
    );
  }

  
}
