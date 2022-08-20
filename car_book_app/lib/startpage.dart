import 'package:car_book_app/historywidget.dart';
import 'package:car_book_app/main.dart';
import 'package:car_book_app/utils/routes.dart';
import 'package:car_book_app/widgets/managerapproval.dart';
import 'package:car_book_app/widgets/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatefulWidget {
  static int x = 0;

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    // print('before history ${HistoryWidget.histories.length}');
    // HistoryWidget.getHistory();
    // print('after history ${HistoryWidget.histories.length}');
    bool isManager =
        MyApp.userInfo['position'].toLowerCase().contains('manager');
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarPadding = MediaQuery.of(context).padding.top;
    double appBarHeight = AppBar().preferredSize.height;
    double viewHeight = screenHeight - appBarPadding - appBarHeight - 60;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          style: TextStyle(
            fontFamily: GoogleFonts.courgette().fontFamily,
            fontSize: 24,
            letterSpacing: 0.3,
            wordSpacing: 0.3,
          ),
          isManager ? "History and Approval" : "History",
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // FractionallySizedBox(
          //   heightFactor: isManager ? 0.4 : 0.6,
          //   // color: Colors.white70,
          //   // height: 30,
          //   // constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
          //   // padding: EdgeInsets.only(top: 30),
          //   child: Container(
          //     color: Colors.black,
          //     child: ListView.builder(
          //       itemCount: HistoryWidget.histories.length,
          //       itemBuilder: (context, index) {
          //         return HistoryWidget(
          //           data: HistoryWidget.histories[index],
          //         );
          //       },
          //     ),
          //   ),
          // ),
          // Column(
          //   children: [
          //     Visibility(
          //       visible: isManager,
          //       child: Expanded(
          //         flex: 5,
          //         child: Container(
          //           width: double.infinity,
          //           color: Colors.yellow,
          //           child: Text(""),
          //         ),
          //       ),
          //     ),

          //     Expanded(
          //       flex: 5,
          //       child: Container(
          //         width: double.infinity,
          //         color: Colors.red,
          //         child: Text("data"),
          //       ),
          //     ),

          // Padding(
          //   padding: const EdgeInsets.all(3.0),
          //   child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: isManager ? viewHeight * 0.4 : 0,
                color: Colors.grey,
                child: ListView.builder(
                  itemCount: ManagerApprovalWidget.dataList.length,
                  itemBuilder: (context, index) {
                    return ManagerApprovalWidget(
                      index,
                    );
                  },
                ),
              ),
              // Container(
              //   height: isManager ? viewHeight * 0.4 : 0,
              //   color: Colors.grey,
              //   child: Column(
              //     children: approvalWidgets,
              //   ),
              // ),
              Container(
                height: isManager ? viewHeight * 0.6 : viewHeight * 1,
                color: const Color.fromRGBO(190, 190, 190, 1),
                child: ListView.builder(
                  itemCount: HistoryWidget.histories.length,
                  itemBuilder: (context, index) {
                    return HistoryWidget(
                      data: HistoryWidget.histories[index],
                    );
                  },
                ),
              ),
            ],
          ),
          // Column(
          //   children: [
          //     Flexible(
          //       // fit: FlexFit.values[1],
          //       flex: 6,
          //       child: Container(color: Colors.red),
          //     ),
          //     Flexible(
          //       child: SizedBox(),
          //       flex: 4,
          //     )
          //   ],
          // ),

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
      // HistoryWidget(data: HistoryWidget.histories[0]),
      drawer: MyDrawer(),
    );
  }
}
