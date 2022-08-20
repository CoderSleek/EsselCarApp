import 'dart:convert';
import 'dart:ui';

import 'package:car_book_app/main.dart';
import 'package:car_book_app/startpage.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ManagerApprovalWidget extends StatefulWidget {
  static List dataList = [];

  late final Map<dynamic, dynamic> singleData;
  // final int index;

  ManagerApprovalWidget(index, {super.key}) {
    singleData = dataList[index];
  }

  static void getApprovals() async {
    Uri uri = Uri.parse(
        'http://${MyApp.backendIP}/getmanagerrequests?emp_id=${MyApp.userInfo['uid']}');

    try {
      http.Response res = await http.get(uri);
      dataList = jsonDecode(res.body);
    } catch (err) {
      Fluttertoast.showToast(
        msg: 'Connection Error',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  State<ManagerApprovalWidget> createState() => _ManagerApprovalState();
}

class _ManagerApprovalState extends State<ManagerApprovalWidget> {
  bool? isApproved;
  final TextEditingController _comments = TextEditingController();
  // _ManagerApprovalState(int index) {
  //   isApproved = ManagerApprovalWidget.dataList[index]["isApproved"];
  // }

  Future openPopup(bool status) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              "Are you sure you want to ${status ? 'Approve' : 'Reject'} this request?"),
          content: TextField(
            maxLines: 5,
            maxLength: 300,
            controller: _comments,
            decoration: const InputDecoration(
              hintText: "Optional",
              labelText: "Comments (if any)",
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.purpleAccent,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  gapPadding: 3),
            ),
          ),
          // actionsPadding: EdgeInsets.symmetric(vertical: 0.1),
          buttonPadding: const EdgeInsets.symmetric(horizontal: 20),
          // insetPadding: EdgeInsets.all(80),
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: GoogleFonts.nunito().fontFamily,
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 22, 128, 26),
                ),
              ),
              onPressed: () {},
              child: const Text("Yes"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 134, 22, 22),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    isApproved = widget.singleData["isApproved"];
  }

  @override
  void dispose() {
    _comments.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // isApproved = null;

    // void pr() {
    //   print(isApproved);
    // }

    // return Material(
    //   child: Column(
    //     children: [
    //       Text(
    //         x.toString(),
    //       ),
    //       ElevatedButton(
    //         onPressed: () {
    //           setState(() {
    //             x++;
    //             build(context);
    //             print(x);
    //           });
    //         },
    //         child: Text("Press"),
    //       ),
    //     ],
    //   ),
    // );

    return Card(
      child: ListTile(
        onTap: () {
          print("hello world");
        },
        isThreeLine: true,
        dense: true,
        enabled: isApproved == null,
        // enabled: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Employee id: ${widget.singleData["empID"]}'),
            // Text('Pick up Time ${widget.singleData["pickupDateTime"]}'),
          ],
        ),
        subtitle: Visibility(
          visible: isApproved == null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  visualDensity: VisualDensity.compact,
                  overlayColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 3, 128, 67),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
                onPressed: () => openPopup(true),
                child: const Text(
                  "Approve",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 201, 54, 44)),
                  visualDensity: VisualDensity.compact,
                  overlayColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 128, 3, 3),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
                onPressed: () => openPopup(false),
                child: const Text(
                  "Reject",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: Visibility(
          visible: isApproved != null,
          child: Text(isApproved == true ? "Approved" : "Rejected"),
        ),
      ),
    );
  }
}
