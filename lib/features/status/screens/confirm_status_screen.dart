import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/colors.dart';
import 'package:messenger/features/chat/widgets/bottom_chat_field.dart';
import 'package:messenger/features/status/controller/status_controller.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const String routeName = "/confirm-status";
  final File file;
  const ConfirmStatusScreen({required this.file, Key? key}) : super(key: key);

  void addStatus(BuildContext context, WidgetRef ref) {
    ref.read(statusControllerProvider).uploadStatus(file, context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tabColor,
        onPressed: () {
          addStatus(context, ref);
        },
        child: const Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }
}
