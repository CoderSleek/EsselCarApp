import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
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
      body: Column(
        children: [
          const Text(
            "Login Page",
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
          ElevatedButton(onPressed: () {}, child: const Text("Login")),
        ],
      ),
      drawer: const Drawer(),
    );
  }
}
