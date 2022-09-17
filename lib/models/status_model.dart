// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StatusModel {
  final String uid;
  final String userName;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSee;

  StatusModel(
      {required this.uid,
      required this.userName,
      required this.phoneNumber,
      required this.photoUrl,
      required this.createdAt,
      required this.profilePic,
      required this.statusId,
      required this.whoCanSee});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      uid: map['uid'] ?? "",
      userName: map['userName'] ?? "",
      phoneNumber: map['phoneNumber'] ?? "",
      photoUrl: List<String>.from(map['photoUrl']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      profilePic: map['profilePic'] ?? "",
      statusId: map['statusId'] ?? "",
      whoCanSee: List<String>.from(map['whoCanSee']),
    );
  }
}
