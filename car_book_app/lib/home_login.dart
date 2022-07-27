import 'dart:io';
import 'dart:math';

import 'package:car_book_app/utils/routes.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String uid = "";
  static String _pas = "";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _isvalid = RegExp(r'^[a-zA-Z0-9]+$');

  bool changeButton =
      false; //use for both changestate and next page load if info valid

  final _loginFormKey = GlobalKey<FormState>();

  // bool _validUid() {
  //   if (_uid.isNotEmpty && _isvalid.hasMatch(_uid)) {
  //     return true;
  //   }
  //   return false;
  // }

  // bool _validPas() {
  //   if (_pas.isNotEmpty && _isvalid.hasMatch(_pas)) {
  //     return true;
  //   }
  //   return false;
  // }

  void validateLogin() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, MyRoutes.startRoute);
    }
  }

  String? validateInputs(String? value, String item, int numOfChars) {
    if (value!.isEmpty) {
      return "$item must not be empty";
    } else if (value.length < numOfChars) {
      return "$item cannot be less than $numOfChars charachter";
    } else if (!_isvalid.hasMatch(value)) {
      return "$item cannot contain special charachters";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Car Booking App",
        ),
        // backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 40,
                fontFamily: "Sans",
                color: Colors.blue,
                // fontFamilyFallback: ["Times new Roman"],
              ),
              softWrap: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 30,
                      decoration: const InputDecoration(
                        hintText: "Enter Employee ID",
                        labelText: "User ID",
                      ),
                      validator: (value) {
                        LoginPage.uid = value.toString();
                        return validateInputs(value, "ID", 0);
                      },
                    ),
                    TextFormField(
                      maxLength: 30,
                      decoration: const InputDecoration(
                        hintText: "Enter Employee password",
                        labelText: "Password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        LoginPage._pas = value.toString();
                        return validateInputs(value, "Password", 6);
                      },
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: validateLogin,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(140, 40),
                  // primary: Colors.amber, text color
                  // surfaceTintColor: Colors.yellow,
                  shadowColor: const Color.fromRGBO(00, 44, 255, 1.0),
                  // backgroundColor: Colors.black, btn clr 4 textbutton
                  shape: changeButton
                      ? const CircleBorder()
                      : const StadiumBorder(),
                  padding: changeButton
                      ? const EdgeInsets.all(11)
                      : const EdgeInsets.all(0),
                  animationDuration: const Duration(milliseconds: 500)),
              child:
                  changeButton ? const Icon(Icons.done) : const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
