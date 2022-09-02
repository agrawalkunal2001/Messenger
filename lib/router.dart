import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/widgets/error.dart';
import 'package:messenger/features/auth/screens/login_screen.dart';
import 'package:messenger/features/auth/screens/otp_screen.dart';
import 'package:messenger/features/auth/screens/user_information_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const UserInformationScreen());
    default:
      MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "This page does not eixst!"),
        ),
      );
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "This page does not eixst!"),
        ),
      );
  }
}
