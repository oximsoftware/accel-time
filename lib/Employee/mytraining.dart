import 'dart:convert';
import 'package:acceltime/Employee/Mycliams/addclaim.dart';
import 'package:acceltime/Employee/model.dart';
import 'package:http/http.dart' as http;
import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/Utilities/shared_preference_util.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:intl/intl.dart';

class Mytraing extends StatefulWidget {
  const Mytraing({super.key});

  @override
  State<Mytraing> createState() => _MytraingState();
}

class _MytraingState extends State<Mytraing> {
  List<Training> leaveList = [];
  bool _isLoading = false;
  bool _nodata = false;
  bool _isapply = false;
  @override
  void initState() {
    myTraining();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isapply,
      opacity: 0.0,
      progressIndicator: CircularProgressIndicator(
        color: Colors.red,
      ),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("My Training"),
          ),
          backgroundColor: Colors.grey.withOpacity(1.0),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                    child: _nodata
                        ? const Center(child: Text("No Training found"))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white.withOpacity(0.9),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(3, 15, 3, 15),
                                  child: ListTile(
                                    title: Text(
                                        leaveList[index].trainingType ?? "",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "Remark: ${leaveList[index].remarks ?? ""} "),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  color: Colors.grey.shade300),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("From: "),
                                                    Text(leaveList[index]
                                                            .fromDate ??
                                                        "")
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  color: Colors.grey.shade300),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("To: "),
                                                    Text(leaveList[index]
                                                            .toDate ??
                                                        "")
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (_) => AddClaim(
                                                                  TrainingID:
                                                                      leaveList[index]
                                                                              .trainingSchID ??
                                                                          "",
                                                                )));
                                              },
                                              child: Text(
                                                'Add Claim',
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (leaveList[index]
                                                        .attendanceFlag ==
                                                    "0") {
                                                  markAttendance(
                                                      leaveList[index]
                                                              .attendDate ??
                                                          "",
                                                      leaveList[index]
                                                              .trainingSchID ??
                                                          "",
                                                      context);
                                                } else {
                                                  _showToast(
                                                      "Attendance already marked");
                                                }
                                              },
                                              child: Text(
                                                'Mark Attendance',
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontWeight: FontWeight.bold,
                                                    color: leaveList[index]
                                                                .attendanceFlag ==
                                                            "0"
                                                        ? Colors.blue
                                                        : Colors.grey),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                color: Colors.transparent,
                              );
                            },
                            itemCount:
                                leaveList.isNotEmpty ? leaveList.length : 0),
                  ),
                )),
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

  markAttendance(String adate, String id, BuildContext context) async {
    String accessPoint = "";
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

                String query = '/${id}/${point['UserID']}/1/${accessPoint}';
                String url =
                    Constants.base_url + 'TrainingAttendance/Save/' + query;
                var inputFormat = DateFormat('dd/MM/yyyy');
                var outputFormat = DateFormat('yyyy-MM-dd');
                var date1 = inputFormat.parse(adate);
                String finalDate = outputFormat.format(date1);

                Map subData = {
                  "EmpID": point['UserID'],
                  "AttendanceDate": finalDate
                };
                List<dynamic> listsubData = [];
                listsubData.add(subData);
                Map attendanceData = {"Head": listsubData};

                var uri = Uri.parse(url);
                var body = jsonEncode(attendanceData);
                final response = await http.post(uri,
                    headers: <String, String>{
                      'Content-Type': "application/json",
                    },
                    body: body);
                setState(() {
                  _isapply = false;
                });

                if (response.statusCode == 200) {
                  Map parsed = json.decode(response.body);
                  _showToast("Attendance marked successfully");
                  myTraining();
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

  myTraining() async {
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
                String url = Constants.base_url + 'EmployeeTraining' + query;

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
                      leaveList =
                          data.map((job) => Training.fromJson(job)).toList();
                      _nodata = false;
                      if (leaveList.isEmpty) {
                        _nodata = true;
                      }
                    });
                  }
                } else {
                  _nodata = true;
                  _showToast("Host Unreachable, try again later");
                }
              } else {}
            }, onError: (e) {});
          }
        }, onError: (e) {});
      } else {
        _nodata = true;
        _showToast("No internet connection available");
      }
    });
  }
}
