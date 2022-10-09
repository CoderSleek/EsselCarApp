import 'dart:convert';

import 'package:car_book_app/historywidget.dart';
import 'package:car_book_app/main.dart';
import 'package:car_book_app/utils/routes.dart';
import 'package:car_book_app/widgets/managerapproval.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _uid = TextEditingController();
  final TextEditingController _pas = TextEditingController();

  bool changeButton =
      false; //use for both changestate and next page load if info valid

  final _loginFormKey = GlobalKey<FormState>();

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
    Map body = {'uid': _uid.text, 'password': _pas.text};
    late http.Response response;

    try {
      response = await http.post(
        uri,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    } catch (err) {
      Fluttertoast.showToast(msg: "Connectivity Error");
      return false;
    }

    try {
      if (response.statusCode == 200) {
        MyApp.userInfo = jsonDecode(response.body);
        if (MyApp.userInfo['position'].toLowerCase().contains('manager')) {
          ManagerApprovalWidget.getApprovals();
        }
        HistoryWidget.getHistory();
        return true;
      } else {
        Fluttertoast.showToast(msg: jsonDecode(response.body));
      }
    } catch (err) {
      Fluttertoast.showToast(msg: "Internal Error");
    }
    return false;
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
    super.dispose();
    _uid.dispose();
    _pas.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          style: TextStyle(
            fontFamily: GoogleFonts.courgette().fontFamily,
            fontSize: 24,
            letterSpacing: 0.3,
            wordSpacing: 0.3,
          ),
          "Car Booking App",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Image.asset(
              'assets/login.png',
              height: 130,
            ),
            Text(
              "Welcome",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 32,
                fontFamily: GoogleFonts.pacifico().fontFamily,
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
                        icon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
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
                        icon: Icon(
                          Icons.lock,
                          color: Colors.blue,
                        ),
                        hintText: "Enter Employee password",
                        labelText: "Password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        RegExp isvalid = RegExp(r'^[a-zA-Z0-9\*\#\$\&]+$');
                        return validateInputs(
                            value, "Password", "special charachters", isvalid,
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
                  textStyle: TextStyle(
                    fontFamily: GoogleFonts.sora(fontWeight: FontWeight.w600)
                        .fontFamily,
                    letterSpacing: 0.4,
                  ),
                  minimumSize: const Size(140, 40),
                  shadowColor: const Color.fromRGBO(00, 44, 255, 1.0),
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
// <a href="https://lovepik.com/images/png-computer.html">Computer Png vectors by Lovepik.com</a>