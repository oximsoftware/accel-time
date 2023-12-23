import 'package:acceltime/Client/location.dart';
import 'package:acceltime/Client/timesheet.dart';
import 'package:acceltime/Employee/Mycliams/claims.dart';
import 'package:acceltime/Employee/model.dart';
import 'package:acceltime/Employee/mytraining.dart';
import 'package:acceltime/Home/Leave/applyleave.dart';
import 'package:acceltime/Home/Other_Scheudules/otherschedule.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import '../Client/clientleaves.dart';
import '../Utilities/Utils.dart';
import '../Utilities/shared_preference_util.dart';
import '../constants/constants.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<Menus> menuList = [];
  bool _isapply = false;
  bool _isLoading = false;
  bool _nodata = true;
  bool _boxfullEmpty = true;
  String clientLocation = "";
  String scheduledTime = "";
  List<ScheduleModel> schelueList = [];
  String CheckInTitle = "Check In";
  String CheckoutTitle = "Check Out";
  @override
  void initState() {
    setState(() {
      addMenus();
    });

    super.initState();
  }

  addMenus() {
    Future<String> roleType = Preference.getStringItem(Constants.roleType);
    roleType.then((data) async {
      if (data.isNotEmpty) {
        if (data == "2") {
          setState(() {
            menuList.add(Menus(
                name: "Leave", image: 'assests/images/leave.png', type: "H"));
            menuList.add(Menus(
                name: "Time sheet",
                image: 'assests/images/sheet.png',
                type: "H"));
            menuList.add(Menus(
                name: "Grievance",
                image: 'assests/images/report.png',
                type: "H"));
            _boxfullEmpty = false;
          });
        } else {
          setState(() {
            myschedules();
            menuList.add(Menus(
                name: "Leave", image: 'assests/images/leave.png', type: "E"));
            menuList.add(Menus(
                name: "Training",
                image: 'assests/images/train.png',
                type: "E"));
            menuList.add(Menus(
                name: "Claims", image: 'assests/images/claim.png', type: "E"));
            _boxfullEmpty = true;
          });
        }
      } else {}
    }, onError: (e) {});
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      child: Scaffold(
        body: LoadingOverlay(
          isLoading: _isapply,
          opacity: 0.3,
          progressIndicator: CircularProgressIndicator(
            color: Colors.red,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assests/images/splash.png'),
                fit: BoxFit.cover,
              )),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.3,
                    height: MediaQuery.of(context).size.height * 0.09,
                    child: Image.asset(
                      'assests/images/logo.png',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible: _boxfullEmpty,
                    child: Column(
                      children: [
                        Visibility(
                          visible: !_nodata,
                          child: SizedBox(
                            height: 120,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                          height: double.infinity,
                                          width: 5,
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)))),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "No more schedules today",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              const Otherschedules()));
                                                },
                                                child: Text("More schedules",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blueAccent,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _nodata,
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                  ),
                                )
                              : SizedBox(
                                  height: 160,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Stack(
                                          children: [
                                            Container(
                                                height: double.infinity,
                                                width: 5,
                                                decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)))),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            scheduledTime,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 0, 0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        const Otherschedules()));
                                                          },
                                                          child: Text(
                                                              "More schedules",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      clientLocation,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 130,
                                                        child: TextButton(
                                                            style: ButtonStyle(
                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .green))),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        Colors
                                                                            .white70)),
                                                            onPressed: () {
                                                              if (schelueList
                                                                  .isNotEmpty) {
                                                                if (schelueList[
                                                                            0]
                                                                        .inTime ==
                                                                    null) {
                                                                  Future<String>
                                                                      loginData =
                                                                      Preference.getStringItem(
                                                                          Constants
                                                                              .login_data);
                                                                  loginData.then(
                                                                      (data) async {
                                                                    if (data
                                                                        .isNotEmpty) {
                                                                      Map point =
                                                                          json.decode(
                                                                              data);

                                                                      DateTime
                                                                          now =
                                                                          DateTime
                                                                              .now();
                                                                      String
                                                                          formattedDate =
                                                                          DateFormat('yyyy-MM-dd')
                                                                              .format(now);

                                                                      String
                                                                          formattedDate2 =
                                                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                                                              .format(now);

                                                                      Map innerData =
                                                                          {
                                                                        "ClientID":
                                                                            schelueList[0].clientID,
                                                                        "LocationID":
                                                                            schelueList[0].locationID,
                                                                        "DepartID":
                                                                            schelueList[0].departID,
                                                                        "ShiftID":
                                                                            schelueList[0].shiftID,
                                                                        "DesigID":
                                                                            schelueList[0].desigID,
                                                                        "EmpID":
                                                                            point['EmpID'],
                                                                        "AttendDate":
                                                                            formattedDate,
                                                                        "AttendTime":
                                                                            formattedDate2,
                                                                        "ResourceScheduleID":
                                                                            schelueList[0].resourceScheduleID,
                                                                        "UserID":
                                                                            point['UserID']
                                                                      };
                                                                      print(
                                                                          innerData);
                                                                      Map main =
                                                                          {
                                                                        "Head":
                                                                            innerData
                                                                      };

                                                                      applyCheck(
                                                                          main,
                                                                          "IN",
                                                                          context);
                                                                    } else {}
                                                                  },
                                                                      onError:
                                                                          (e) {});
                                                                }
                                                              }
                                                            },
                                                            child: Text(
                                                                CheckInTitle,
                                                                style: TextStyle(
                                                                    color: Colors.green,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.bold))),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 130,
                                                        child: TextButton(
                                                            style: ButtonStyle(
                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .red))),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        Colors
                                                                            .white)),
                                                            onPressed: () {
                                                              if (schelueList
                                                                  .isNotEmpty) {
                                                                if (schelueList[
                                                                            0]
                                                                        .outTime ==
                                                                    null) {
                                                                  Future<String>
                                                                      loginData =
                                                                      Preference.getStringItem(
                                                                          Constants
                                                                              .login_data);
                                                                  loginData.then(
                                                                      (data) async {
                                                                    if (data
                                                                        .isNotEmpty) {
                                                                      Map point =
                                                                          json.decode(
                                                                              data);

                                                                      DateTime
                                                                          now =
                                                                          DateTime
                                                                              .now();
                                                                      String
                                                                          formattedDate =
                                                                          DateFormat('yyyy-MM-dd')
                                                                              .format(now);

                                                                      String
                                                                          formattedDate2 =
                                                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                                                              .format(now);

                                                                      Map innerData =
                                                                          {
                                                                        "ClientID":
                                                                            schelueList[0].clientID,
                                                                        "LocationID":
                                                                            schelueList[0].locationID,
                                                                        "DepartID":
                                                                            schelueList[0].departID,
                                                                        "ShiftID":
                                                                            schelueList[0].shiftID,
                                                                        "DesigID":
                                                                            schelueList[0].desigID,
                                                                        "EmpID":
                                                                            point['EmpID'],
                                                                        "AttendDate":
                                                                            formattedDate,
                                                                        "AttendTime":
                                                                            formattedDate2,
                                                                        "ResourceScheduleID":
                                                                            schelueList[0].resourceScheduleID,
                                                                        "UserID":
                                                                            point['UserID']
                                                                      };
                                                                      print(
                                                                          innerData);
                                                                      Map main =
                                                                          {
                                                                        "Head":
                                                                            innerData
                                                                      };

                                                                      applyCheck(
                                                                          main,
                                                                          "OUT",
                                                                          context);
                                                                    } else {}
                                                                  },
                                                                      onError:
                                                                          (e) {});
                                                                }
                                                              }
                                                            },
                                                            child: Text(
                                                                CheckoutTitle,
                                                                style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.bold))),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Color(0xffF8F8F8), Color(0xffF9F9F9)],
                              ),
                              color: const Color(0xffF8F8F8).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                              ),
                              itemCount: menuList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (menuList[index].name == "Leave" &&
                                        menuList[index].type == "E") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const Leaveapply()));
                                    } else if (menuList[index].name ==
                                            "Leave" &&
                                        menuList[index].type == "H") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const Clientleaves()));
                                    } else if (menuList[index].name ==
                                        "Time sheet") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const Timesheets()));
                                    } else if (menuList[index].name ==
                                        "Training") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const Mytraing()));
                                    } else if (menuList[index].name ==
                                        "Claims") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const Myclaims()));
                                    }
                                  },
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 90,
                                          width: 90,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Center(
                                              child: SizedBox(
                                            height: 44,
                                            width: 44,
                                            child: Image.asset(
                                                menuList[index].image!),
                                          )),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          menuList[index].name!,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 17),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showToast(String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 2000),
        content: Text(msg),
      ),
    );
  }

  //API
