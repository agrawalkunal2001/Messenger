import 'package:flutter/material.dart';
import 'package:messenger/colors.dart';
import 'package:messenger/common/widgets/custom_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Welcome to Messenger",
              style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: size.height / 9,
            ),
            Image.asset(
              "assets/bg.png",
              height: 340,
              width: 340,
              color: tabColor,
            ),
            SizedBox(
              height: size.height / 9,
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service',
                style: TextStyle(color: greyColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width * 0.75,
              child: CustomButton(text: "Agree and Continue", onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
