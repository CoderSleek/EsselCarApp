import 'package:car_book_app/widgets/mydrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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
  // final TextEditingController _textShow = TextEditingController();

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
      var json = {
        'travelPurpose': _travelPurpose.text,
        'pickUpTimeDate': "${_selectedTime.text},  ${_dateinput.text}",
        'arrivalTimeDate': _expectedTime.text,
        'additionalInfo': _additionalInput.text,
      };
      print(json);
    } else {
      print("some error");
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
    super.dispose();
  }

  Future<String> fetchPosts() async {
    final response = await http.get(Uri.parse('http://10.0.3.2:5000/'));
    return response.body;
  }

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
                        // _selectedTime.text = pickedTime.format(context);
                        var now = DateTime.now();
                        _selectedTime.text =
                            DateFormat('hh:mm').format(DateTime(
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
                TextField(
                  controller: _additionalInput,
                  decoration: const InputDecoration(
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
