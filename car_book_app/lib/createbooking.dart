import 'dart:convert';

import 'package:car_book_app/historywidget.dart';
import 'package:car_book_app/home_login.dart';
import 'package:car_book_app/main.dart';
import 'package:car_book_app/widgets/mydrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class CreateBooking extends StatefulWidget {
  @override
  State<CreateBooking> createState() => _CreateBookingState();
}

class _CreateBookingState extends State<CreateBooking> {
  final TextEditingController _travelPurpose = TextEditingController();
  final TextEditingController _dateinput = TextEditingController();
  final TextEditingController _selectedTime = TextEditingController();
  final TextEditingController _expectedTime = TextEditingController();
  final TextEditingController _additionalInput = TextEditingController();
  final TextEditingController _pickupVenue = TextEditingController();
  final TextEditingController _expectedDist = TextEditingController();

  static final RegExp isValid = RegExp(r'^[a-zA-Z0-9 ]+$');

  static DateTime arrivalTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    ((DateTime.now().minute ~/ 10) * 10).toInt(),
  );

  final _createBookingKey = GlobalKey<FormState>();

  void validateBookingInformation() {
    if (_createBookingKey.currentState!.validate()) {
      Map body = {
        "uid": MyApp.userInfo['uid'],
        "travelPurpose": _travelPurpose.text,
        "expectedDistance": _expectedDist.text,
        "pickupDateTime": "${_selectedTime.text},  ${_dateinput.text}",
        "pickupVenue": _pickupVenue.text,
        "arrivalDateTime": _expectedTime.text,
        "additionalInfo":
            _additionalInput.text != '' ? _additionalInput.text : null,
      };
      sendCreateBookingRequest(body);
    }
  }

  void sendCreateBookingRequest(Map body) async {
    try {
      http.Response response = await http.post(
          Uri.http(MyApp.backendIP, '/newbooking'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        // HistoryWidget.getHistory();
        Fluttertoast.showToast(msg: "Success", toastLength: Toast.LENGTH_SHORT);
      } else {
        Fluttertoast.showToast(
            msg: "Error Occured", toastLength: Toast.LENGTH_SHORT);
      }
      Navigator.pop(context);
    } catch (err) {
      Fluttertoast.showToast(
          msg: "Connectivity Error", toastLength: Toast.LENGTH_SHORT);
    }
  }

  Widget cupertinomaker() => SizedBox(
        height: 200,
        child: CupertinoDatePicker(
          onDateTimeChanged: (val) {
            // _expectedTime.text = TimeOfDay.fromDateTime(val).format(context);
            arrivalTime = val;
            _expectedTime.text =
                DateFormat('hh:mm a,  dd-MM-yyyy').format(arrivalTime);
          },
          initialDateTime: arrivalTime,
          mode: CupertinoDatePickerMode.dateAndTime,
          minuteInterval: 10,
        ),
      );

  static void showSheet({
    required BuildContext context,
    required Widget child,
    required VoidCallback onClicked,
  }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: onClicked,
            child: const Text(
              "Done",
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _travelPurpose.dispose();
    _dateinput.dispose();
    _selectedTime.dispose();
    _expectedTime.dispose();
    _additionalInput.dispose();
    _pickupVenue.dispose();
    _expectedDist.dispose();
    super.dispose();
  }

  // Future<String> fetchPosts() async {
  //   final response = await http.get(Uri.parse('http://10.0.3.2:5000/'));
  //   return response.body;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          style: TextStyle(
            fontFamily: GoogleFonts.courgette().fontFamily,
            fontSize: 24,
            letterSpacing: 0.3,
            wordSpacing: 0.3,
          ),
          "New Booking",
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Form(
            key: _createBookingKey,
            child: Column(
              children: [
                // Text(_textShow.text),
                // ElevatedButton(
                //     onPressed: () async {
                //       String x = await fetchPosts();
                //       setState(() {
                //         _textShow.text = x;
                //       });
                //     },
                //     child: Text("btn")),
                TextFormField(
                  maxLength: 50,
                  controller: _travelPurpose,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Travel Purpose cannot be empty";
                    } else if (!(isValid.hasMatch(value))) {
                      return "Purpose Cannot Contain Special Charachters";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Purpose of Travel",
                    label: Text("Travel Purpose"),
                  ),
                ),
                TextFormField(
                  maxLength: 50,
                  controller: _pickupVenue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Pickup Venue Cannot be Empty";
                    } else if (!(isValid.hasMatch(value))) {
                      return "Venue Cannot contain Special Charachters";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.location_city,
                      color: Colors.blue,
                    ),
                    hintText: "Address of pickup",
                    labelText: "Pickup Venue",
                  ),
                ),
                TextFormField(
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Date Cannot be Blank";
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2026),
                    );

                    if (pickedDate != null) {
                      String stringDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);

                      setState(() {
                        _dateinput.text = stringDate;
                      });
                    }
                  },
                  controller: _dateinput,
                  decoration: const InputDecoration(
                    icon: Icon(
                      CupertinoIcons.calendar,
                      color: Colors.blue,
                    ),
                    labelText: "Pick-up Date",
                    hintText: "dd-mm-yyyy",
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
                        // _selectedTime.text = pickedTime.format(context);
                        var now = DateTime.now();
                        _selectedTime.text =
                            DateFormat('hh:mm a').format(DateTime(
                          now.year,
                          now.month,
                          now.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        ));
                      });
                    }
                  },
                  controller: _selectedTime,
                  decoration: const InputDecoration(
                    icon: Icon(
                      CupertinoIcons.clock_fill,
                      color: Colors.blue,
                    ),
                    labelText: "Pick-up Time",
                    hintText: "hh:mm",
                  ),
                ),
                TextFormField(
                  controller: _expectedTime,
                  readOnly: true,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.time_to_leave,
                      // CupertinoIcons.timer_fill,
                      // Icons.more_time,
                      color: Colors.blue,
                    ),
                    labelText: "Expected Date & time of arrival",
                    hintText: "Time(hh:mm) Date(dd-mm-yyyy)",
                  ),
                  onTap: () => showSheet(
                    context: context,
                    child: cupertinomaker(),
                    onClicked: () {
                      _expectedTime.text = DateFormat('hh:mm a,  dd-MM-yyyy')
                          .format(arrivalTime);
                      Navigator.pop(context);
                    },
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Arrival time cannot be empty";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  maxLength: 8,
                  controller: _expectedDist,
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
                    labelText: "Expected Distance",
                    hintText: "Distance in KM (e.g. 123.55)",
                  ),
                ),
                TextFormField(
                  controller: _additionalInput,
                  maxLength: 500,
                  validator: (value) {
                    if (!(value!.contains(RegExp(r'^[a-zA-Z ]*$')))) {
                      return "Can only contain alphabets";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Additional Information"),
                    hintText: "Optional",
                  ),
                ),
                ElevatedButton(
                  onPressed: validateBookingInformation,
                  child: const Text("Send Information"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
