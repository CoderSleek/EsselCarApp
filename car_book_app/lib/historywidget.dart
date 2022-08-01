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
  final String pickUpTimeDate;
  final String pickupVenue;
  final String arrivalTimeDate;
  final String? additionalInfo;
  final bool isApproved;

  HistoryData(
    this.uid,
    this.travelPurpose,
    this.expectedDistance,
    this.pickUpTimeDate,
    this.pickupVenue,
    this.arrivalTimeDate,
    this.additionalInfo,
    this.isApproved,
  );
}

class HistoryWidget extends StatelessWidget {
  // final HistoryData data;

  // const HistoryWidget({required Key key, required this.data})
  //     : assert(data != null),
  //       super(key: key);

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
    return Material();
  }
}

List<dynamic> histories = [];
