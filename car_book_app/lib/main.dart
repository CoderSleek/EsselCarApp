import 'package:car_book_app/createbooking.dart';
import 'package:car_book_app/home_login.dart';
import 'package:car_book_app/startpage.dart';
import 'package:car_book_app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String appVersion = "1.0.0";
  static const String backendIP = "10.0.3.2:5000";
  static late Map userInfo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.light,
      routes: {
        "/": (context) => LoginPage(),
        MyRoutes.loginRoute: (context) => LoginPage(),
        MyRoutes.startRoute: (context) => StartPage(),
        MyRoutes.createBooking: (context) => CreateBooking(),
      },
    );
  }
}
