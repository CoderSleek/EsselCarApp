import 'package:car_book_app/historywidget.dart';
import 'package:car_book_app/main.dart';
import 'package:car_book_app/utils/routes.dart';
import 'package:car_book_app/widgets/managerapproval.dart';
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(190, 190, 190, 1),
                  border: Border(
                    bottom: BorderSide(width: 2),
                  ),
                ),
                height: isManager ? viewHeight * 0.4 : 0,
                child: ManagerApprovalWidget.dataList.isEmpty
                    ? const Center(
                        child: Text("No approvals required"),
                      )
                    : ListView.builder(
                        itemCount: ManagerApprovalWidget.dataList.length,
                        itemBuilder: (context, index) {
                          return ManagerApprovalWidget(
                            index,
                          );
                        },
                      ),
              ),
              Container(
                height: isManager ? viewHeight * 0.6 : viewHeight * 1,
                color: const Color.fromRGBO(190, 190, 190, 1),
                child: HistoryWidget.histories.isEmpty
                    ? const Center(
                        child: Text("No History"),
                      )
                    : ListView.builder(
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
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.blue.shade500,
                borderRadius:
                    BorderRadius.circular(100), //needs to be same as *1
                child: InkWell(
                  radius: 600, //speed
                  borderRadius: BorderRadius.circular(100), //*1
                  splashColor: Colors.blue.shade600, //holdcolor
                  highlightColor: Colors.blue.shade700, //fullholdcolor
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutes.createBooking)
                        .then((value) {
                      setState(() {}); //reloads the page
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: 180,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      "Create a new Booking",
                      style: TextStyle(
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
