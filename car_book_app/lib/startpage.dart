import 'package:car_book_app/utils/routes.dart';
import 'package:car_book_app/widgets/mydrawer.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const SingleChildScrollView(),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.teal,
                // animationDuration: const Duration(microseconds: 1),
                borderRadius:
                    BorderRadius.circular(100), //needs to be same as *1
                child: InkWell(
                  radius: 600, //speed
                  borderRadius: BorderRadius.circular(100), //*1
                  // focusColor: Colors.white,
                  splashColor: Colors.blue.shade500, //holdcolor
                  highlightColor: Colors.blue.shade700, //fullholdcolor
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutes.createBooking);
                  },
                  child: AnimatedContainer(
                    // color: Colors.greenAccent,
                    duration: const Duration(seconds: 1),
                    width: 180,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Text(
                      "Create a new Booking",
                      style: TextStyle(
                        // color: Colors.white,
                        inherit: false,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}
