import 'dart:convert';

import 'package:car_book_app/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class HistoryData {
  late int uid;
  late String travelPurpose;
  late double expectedDistance;
  late String pickupDateTime;
  late String pickupVenue;
  late String arrivalDateTime;
  late String? additionalInfo;
  late bool? isManagerApproved;
  late bool? isAdminApproved;

  HistoryData.fromJson(Map<String, dynamic> item) {
    uid = item['uid'];
    travelPurpose = item['travelPurpose'];
    expectedDistance = item['expectedDistance'];
    pickupVenue = item['pickupVenue'];
    additionalInfo = item['additionalInfo'];
    isManagerApproved = item['approvalStatus'];
    pickupDateTime = item['pickupDateTime'];
    arrivalDateTime = item['arrivalDateTime'];
    isAdminApproved = item['adminApproved'];
    // final RegExp dt = RegExp(r'^([\d]+)-(\d\d)-(\d\d).(\d\d):(\d\d)');
    // RegExpMatch? match = dt.firstMatch(item['pickupDateTime']);

    // pickupDateTime =
    //     '${match?[4]}:${match?[5]} ${match?[3]}-${match?[2]}-${match?[1]}';

    // match = dt.firstMatch(item['arrivalDateTime']);
    // arrivalDateTime =
    //     '${match?[4]}:${match?[5]} ${match?[3]}-${match?[2]}-${match?[1]}';
  }
}

class HistoryWidget extends StatefulWidget {
  static List<dynamic> histories = [];

  final HistoryData data;
  final int index;

  const HistoryWidget({required this.data, this.index = 0});

  static void getHistory() async {
    histories = [];
    try {
      http.Response res = await http
          .get(Uri.http(MyApp.backendIP, '/history/${MyApp.userInfo['uid']}'));
      List<dynamic> temp = jsonDecode(res.body);

      for (int i = 0; i < temp.length; ++i) {
        histories.add(HistoryData.fromJson(temp[i]));
      }
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
        enabled: widget.data.isManagerApproved == true,
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
        // horizontalTitleGap: 30,
        // leading: Text(this.index.toString()),
      ),
    );
  }
}
