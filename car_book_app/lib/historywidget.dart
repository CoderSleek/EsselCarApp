import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryWidget {
  final int emp_id;
  final String travel_purpose;
  final String pickup_venue;
  final String pick_up_date_and_time;
  final String expected_time;
  final String? add_info;
  final bool is_approved;

  HistoryWidget(
    this.emp_id,
    this.travel_purpose,
    this.pickup_venue,
    this.pick_up_date_and_time,
    this.expected_time,
    this.add_info,
    this.is_approved,
  );
}
