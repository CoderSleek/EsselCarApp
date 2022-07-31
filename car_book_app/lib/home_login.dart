// import 'dart:html';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:car_book_app/main.dart';
import 'package:car_book_app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final RegExp _isvalid = RegExp(r'^[a-zA-Z0-9]+$');

  final TextEditingController _uid = TextEditingController();
  final TextEditingController _pas = TextEditingController();

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
      if (await sendLoginRequest(Uri.http(MyApp.backendIP, '/login'))) {
        setState(() {
          changeButton = true;
        });
        await Future.delayed(const Duration(milliseconds: 500));
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, MyRoutes.startRoute);
      }
    }
  }

  Future<bool> sendLoginRequest(Uri uri) async {
    // Map body = {'uid': _uid.text, 'password': _pas.text};
    // try {
    //   body = {'uid': int.tryParse(_uid.text), 'password': _pas.text};
    // } catch (err) {
    //   Fluttertoast.showToast(
    //     msg: "User Id Must only be numbers",
    //     gravity: ToastGravity.CENTER,
    //     toastLength: Toast.LENGTH_SHORT,
    //     timeInSecForIosWeb: 1,
    //   );
    //   return false;
    // }

    // try {
    // http.Response response = await http.post(
    //   uri,
    //   headers: <String, String>{'Content-Type': 'application/json'},
    //   body: jsonEncode(body),
    // );

    // if (response.statusCode == 200) {
    //   MyApp.userInfo = jsonDecode(response.body);
    return true;
    // } else {
    // Fluttertoast.showToast(msg: response.body.toString());
    // }
    // } catch (err) {
    //   Fluttertoast.showToast(msg: "Connectivity Error");
    // }
    // return false;
  }

  String? validateInputs(
      String? value, String item, String errorMsg, RegExp exp,
      {int numOfChars = 0}) {
    if (value!.isEmpty) {
      return "$item must not be empty";
    } else if (value.length < numOfChars) {
      return "$item cannot be less than $numOfChars charachter";
    } else if (!exp.hasMatch(value)) {
      return "$item cannot contain $errorMsg";
    }
    return null;
  }

  @override
  void dispose() {
    _uid.dispose();
    _pas.dispose();
    super.dispose();
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
                      controller: _uid,
                      maxLength: 30,
                      decoration: const InputDecoration(
                        hintText: "Enter Employee ID",
                        labelText: "User ID",
                      ),
                      validator: (value) {
                        final RegExp isvaliduid = RegExp(r'^[0-9]+$');
                        return validateInputs(
                            value, "ID", "non numeric charachter", isvaliduid);
                      },
                    ),
                    TextFormField(
                      maxLength: 30,
                      controller: _pas,
                      decoration: const InputDecoration(
                        hintText: "Enter Employee password",
                        labelText: "Password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        return validateInputs(
                            value, "Password", "special charachters", _isvalid,
                            numOfChars: 6);
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
