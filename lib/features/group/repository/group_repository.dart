import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/common/repositories/common_firebase_storage_repository.dart';
import 'package:messenger/common/utils/utils.dart';
import 'package:messenger/models/group_model.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider((ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository(
      {required this.firestore, required this.auth, required this.ref});

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContacts) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        var userCollection = await firestore
            .collection("Users")
            .where(
              'phoneNumber',
              isEqualTo:
                  selectedContacts[i].phones[0].number.replaceAll(" ", ""),
            )
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()["uid"]);
        }
      }

      var groupId = const Uuid().v1();

      String groupPicUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase("Group/$groupId", profilePic);

      GroupModel group = GroupModel(
          senderId: auth.currentUser!.uid,
          name: name,
          groupId: groupId,
          lastMessage: "",
          groupPic: groupPicUrl,
          membersUid: [auth.currentUser!.uid, ...uids],
          timeSent: DateTime.now());

      await firestore.collection("Groups").doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
