import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/features/auth/repository/auth_repository.dart';

// We need to keep the business logic away from UI. That is why we use controller which connects the UI(screens) and logic(repository).

final authControllerProvider = Provider(
  ((ref) {
    final authRepository = ref.watch(
        authRepositoryProvider); // Same as Provider.of<AuthRepository>(context);
    return AuthController(authRepository: authRepository);
  }),
);

class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(
        context: context, verificationId: verificationId, userOTP: userOTP);
  }
}
