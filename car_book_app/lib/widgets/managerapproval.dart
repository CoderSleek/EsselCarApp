import 'dart:convert';

import 'package:car_book_app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManagerApprovalWidget extends StatefulWidget {
  static List<dynamic> dataList = [];

  final Map<dynamic, dynamic> singleData;
  final int index;

  const ManagerApprovalWidget({required this.singleData, this.index = 0});

  static void getApprovals() async {
    Uri uri = Uri.http(MyApp.backendIP, '/getmanagerrequests');

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
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [Text(widget.singleData['bookingID'])],
        ),
      ),
    );
  }
}
