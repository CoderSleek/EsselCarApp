import 'package:car_book_app/widgets/mydrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateBooking extends StatefulWidget {
  @override
  State<CreateBooking> createState() => _CreateBookingState();
}

class _CreateBookingState extends State<CreateBooking> {
  final TextEditingController _dateinput = TextEditingController();
  final TextEditingController _selectedTime = TextEditingController();
  final TextEditingController _expectedTime = TextEditingController();
  static DateTime changedVal = DateTime.now();

  final _createBookingKey = GlobalKey<FormState>();
  void validateBookingInformation() {
    if (_createBookingKey.currentState!.validate()) {
      print("validated");
    } else {
      print("some error");
    }
  }

  Widget cupertinomaker() => SizedBox(
        height: 200,
        child: CupertinoDatePicker(
          onDateTimeChanged: (val) {
            // _expectedTime.text = TimeOfDay.fromDateTime(val).format(context);
            changedVal = val;
            _expectedTime.text =
                DateFormat('hh:mm a,  dd-MM-yyyy').format(changedVal);
          },
          initialDateTime: changedVal,
          mode: CupertinoDatePickerMode.dateAndTime,
        ),
      );

  static void showSheet(
          {required BuildContext context,
          required Widget child,
          required VoidCallback onClicked}) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: onClicked,
            child: const Text("Done"),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Form(
            key: _createBookingKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Travel Purpose cannot be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Purpose of Travel",
                    label: Text("Travel Purpose"),
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
                        _selectedTime.text = pickedTime.format(context);
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
                  ),
                ),
                // const TextField(),
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
                      hintText: "Time(hh:mm) Date(dd-mm-yyyy)"),
                  onTap: () => showSheet(
                    context: context,
                    child: cupertinomaker(),
                    onClicked: () {
                      _expectedTime.text =
                          DateFormat('hh:mm a,  dd-MM-yyyy').format(changedVal);
                      Navigator.pop(context);
                    },
                  ),
                ),
                const TextField(
                  decoration: InputDecoration(
                    label: Text("Additional Information"),
                    hintText: "Optional",
                  ),
                ),
                ElevatedButton(
                  onPressed: validateBookingInformation,
                  child: const Text("Press me"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
