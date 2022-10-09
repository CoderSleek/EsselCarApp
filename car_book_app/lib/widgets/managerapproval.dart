import 'dart:convert';

import 'package:car_book_app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ManagerApprovalWidget extends StatefulWidget {
  static List dataList = [];

  late final Map<dynamic, dynamic> singleData;

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
  bool isLoading = false;
  late final Map<dynamic, dynamic> singleData;
  final TextEditingController _comments = TextEditingController();

  @override
  void initState() {
    super.initState();
    singleData = widget.singleData;
  }

  @override
  void dispose() {
    super.dispose();
    _comments.dispose();
  }

  void sendStatus(bool status) async {
    setState(() {
      isLoading = !isLoading;
    });

    Map<String, dynamic> dataPacket = {
      'bookingID': singleData["bookingID"],
      'status': status,
      'comments': _comments.text
    };

    try {
      http.Response res = await http.put(
        Uri.http(MyApp.backendIP, '/approval'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataPacket),
      );

      if (res.statusCode == 202) {
        setState(() {
          singleData["isApproved"] = status;
        });
      }
      Fluttertoast.showToast(msg: jsonDecode(res.body));
    } catch (err) {
      Fluttertoast.showToast(msg: "Connection Error");
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future openPopup(bool status) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              "Are you sure you want to ${status ? 'Approve' : 'Reject'} this request for employee ${singleData["empID"]}?"),
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
          buttonPadding: const EdgeInsets.symmetric(horizontal: 20),
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
              onPressed: () {
                Navigator.of(context).pop();
                sendStatus(status);
                _comments.text = '';
              },
              child: const Text("Yes"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 134, 22, 22),
                ),
              ),
              onPressed: () {
                _comments.text = '';
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        ),
      );

  Future openInfoDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          title: Text(
            "Additional information for Request ${singleData["travelPurpose"]}",
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextField(
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: "EmployeeID",
                  ),
                  controller:
                      TextEditingController(text: '${singleData["empID"]}'),
                ),
                TextField(
                  enabled: false,
                  maxLines: null,
                  decoration:
                      const InputDecoration(labelText: "Travel Purpose"),
                  controller:
                      TextEditingController(text: singleData["travelPurpose"]),
                ),
                TextField(
                  enabled: false,
                  decoration:
                      const InputDecoration(labelText: "Expected Distance"),
                  controller: TextEditingController(
                      text: '${singleData["expectedDist"]}'),
                ),
                TextField(
                  enabled: false,
                  decoration: const InputDecoration(labelText: "Pickup Time"),
                  controller:
                      TextEditingController(text: singleData["pickupDateTime"]),
                ),
                TextField(
                  enabled: false,
                  maxLines: null,
                  decoration: const InputDecoration(labelText: "Pickup Venue"),
                  controller:
                      TextEditingController(text: singleData["pickupVenue"]),
                ),
                TextField(
                  enabled: false,
                  decoration: const InputDecoration(labelText: "Arrival Time"),
                  controller: TextEditingController(
                      text: singleData["arrivalDateTime"]),
                ),
                TextField(
                  enabled: false,
                  maxLines: null,
                  decoration:
                      const InputDecoration(labelText: "Additional Info"),
                  controller: TextEditingController(
                      text: singleData["additionalInfo"] ?? 'Nothing'),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: openInfoDialog,
        isThreeLine: true,
        enabled: singleData['isApproved'] == null,
        title: Text('Employee id: ${widget.singleData["empID"]}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Travel Purpose: ${singleData["travelPurpose"]}",
              style: const TextStyle(
                height: 1.2,
              ),
            ),
            Visibility(
              visible: singleData['isApproved'] == null,
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
                    onPressed: () => isLoading ? null : openPopup(true),
                    child: isLoading
                        ? Transform.scale(
                            scale: 0.4,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
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
                    onPressed: () => isLoading ? null : openPopup(false),
                    child: isLoading
                        ? Transform.scale(
                            scale: 0.4,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Reject",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: Visibility(
          visible: singleData['isApproved'] != null,
          child:
              Text(singleData['isApproved'] == true ? "Approved" : "Rejected"),
        ),
      ),
    );
  }
}
