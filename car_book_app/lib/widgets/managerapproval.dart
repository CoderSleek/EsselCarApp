import 'dart:convert';

import 'package:car_book_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManagerApprovalWidget extends StatefulWidget {
  static List dataList = [];

  final Map<dynamic, dynamic> singleData;
  final int index;

  const ManagerApprovalWidget({required this.singleData, this.index = 0});

  static void getApprovals() async {
    Uri uri =
        Uri.parse('http://${MyApp.backendIP}/getmanagerrequests?emp_id=5');

    try {
      http.Response res = await http.get(uri);
      print(jsonDecode(res.body));
      dataList = jsonDecode(res.body);
      for (int i = 0; i < dataList.length; ++i) {
        print(dataList[i]);
        print(dataList[i].runtimeType);
      }
    } catch (err) {
      print('in manager catch err');
      print(err);
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
          children: [Text(widget.singleData["bookingID"].toString())],
        ),
      ),
    );
  }
}
