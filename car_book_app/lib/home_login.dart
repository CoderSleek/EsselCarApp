import 'dart:io';
import 'dart:math';

import 'package:car_book_app/utils/routes.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static final _isvalid = RegExp(r'^[a-zA-Z0-9]+$');

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _uid = "";

  String _pas = "";

  bool changeButton =
      false; //use for both changestate and next page load if info valid

  bool _validUid() {
    if (_uid.isNotEmpty && LoginPage._isvalid.hasMatch(_uid)) {
      return true;
    }
    return false;
  }

  bool _validPas() {
    if (_pas.isNotEmpty && LoginPage._isvalid.hasMatch(_pas)) {
      return true;
    }
    return false;
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
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 30,
                    onChanged: (val) => {_uid = val},
                    decoration: const InputDecoration(
                      hintText: "Enter Employee ID",
                      labelText: "User ID",
                    ),
                  ),
                  TextFormField(
                    maxLength: 30,
                    onChanged: (val) => {_pas = val},
                    decoration: const InputDecoration(
                      hintText: "Enter Employee password",
                      labelText: "Password",
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  if (_validPas() && _validUid()) {
                    changeButton = true;
                  } else {}
                });
                await Future.delayed(const Duration(milliseconds: 500));
                if (changeButton) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, MyRoutes.startPage);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(140, 40),
                // primary: Colors.amber, text color
                shadowColor: const Color.fromRGBO(00, 44, 255, 1.0),
                // backgroundColor: Colors.black, btn clr
                shape:
                    changeButton ? const CircleBorder() : const StadiumBorder(),
                padding: changeButton
                    ? const EdgeInsets.all(11)
                    : const EdgeInsets.all(0),
              ),
              child:
                  changeButton ? const Icon(Icons.done) : const Text("Login"),
            ),
          ],
        ),
      ),
      drawer: const Drawer(),
    );
  }
}
