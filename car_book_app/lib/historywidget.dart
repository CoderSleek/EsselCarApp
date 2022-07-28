import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryData {
  final int emp_id;
  final String travel_purpose;
  final String pickup_venue;
  final String pick_up_date_and_time;
  final String expected_time;
  final String? add_info;
  final bool is_approved;

  HistoryData(
    this.emp_id,
    this.travel_purpose,
    this.pickup_venue,
    this.pick_up_date_and_time,
    this.expected_time,
    this.add_info,
    this.is_approved,
  );
}

class HistoryWidget extends StatelessWidget {
  final HistoryData data;

  const HistoryWidget({required Key key, required this.data})
      : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material();
  }
}

var histories = [];
