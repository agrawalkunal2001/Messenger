import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/common/widgets/error.dart';
import 'package:messenger/common/widgets/loader.dart';
import 'package:messenger/features/select_contacts/controller/select_contacts_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = "/select-contacts";
  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(
      Contact selectedContact, BuildContext context, WidgetRef ref) {
    ref
        .read(selectContactsControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select contact"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactList) => ListView.builder(
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () {
                      selectContact(contact, context, ref);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(fontSize: 18),
                        ),
                        leading: contact.photo == null
                            ? const CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png",
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: MemoryImage(contact.photo!),
                              ),
                      ),
                    ),
                  );
                },
                itemCount: contactList.length,
              ),
          error: (error, trace) => ErrorScreen(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
