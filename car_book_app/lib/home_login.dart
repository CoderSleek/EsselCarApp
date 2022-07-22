import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Booking App"),
        backgroundColor: Colors.red,
        centerTitle: true,
        surfaceTintColor: Colors.purple,
      ),
      body: Center(
        child: Container(
          child: const Text("First Flutter App"),
        ),
      ),
      drawer: const Drawer(),
    );
  }
}
