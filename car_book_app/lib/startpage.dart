import 'package:car_book_app/historywidget.dart';
import 'package:car_book_app/utils/routes.dart';
import 'package:car_book_app/widgets/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    HistoryWidget.getHistory();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          style: TextStyle(
            fontFamily: GoogleFonts.courgette().fontFamily,
            fontSize: 24,
            letterSpacing: 0.3,
            wordSpacing: 0.3,
          ),
          "History",
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: HistoryWidget.histories.length,
            itemBuilder: (context, index) {
              return HistoryWidget(
                data: HistoryWidget.histories[index],
                key: Key("key"),
              );
            },
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.blue.shade500,
                // animationDuration: const Duration(microseconds: 1),
                borderRadius:
                    BorderRadius.circular(100), //needs to be same as *1
                child: InkWell(
                  radius: 600, //speed
                  borderRadius: BorderRadius.circular(100), //*1
                  // focusColor: Colors.white,
                  splashColor: Colors.blue.shade600, //holdcolor
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
                    child: Text(
                      "Create a new Booking",
                      style: TextStyle(
                        // color: Colors.white,
                        inherit: false,
                        fontFamily:
                            GoogleFonts.sora(fontWeight: FontWeight.w600)
                                .fontFamily,
                        fontSize: 12,
                        letterSpacing: 0.3,
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
