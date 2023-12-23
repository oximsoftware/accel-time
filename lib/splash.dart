import 'dart:convert';

import 'package:acceltime/Home/home.dart';
import 'package:acceltime/Profile/profile.dart';
import 'package:acceltime/activatepage.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:acceltime/login.dart';
import 'package:flutter/material.dart';

import 'Home/menu.dart';
import 'Notifications/notifications.dart';
import 'Utilities/shared_preference_util.dart';

class Splash extends StatefulWidget {
  static final valueKey = ValueKey('Splash');

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();

    Future<String> accesspoint =
        Preference.getStringItem(Constants.activation_data);
    accesspoint.then((data) async {
      if (data.isEmpty) {
        setState(() {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const Activatepage()));
        });
      } else {
        Future<String> accesspoint =
            Preference.getStringItem(Constants.login_data);
        accesspoint.then((data) async {
          if (data.isNotEmpty) {
            Map point = json.decode(data);

            List<BottomNavigationBarItem> menus = [];
            List<Widget> pages = [];
            if (point["RoleType"] == 2) {
              menus = const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Profile")
              ];
              pages = const [Menu(), Profile()];
            } else {
              menus = const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Profile"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: "Notifications")
              ];
              pages = const [Menu(), Profile(), Notifications()];
            }

            setState(() {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Home(
                            menus: menus,
                            pages: pages,
                          )));
            });
          } else {
            setState(() {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const Login()));
            });
          }
        }, onError: (e) {
          setState(() {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const Login()));
          });
        });
      }
    }, onError: (e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ui(),
    );
  }

  Widget ui() {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assests/images/splash.png'),
        fit: BoxFit.cover,
      )),
    );
  }
}
