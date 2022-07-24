import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Text("Welcome"),
      ),
    );
  }
}
