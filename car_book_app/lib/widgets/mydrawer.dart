import 'package:car_book_app/main.dart';
import 'package:car_book_app/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.deepPurple,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.deepPurple),
                margin: EdgeInsets.zero,
                currentAccountPictureSize:
                    Size(MediaQuery.of(context).size.width * 0.70, 100),
                currentAccountPicture: const Icon(
                  CupertinoIcons.person_crop_circle,
                  size: 80,
                  color: Colors.white70,
                ),
                accountName: Text(
                  MyApp.userInfo['name'],
                  style: TextStyle(
                    wordSpacing: 0.4,
                    height: 0.8,
                    letterSpacing: 0.3,
                    fontFamily: GoogleFonts.nunito().fontFamily,
                  ),
                ),
                accountEmail: Text(
                  MyApp.userInfo['email'],
                  style: TextStyle(
                    height: 0.8,
                    letterSpacing: 0.3,
                    fontFamily: GoogleFonts.nunito().fontFamily,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MyRoutes.loginRoute, (Route<dynamic> route) => false);
              },
              leading: const Icon(Icons.logout_rounded),
              iconColor: Colors.white,
              title: Text(
                "Logout",
                textScaleFactor: 0.9,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.1,
                  fontFamily: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                  ).fontFamily,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.info),
              iconColor: Colors.white,
              title: Text(
                "Version: ${MyApp.appVersion}",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.1,
                  fontFamily: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                  ).fontFamily,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
// <a href='https://pngtree.com/so/User'>User png from pngtree.com/</a>