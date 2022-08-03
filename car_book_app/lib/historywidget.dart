import 'dart:convert';
import 'dart:ffi';

import 'package:car_book_app/main.dart';
import 'package:flutter/cupertino.dart';
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
  late bool? isApproved;

  HistoryData.fromJson(Map<String, dynamic> item) {
    uid = item['uid'];
    travelPurpose = item['travelPurpose'];
    expectedDistance = item['expectedDistance'];
    pickupDateTime = item['pickupDateTime'];
    pickupVenue = item['pickupVenue'];
    arrivalDateTime = item['arrivalDateTime'];
    additionalInfo = item['additionalInfo'];
    isApproved = item['approvalStatus'];
  }
}

class HistoryWidget extends StatelessWidget {
  static List<dynamic> histories = [];

  final HistoryData data;

  const HistoryWidget({required this.data});

  static void getHistory() async {
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
    print(histories.length);
  }

  @override
  Widget build(BuildContext context) {
    print('exec');
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
          Text(data.expectedDistance.toString()),
          Text(data.pickupDateTime),
          Text(data.pickupVenue),
        ],
      ),
    );
  }
}
