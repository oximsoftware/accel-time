import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/Utilities/shared_preference_util.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Myprofile extends StatefulWidget {
  const Myprofile({Key? key}) : super(key: key);

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  final List<String> menus = ["Name", "Desgination", "Gender", "Dob", "City"];
  String shortName = "";
  String mainName = "";
  String desgnation = "";
  String email = "";
  String phone = "";
  String address = "";
  String dob = "";
  bool isDOb = false;
  bool _isLoading = false;
  @override
  void initState() {
    myprofile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My profile"),
      ),
      backgroundColor: Colors.grey.withOpacity(1.0),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : SizedBox(
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
                          shortName,
                          style: TextStyle(fontSize: 50),
                        ),
                        radius: 50,
                      ),
                      const Positioned(
                          right: 0, bottom: 0, child: Icon(Icons.camera))
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(mainName,
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(desgnation,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.email),
                              title: Text("Email",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white)),
                              subtitle: Text(email,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            ListTile(
                              leading: Icon(Icons.phone),
                              title: Text("MOBILE NUMBER",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white)),
                              subtitle: Text(phone,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Visibility(
                              visible: isDOb,
                              child: Column(
                                children: [
                                  Divider(
                                    color: Colors.white,
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.calendar_today),
                                    title: Text("DOB",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white)),
                                    subtitle: Text(dob,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            ListTile(
                              leading: Icon(Icons.location_city),
                              title: Text("ADDRESS",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white)),
                              subtitle: Text(address,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Divider(
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  void _showToast(String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 2000),
        content: Text(msg),
      ),
    );
  }

  //API
  myprofile() async {
    String accessPoint = "";
    Utils.checkInternetConnection().then((connectionResult) async {
      if (connectionResult) {
        setState(() {
          _isLoading = true;
        });
        Future<String> accesspoint =
            Preference.getStringItem(Constants.activation_data);
        accesspoint.then((data) async {
          if (data.isNotEmpty) {
            Map point = json.decode(data);
            accessPoint = point['AccessPoint'];
            Future<String> loginData =
                Preference.getStringItem(Constants.login_data);
            loginData.then((data) async {
              if (data.isNotEmpty) {
                Map point = json.decode(data);
                String query = "";
                String url = "";
                if (point["RoleType"] == 2) {
                  query = '/${point['ClientID']}/1/${accessPoint}';
                  url = Constants.base_url + 'ClientProfile' + query;
                } else {
                  query = '/${point['EmpID']}/1/${accessPoint}';
                  url = Constants.base_url + 'EmployeeProfile' + query;
                }

                var uri = Uri.parse(url);

                final response = await http.get(
                  uri,
                  headers: <String, String>{
                    'Content-Type': "application/json",
                  },
                );
                setState(() {
                  _isLoading = false;
                });

                if (response.statusCode == 200) {
                  Map parsed = json.decode(response.body);
                  if (parsed != null) {
                    setState(() {
                      List data = parsed['value'];
                      if (data.isNotEmpty) {
                        Map mapData = data[0];
                        print(mapData);
                        if (point["RoleType"] == 2) {
                          mainName = mapData["Clinet"];
                          String state = mapData["State"];
                          String city = mapData["City"];
                          isDOb = false;
                          desgnation = state + "," + city;
                          email = mapData["Email"];
                          phone = mapData["PhoneNumber"];
                          // dob = mapData["DateOfBirth"];
                          String add1 = mapData["Address1"];
                          String add2 = mapData["Address2"];
                          address = add1 + "," + add2;
                        } else {
                          isDOb = true;
                          mainName = mapData["Employee"];
                          desgnation = mapData["Designation"];
                          email = mapData["Email"];
                          phone = mapData["MobileNo"];
                          dob = mapData["DateOfBirth"];
                          String add1 = mapData["Address1"];
                          String add2 = mapData["Address2"];
                          address = add1 + "," + add2;
                        }
                      } else {
                        _showToast("Host Unreachable, try again later");
                      }
                    });
                  }
                } else {
                  _showToast("Host Unreachable, try again later");
                }
              } else {}
            }, onError: (e) {});
          }
        }, onError: (e) {});
      } else {
        _showToast("No internet connection available");
      }
    });
  }
}
