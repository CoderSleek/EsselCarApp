import 'package:car_book_app/home_login.dart';
import 'package:car_book_app/main.dart';
import 'package:car_book_app/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  void changeScreen() {}

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
                margin: EdgeInsets.zero,
                currentAccountPictureSize:
                    Size(MediaQuery.of(context).size.width * 0.75, 100),
                currentAccountPicture: const Icon(
                  Icons.person,
                  size: 80,
                ),
                // margin: EdgeInsets.zero,
                accountName: Text(
                  LoginPage.uid,
                ),
                accountEmail: Text(
                  "${LoginPage.uid}@gmail.com",
                ),
              ),
            ),
            const ListTile(
              onTap: changeScreen(),
              leading: Icon(Icons.logout_rounded),
              iconColor: Colors.white,
              title: Text(
                "Logout",
                textScaleFactor: 0.9,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(CupertinoIcons.info),
              iconColor: Colors.white,
              title: Text(
                "Version: ${MyApp.appVersion}",
                textScaleFactor: 0.9,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
