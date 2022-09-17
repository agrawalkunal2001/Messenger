import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/features/auth/controller/auth_controller.dart';
import 'package:messenger/features/status/repository/status_repository.dart';
import 'package:messenger/models/status_model.dart';

final statusControllerProvider = Provider(
  (ref) {
    final statusRepository = ref.read(statusRepositoryProvider);
    return StatusController(statusRepository: statusRepository, ref: ref);
  },
);

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({required this.statusRepository, required this.ref});

  void uploadStatus(File file, BuildContext context) {
    ref.watch(userDataAuthProvider).whenData((value) {
      statusRepository.uploadStatus(
          userName: value!.name,
          profilePic: value.profilePic,
          phoneNumber: value.phoneNumber,
          statusImage: file,
          context: context);
    });
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> statuses = await statusRepository.getStatus(context);
    return statuses;
  }
}
