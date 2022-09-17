import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/common/repositories/common_firebase_storage_repository.dart';
import 'package:messenger/common/utils/utils.dart';
import 'package:messenger/models/status_model.dart';
import 'package:messenger/models/user_model.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      ref: ref),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository(
      {required this.firestore, required this.auth, required this.ref});

  void uploadStatus(
      {required String userName,
      required String profilePic,
      required String phoneNumber,
      required File statusImage,
      required BuildContext context}) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase("Status/$statusId$uid", statusImage);

      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      List<String> uidWhoCanSee = [];
      for (int i = 0; i < contacts.length; i++) {
        var contactDataInFirebase = await firestore
            .collection("Users")
            .where(
              "phoneNumber",
              isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
            )
            .get();

        if (contactDataInFirebase.docs.isNotEmpty) {
          var contactData =
              UserModel.fromMap(contactDataInFirebase.docs[0].data());

          uidWhoCanSee.add(contactData.uid);
        }
      }

      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection("Status")
          .where("uid", isEqualTo: auth.currentUser!.uid)
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        StatusModel status =
            StatusModel.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await firestore
            .collection("Status")
            .doc(statusesSnapshot.docs[0].id)
            .update({'photoUrl': statusImageUrls});
        return;
      } else {
        statusImageUrls = [imageUrl];
      }

      StatusModel status = StatusModel(
          uid: uid,
          userName: userName,
          phoneNumber: phoneNumber,
          photoUrl: statusImageUrls,
          createdAt: DateTime.now(),
          profilePic: profilePic,
          statusId: statusId,
          whoCanSee: uidWhoCanSee);

      await firestore.collection("Status").doc(statusId).set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> statusData = [];
    try {
      var myStatus = await firestore
          .collection("Status")
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .get();
      StatusModel myStatusModel = StatusModel.fromMap(myStatus.docs[0].data());
      statusData.add(myStatusModel);

      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      for (int i = 0; i < contacts.length; i++) {
        var statusesSnapshot = await firestore
            .collection("Status")
            .where(
              "phoneNumber",
              isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
            )
            .where("createdAt",
                isGreaterThan: DateTime.now()
                    .subtract(const Duration(hours: 24))
                    .millisecondsSinceEpoch)
            .get(); // Since, we are usiing complex routing involving two where, we need indexing.

        for (var tempData in statusesSnapshot.docs) {
          StatusModel tempStatus = StatusModel.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return statusData;
  }
}