//Check In //Check Out
  applyCheck(Map checkDetails, String type, BuildContext context) async {
    String accessPoint = "";
    print(checkDetails);
    Utils.checkInternetConnection().then((connectionResult) async {
      if (connectionResult) {
        setState(() {
          _isapply = true;
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

                String query = '${type}/${point['EmpID']}/${accessPoint}';
                String url = Constants.base_url + 'Attendance/Save/' + query;

                var uri = Uri.parse(url);
                var body = jsonEncode(checkDetails);
                final response = await http.post(uri,
                    headers: <String, String>{
                      'Content-Type': "application/json",
                    },
                    body: body);
                setState(() {
                  _isapply = false;
                });
                print(response.toString());
                if (response.statusCode == 200) {
                  Map parsed = json.decode(response.body);

                  myschedules();
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

  myschedules() async {
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

                String query = '/${point['EmpID']}/1/${accessPoint}';
                String url =
                    Constants.base_url + 'EmployeeTodaySchedule' + query;

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
                      schelueList = data
                          .map((job) => ScheduleModel.fromJson(job))
                          .toList();

                      if (schelueList.isEmpty) {
                        _nodata = false;
                      } else {
                        String first = schelueList[0].client ?? "";
                        String second = schelueList[0].location ?? "";

                        clientLocation = first + "," + second;
                        String one = schelueList[0].shiftFromTime ?? "";
                        String two = schelueList[0].shiftToTime ?? "";

                        scheduledTime = one + " - " + two;
                        if (schelueList[0].inTime != null) {
                          CheckInTitle = schelueList[0].inTime!;
                        }
                        if (schelueList[0].outTime != null) {
                          CheckoutTitle = schelueList[0].outTime!;
                        }
                      }
                    });
                  }
                } else {
                  _showToast("Host Unreachable, try again later");
                  _nodata = false;
                }
              } else {}
            }, onError: (e) {});
          }
        }, onError: (e) {});
      } else {
        _showToast("No internet connection available");
        _nodata = true;
      }
    });
  }
}

class Menus {
  String? name;
  String? image;
  String? type;

  Menus({this.name, this.image, this.type});
}
