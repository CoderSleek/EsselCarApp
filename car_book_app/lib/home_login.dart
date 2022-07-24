import 'dart:io';
import 'dart:math';

import 'package:car_book_app/utils/routes.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _uid = "";
  String _pas = "";
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
      await Future.delayed(const Duration(milliseconds: 5000));
      // ignore: use_build_context_synchronously
      // Navigator.pushReplacementNamed(context, MyRoutes.startPage);
    }
  }

  String? validateInputs(String? value, String item, int numOfChars) {
    if (value == null) return null;
    if (value.isEmpty) {
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
        backgroundColor: Colors.deepPurple,
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
                      onChanged: (val) => {_uid = val},
                      decoration: const InputDecoration(
                        hintText: "Enter Employee ID",
                        labelText: "User ID",
                      ),
                      validator: (value) {
                        return validateInputs(value, "ID", 0);
                      },
                    ),
                    TextFormField(
                      maxLength: 30,
                      onChanged: (val) => {_pas = val},
                      decoration: const InputDecoration(
                        hintText: "Enter Employee password",
                        labelText: "Password",
                      ),
                      obscureText: true,
                      validator: (value) {
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
            Material(
              color: Colors.teal,
              // animationDuration: const Duration(microseconds: 1),
              borderRadius: BorderRadius.circular(100), //needs to be same as *1
              child: InkWell(
                radius: 600, //speed
                borderRadius: BorderRadius.circular(100), //*1
                // focusColor: Colors.white,
                splashColor: Colors.blue.shade500, //holdcolor
                highlightColor: Colors.blue.shade700, //fullholdcolor
                onTap: () async {
                  setState(() {});
                },
                child: AnimatedContainer(
                  // color: Colors.greenAccent,
                  duration: const Duration(seconds: 1),
                  width: 150,
                  height: 40,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.pets,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const Drawer(),
    );
  }
}
