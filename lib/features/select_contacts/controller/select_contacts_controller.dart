import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/features/select_contacts/repository/select_contacts_repository.dart';

final selectContactsControllerProvider = Provider((ref) {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);
  return SelectContactsController(
      selectContactsRepository: selectContactsRepository, ref: ref);
});

final getContactsProvider = FutureProvider((ref) {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactsRepository.getContacts();
});

class SelectContactsController {
  final SelectContactsRepository selectContactsRepository;
  final ProviderRef ref;

  SelectContactsController(
      {required this.selectContactsRepository, required this.ref});

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactsRepository.selectContact(selectedContact, context);
  }
}
