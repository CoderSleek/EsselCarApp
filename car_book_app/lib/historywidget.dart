import 'dart:convert';

import 'package:car_book_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class HistoryData {
  late int bookingID;
  late String travelPurpose;
  late double expectedDistance;
  late String pickupDateTime;
  late String pickupVenue;
  late String arrivalDateTime;
  late String? additionalInfo;
  late bool? isManagerApproved;
  late bool canFillTime;

  HistoryData.fromJson(Map<String, dynamic> item) {
    bookingID = item['bookingID'];
    travelPurpose = item['travelPurpose'];
    expectedDistance = item['expectedDistance'];
    pickupVenue = item['pickupVenue'];
    additionalInfo = item['additionalInfo'];
    isManagerApproved = item['approvalStatus'];
    pickupDateTime = item['pickupDateTime'];
    arrivalDateTime = item['arrivalDateTime'];
    canFillTime = item['canFillTime'];
  }
}

class HistoryWidget extends StatefulWidget {
  static List<dynamic> histories = [];

  final HistoryData data;
  final int index;

  const HistoryWidget({required this.data, this.index = 0, super.key});

  static Future<void> getHistory() async {
    histories = [];
    try {
      http.Response res = await http
          .get(Uri.http(MyApp.backendIP, '/history/${MyApp.userInfo['uid']}'));
      histories = jsonDecode(res.body);

      histories = histories.map((ele) => HistoryData.fromJson(ele)).toList();
    } catch (err) {
      Fluttertoast.showToast(
        msg: 'Connection Error',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  final TextEditingController _inTime = TextEditingController();
  final TextEditingController _outTime = TextEditingController();
  final TextEditingController _inDist = TextEditingController();
  final TextEditingController _outDist = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _inTime.dispose();
    _outTime.dispose();
    _inDist.dispose();
    _outDist.dispose();
  }

  Future<bool> sendTimeData() async {
    Map<String, dynamic> packet = {
      'bookingID': widget.data.bookingID,
      'inTime': _inTime.text,
      'outTime': _outTime.text,
      'inDist': double.parse(_inDist.text),
      'outDist': double.parse(_outDist.text)
    };

    try {
      http.Response response = await http.put(
          Uri.http(MyApp.backendIP, '/travelData'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(packet));

      if (response.statusCode == 202) {
        return true;
      } else {
        Fluttertoast.showToast(
            msg: "Some Error Occured", toastLength: Toast.LENGTH_SHORT);
      }
    } catch (err) {
      Fluttertoast.showToast(
          msg: "Connectivity Error", toastLength: Toast.LENGTH_SHORT);
    }
    return false;
  }

  Future openTimeFillPopup() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("In Time and distance"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Time Cannot be Empty";
                      }
                      return null;
                    },
                    readOnly: true,
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.dial,
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _inTime.text = pickedTime.format(context);
                        });
                      }
                    },
                    controller: _inTime,
                    decoration: const InputDecoration(
                      icon: Icon(
                        CupertinoIcons.clock_fill,
                        color: Colors.blue,
                      ),
                      labelText: "In Time",
                      hintText: "hh:mm",
                    ),
                  ),
                  TextFormField(
                    maxLength: 8,
                    controller: _inDist,
                    validator: (value) {
                      RegExp isValid = RegExp(r'^\d+\.?\d*$');
                      if (value == null || value.isEmpty) {
                        return "Distance cannot be empty";
                      } else if (!isValid.hasMatch(value)) {
                        return "Can Only contain Numbers";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.social_distance,
                        color: Colors.blue,
                      ),
                      labelText: "In Distance",
                      hintText: "Distance in KM (e.g. 123.55)",
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Time Cannot be Empty";
                      }
                      return null;
                    },
                    readOnly: true,
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.dial,
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _outTime.text = pickedTime.format(context);
                        });
                      }
                    },
                    controller: _outTime,
                    decoration: const InputDecoration(
                      icon: Icon(
                        CupertinoIcons.clock_fill,
                        color: Colors.blue,
                      ),
                      labelText: "Out Time",
                      hintText: "hh:mm",
                    ),
                  ),
                  TextFormField(
                    maxLength: 8,
                    controller: _outDist,
                    validator: (value) {
                      RegExp isValid = RegExp(r'^\d+\.?\d*$');
                      if (value == null || value.isEmpty) {
                        return "Distance cannot be empty";
                      } else if (!isValid.hasMatch(value)) {
                        return "Can Only contain Numbers";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.social_distance,
                        color: Colors.blue,
                      ),
                      labelText: "Out Distance",
                      hintText: "Distance in KM (e.g. 123.55)",
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                if (!await sendTimeData()) return;
                setState(() {
                  widget.data.canFillTime = false;
                });

                Navigator.of(context).pop();
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: SingleChildScrollView(
          child: Text(widget.data.travelPurpose),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dist: ${widget.data.expectedDistance}'),
            Text('Time: ${widget.data.pickupDateTime}'),
          ],
        ),
        enabled: widget.data.canFillTime == true,
        isThreeLine: true,
        trailing: Text(
          widget.data.isManagerApproved == null
              ? "Not Updated"
              : (widget.data.isManagerApproved == true
                  ? "Accepted"
                  : "Rejected"),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        dense: true,
        onTap: openTimeFillPopup,
      ),
    );
  }
}
