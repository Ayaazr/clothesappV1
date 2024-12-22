import 'package:cloud_firestore/cloud_firestore.dart';

// Enum for user roles
enum UserRole { user, admin, staff }

class UserModel {
  String uid;
  String email;
  String displayName;
  String? profilePicture;
  Timestamp createdAt;
  String? code;
  String birthday;
  String city;
  String? password;
  String adress;
  int postalCode;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.profilePicture,
    required this.createdAt,
    this.code,
    required this.birthday,
    required this.city,
     this.password,
    required this.adress,
    required this.postalCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'profilePicture': profilePicture,
      'createdAt': createdAt,
      'code': code,
      'birthday': birthday,
      'city': city,
      'password': password,
      'adress': adress,
      'postalCode': postalCode,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      profilePicture: map['profilePicture'],
      createdAt: map['createdAt'],
      code: map['code'],
      birthday: map['birthday'],
      city: map['city'],
      password: map['password'],
      adress: map['adress'],
      postalCode: map['postalCode'],
    );
  }
}
