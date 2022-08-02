import 'dart:convert';

import 'package:car_book_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class HistoryData {
  final int uid;
  final String travelPurpose;
  final String expectedDistance;
  final String pickupDateTime;
  final String pickupVenue;
  final String arrivalDateTime;
  final String? additionalInfo;
  final bool isApproved;

  HistoryData(
    this.uid,
    this.travelPurpose,
    this.expectedDistance,
    this.pickupDateTime,
    this.pickupVenue,
    this.arrivalDateTime,
    this.additionalInfo,
    this.isApproved,
  );
}

class HistoryWidget extends StatelessWidget {
  final HistoryData data;

  const HistoryWidget({required Key key, required this.data})
      : assert(data != null),
        super(key: key);

  static List<dynamic> histories = [];

  static void getHistory() async {
    try {
      http.Response res = await http
          .get(Uri.http(MyApp.backendIP, '/history/${MyApp.userInfo['uid']}'));
      histories = jsonDecode(res.body);
    } catch (err) {
      Fluttertoast.showToast(
        msg: 'Connection Error',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    getHistory();
    return ListTile(
      title: Row(
        children: [
          Text(data.travelPurpose),
          Text(
            data.isApproved == null
                ? "Not Approved"
                : (data.isApproved == true ? "Accepted" : "Rejected"),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Text(data.expectedDistance),
          Text(data.pickupDateTime),
          Text(data.pickupVenue),
        ],
      ),
    );
    //   child: Row(
    //     children: [
    //       Text("uid = ${histories[0]['uid']}"),
    //       Text("travelPurpose = ${histories[0]['travelPurpose']}"),
    //       Text("expectedDistance = ${histories[0]['expectedDistance']}"),
    //       Text("pickupDateTime = ${histories[0]['pickupDateTime']}"),
    //       Text("pickupVenue = ${histories[0]['pickupVenue']}"),
    //       Text("arrivalDateTime = ${histories[0]['arrivalDateTime']}"),
    //       Text("additionalInfo = ${histories[0]['additionalInfo']}"),
    //       Text("isApproved = ${histories[0]['isApproved']}"),
    //     ],
    //   ),
    // );
  }
}

// List<dynamic> histories = [];
