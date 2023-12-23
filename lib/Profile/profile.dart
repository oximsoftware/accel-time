import 'package:acceltime/Client/location.dart';
import 'package:acceltime/Employee/employeeterms.dart';
import 'package:acceltime/Employee/leavebalance.dart';
import 'package:acceltime/Employee/leaves.dart';
import 'package:acceltime/Employee/model.dart';
import 'package:acceltime/Employee/mytraining.dart';
import 'package:acceltime/Profile/myprofile.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:acceltime/login.dart';
import 'package:flutter/material.dart';

import '../Employee/Insidentreporing/insidentlist.dart';
import '../Utilities/shared_preference_util.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

enum MenuType { employee, hosptial }

class _ProfileState extends State<Profile> {
  final List<ProfileMenu> menus = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setMenu();
  }

  setMenu() {
    Future<String> roleType = Preference.getStringItem(Constants.roleType);
    roleType.then((data) async {
      if (data.isNotEmpty) {
        if (data == "2") {
          setState(() {
            menus.add(
                ProfileMenu(header: "My profile", type: MenuType.employee));
            menus.add(ProfileMenu(
                header: "Hospital profile", type: MenuType.employee));

            menus
                .add(ProfileMenu(header: "Locations", type: MenuType.employee));
            menus.add(ProfileMenu(header: "Logout", type: MenuType.employee));
          });
        } else {
          setState(() {
            menus.add(
                ProfileMenu(header: "My profile", type: MenuType.employee));
            menus.add(
                ProfileMenu(header: "Payment Terms", type: MenuType.employee));
            menus
                .add(ProfileMenu(header: "My Leaves", type: MenuType.employee));
            menus.add(
                ProfileMenu(header: "Leave Balance", type: MenuType.employee));
            menus.add(
                ProfileMenu(header: "My Training", type: MenuType.employee));
            menus.add(ProfileMenu(
                header: "Incident Reporting", type: MenuType.employee));
            menus.add(ProfileMenu(header: "Logout", type: MenuType.employee));
          });
        }
      } else {}
    }, onError: (e) {});

    // menus.add(ProfileMenu(header: "Favourites", type: MenuType.employee));
    // menus.add(ProfileMenu(header: "Location", type: MenuType.employee));
    // menus.add(ProfileMenu(header: "Settings", type: MenuType.employee));
  }

  @override
  Widget build(BuildContext context) {
    double padding = MediaQuery.of(context).size.width * 0.28;
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.4),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Stack(children: [
                CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(
                    "",
                    style: TextStyle(fontSize: 50),
                  ),
                  radius: 50,
                ),
                Positioned(right: 0, bottom: 0, child: Icon(Icons.camera))
              ]),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.verified_user),
                          onTap: () {
                            String header = menus[index].header!;
                            if (header == "My profile") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Myprofile()));
                            } else if (header == "Payment Terms") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const EmployeeTerms()));
                            } else if (header == "My Leaves") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Myleaves()));
                            } else if (header == "Leave Balance") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Leavebalance()));
                            } else if (header == "My Training") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Mytraing()));
                            } else if (header == "Locations") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ClientLocations()));
                            } else if (header == "Incident Reporting") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const InsidentList()));
                            } else if (header == "Logout") {
                              Preference.setStringItem(
                                  Constants.login_data, "");
                              Preference.setStringItem(Constants.roleType, "");
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (_) => Login()));
                            }
                          },
                          title: Text(menus[index].header!),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 15,
                        );
                      },
                      itemCount: menus.length),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenu {
  String? header;
  MenuType? type;

  ProfileMenu({this.header, this.type});
}
