import 'package:car_book_app/utils/routes.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  VoidCallback? navi(context) {
    Navigator.pop(context);
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
                    decoration: const InputDecoration(
                      hintText: "Enter Employee ID",
                      labelText: "User ID",
                    ),
                  ),
                  TextFormField(
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
              onPressed: navi,
              style: TextButton.styleFrom(
                minimumSize: const Size(120, 30),
              ),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
      drawer: const Drawer(),
    );
  }
}
