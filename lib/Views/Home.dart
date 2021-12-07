import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerbangsekolah/Services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginScreen.dart';
import 'Student/StudentAssignment.dart';
import 'Teacher/TeacherAssignment.dart';
import 'Student/StudentDashboard.dart';
import 'Teacher/TeacherDashboard.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    readToken();
  }

  void readToken() async {
    SharedPreferences prefs = await _prefs;
    late String? token = prefs.getString('token');
    Provider.of<Auth>(context, listen: false).getData(token!);
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Consumer<Auth>(builder: (context, auth, _) {
          if (!auth.authenticated) {
            return LoginScreen();
          } else {
            if (auth.isTeacher) {
              return FloatingNavBar(
                color: Colors.blue,
                items: [
                  FloatingNavBarItem(
                    iconData: Icons.home,
                    title: 'Home',
                    page: TeacherDashboard(),
                  ),
                  FloatingNavBarItem(
                    iconData: Icons.account_circle,
                    title: 'Account',
                    page: TeacherAssignment(),
                  )
                ],
                selectedIconColor: Colors.white,
                hapticFeedback: true,
                horizontalPadding: 40,
              );
            } else {
              return FloatingNavBar(
                color: Colors.blue,
                items: [
                  FloatingNavBarItem(
                    iconData: Icons.home,
                    title: 'Home',
                    page: StudentDashboard(),
                  ),
                  FloatingNavBarItem(
                    iconData: Icons.account_circle,
                    title: 'Account',
                    page: StudentAssignment(),
                  )
                ],
                selectedIconColor: Colors.white,
                hapticFeedback: true,
                horizontalPadding: 40,
              );
            }
          } //else
        })
      )
    );
  }
}
