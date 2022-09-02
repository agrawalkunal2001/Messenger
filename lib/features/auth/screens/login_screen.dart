import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/colors.dart';
import 'package:messenger/common/utils/utils.dart';
import 'package:messenger/common/widgets/custom_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:messenger/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = "/login-screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(// Same as Provider.of(context, listen: false)
              authControllerProvider)
          .signInWithPhone(context,
              '+${country!.phoneCode}${phoneNumber}'); // Changed stateful to consumer stateful widget to access widget ref. Ref is providers interacting with providers. Widget ref is widgets interacting with providers.
      // Firebase auth will fail without country code.
    } else {
      showSnackBar(context: context, content: "Fill out all the fields!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your phone number"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Messenger will need to verify your phone number!",
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                pickCountry();
              },
              child: const Text(
                "Pick country",
                style: TextStyle(color: tabColor),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (country != null) Text("+${country!.phoneCode}"),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: tabColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 90,
              child: CustomButton(
                onPressed: () {
                  sendPhoneNumber();
                },
                text: "Next",
              ),
            )
          ],
        ),
      ),
    );
  }
}
