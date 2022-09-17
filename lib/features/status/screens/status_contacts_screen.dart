import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:messenger/colors.dart';
import 'package:messenger/common/widgets/loader.dart';
import 'package:messenger/features/status/controller/status_controller.dart';
import 'package:messenger/features/status/screens/status_screen.dart';
import 'package:messenger/models/status_model.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<StatusModel>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, StatusScreen.routeName,
                          arguments: statusData);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: ListTile(
                        title: Text(
                          statusData.userName,
                          style: const TextStyle(fontSize: 18),
                        ),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            statusData.profilePic,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: dividerColor,
                    indent: 85,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
