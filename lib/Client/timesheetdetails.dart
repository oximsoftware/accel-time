import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/Utilities/shared_preference_util.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:acceltime/Employee/model.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:intl/intl.dart';

class Detailsheet extends StatefulWidget {
  String attendanceID;
  Detailsheet({super.key, required this.attendanceID});

  @override
  State<Detailsheet> createState() => _DetailsheetState();
}

class _DetailsheetState extends State<Detailsheet> {
  List<TimesheetDetail> timesheetList = [];
  bool _isLoading = false;
  bool _nodata = false;
  bool _isapply = false;
  bool _intimeClicked = false;
  bool _outimeClicked = false;
  String popupinputDate = "";
  String popupoutputDate = "";

  TextEditingController inTimeController = TextEditingController();
  TextEditingController outTimeController = TextEditingController();
  @override
  void initState() {
    mySheets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isapply,
      opacity: 0.3,
      progressIndicator: const CircularProgressIndicator(
        color: Colors.red,
      ),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Time sheets"),
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
                        ? const Center(child: Text("No Timesheets found"))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var inputFormat =
                                  DateFormat('yyyy-MM-ddTHH:mm:ss');
                              var date1 = inputFormat
                                  .parse(timesheetList[index].inTime ?? "");

                              var outputFormat =
                                  DateFormat('dd-MM-yyyy,HH:mm:ss');
                              String inDate = outputFormat.format(date1);

                              var date2 = inputFormat
                                  .parse(timesheetList[index].outTime ?? "");

                              String outDate = outputFormat.format(date2);
                              return Card(
                                color: Colors.white.withOpacity(0.9),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(3, 15, 3, 15),
                                  child: ListTile(
                                    trailing: InkWell(
                                        onTap: () {
                                          howDataAlert(timesheetList[index],
                                              inDate, outDate);
                                        },
                                        child: const Icon(Icons.edit)),
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                        timesheetList[index].employee ?? "",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text("InTime: ${inDate}"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text("OutTime: ${outDate} "),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            TextButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .green))),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green)),
                                              onPressed: () {
                                                TimesheetDetail sheetdata =
                                                    timesheetList[index];
                                                var inputFormat = DateFormat(
                                                    'yyyy-MM-ddTHH:mm:ss');
                                                var date1 = inputFormat.parse(
                                                    sheetdata.inTime ?? "");
                                                var outputFormat = DateFormat(
                                                    'yyyy-MM-dd HH:mm:ss');
                                                String inDate =
                                                    outputFormat.format(date1);
                                                var date2 = inputFormat.parse(
                                                    sheetdata.outTime ?? "");
                                                String outDate =
                                                    outputFormat.format(date2);

                                                Map approveData = {
                                                  "AttendID":
                                                      sheetdata.attendID,
                                                  "EmpID": sheetdata.empID,
                                                  "AttendInTime": inDate,
                                                  "AttendOutTime": outDate,
                                                  "SlNo": sheetdata.slNo,
                                                  "Mile": sheetdata.mile ?? "",
                                                  "Status": "A"
                                                };
                                                print(approveData);
                                                approve(false, true,
                                                    approveData, context);
                                              },
                                              child: const Text(
                                                "    Approve    ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            TextButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red))),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red)),
                                              onPressed: () {
                                                TimesheetDetail sheetdata =
                                                    timesheetList[index];
                                                var inputFormat = DateFormat(
                                                    'yyyy-MM-ddTHH:mm:ss');
                                                var date1 = inputFormat.parse(
                                                    sheetdata.inTime ?? "");
                                                var outputFormat = DateFormat(
                                                    'yyyy-MM-dd HH:mm:ss');
                                                String inDate =
                                                    outputFormat.format(date1);
                                                var date2 = inputFormat.parse(
                                                    sheetdata.outTime ?? "");
                                                String outDate =
                                                    outputFormat.format(date2);

                                                Map approveData = {
                                                  "AttendID":
                                                      sheetdata.attendID,
                                                  "EmpID": sheetdata.empID,
                                                  "AttendInTime": inDate,
                                                  "AttendOutTime": outDate,
                                                  "SlNo": sheetdata.slNo,
                                                  "Mile": sheetdata.mile ?? "",
                                                  "Status": "R"
                                                };
                                                print(approveData);
                                                approve(false, false,
                                                    approveData, context);
                                              },
                                              child: const Text(
                                                  "    Reject    ",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            )
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
                            itemCount: timesheetList.isNotEmpty
                                ? timesheetList.length
                                : 0),
                  ),
                )),
    );
  }

  _selectInTime(String inDate) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      setState(() {
        var inTime = formatTimeOfDay(pickedTime);
        inTimeController.text = inTime;
        popupinputDate = inDate + " " + inTime;
        print(popupinputDate);
        _intimeClicked = true;
      });
    }
  }

  _selectOutTime(String outDate) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      setState(() {
        var outTime = formatTimeOfDay(pickedTime);
        outTimeController.text = outTime;
        popupoutputDate = outDate + " " + outTime;
        print(popupoutputDate);

        _outimeClicked = true;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jms(); //"6:00 AM"
    return format.format(dt);
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

  howDataAlert(TimesheetDetail sheetdata, String inDate, String outDate) {
    var inputFormat = DateFormat('dd-MM-yyyy,HH:mm:ss');
    var date1 = inputFormat.parse(inDate);
    var date2 = inputFormat.parse(outDate);
    var dateFormat = DateFormat('yyyy-MM-dd');
    var timeForamat = DateFormat('HH:mm:ss');
    popupinputDate = dateFormat.format(date1);
    popupoutputDate = dateFormat.format(date2);
    inTimeController.text = timeForamat.format(date1);
    outTimeController.text = timeForamat.format(date2);
    _intimeClicked = false;
    _outimeClicked = false;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.only(
                top: 10.0,
              ),
              title: const Text(
                "Time Sheet",
                style: TextStyle(fontSize: 24.0, color: Color(0xFFaa0e3f)),
              ),
              content: Container(
                width: 380,
                height: 280,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Enter Your Time",
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            _selectInTime(popupinputDate);
                          },
                          child: TextFormField(
                            enabled: false,
                            controller: inTimeController,
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'InTime'),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            _selectOutTime(popupoutputDate);
                          },
                          child: TextFormField(
                            enabled: false,
                            controller: outTimeController,
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Outtime'),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                String inDate = "";
                                String outDate = "";
                                var inputFormat =
                                    DateFormat('yyyy-MM-dd HH:mm:ss a');
                                var outputFormat =
                                    DateFormat('yyyy-MM-dd HH:mm:ss');

                                if (_intimeClicked || _outimeClicked) {
                                  if (_intimeClicked && _outimeClicked) {
                                    var date1 =
                                        inputFormat.parse(popupinputDate);
                                    inDate = outputFormat.format(date1);
                                    var date2 =
                                        inputFormat.parse(popupoutputDate);
                                    outDate = outputFormat.format(date2);
                                  } else if (_intimeClicked &&
                                      _outimeClicked == false) {
                                    var date1 =
                                        inputFormat.parse(popupinputDate);
                                    inDate = outputFormat.format(date1);
                                    outDate = sheetdata.outTime ?? "";
                                  } else if (_intimeClicked == false &&
                                      _outimeClicked) {
                                    inDate = sheetdata.inTime ?? "";
                                    var date2 =
                                        inputFormat.parse(popupoutputDate);
                                    outDate = outputFormat.format(date2);
                                  }

                                  Map approveData = {
                                    "AttendID": sheetdata.attendID,
                                    "EmpID": sheetdata.empID,
                                    "AttendInTime": inDate,
                                    "AttendOutTime": outDate,
                                    "SlNo": sheetdata.slNo,
                                    "Mile": sheetdata.mile ?? "",
                                    "Status": "A"
                                  };
                                  print(approveData);
                                  approve(true, true, approveData, context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: const Text("Approve",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                String inDate = "";
                                String outDate = "";
                                var inputFormat =
                                    DateFormat('yyyy-MM-dd HH:mm:ss a');
                                var outputFormat =
                                    DateFormat('yyyy-MM-dd HH:mm:ss');

                                if (_intimeClicked || _outimeClicked) {
                                  if (_intimeClicked && _outimeClicked) {
                                    var date1 =
                                        inputFormat.parse(popupinputDate);
                                    inDate = outputFormat.format(date1);
                                    var date2 =
                                        inputFormat.parse(popupoutputDate);
                                    outDate = outputFormat.format(date2);
                                  } else if (_intimeClicked &&
                                      _outimeClicked == false) {
                                    var date1 =
                                        inputFormat.parse(popupinputDate);
                                    inDate = outputFormat.format(date1);
                                    outDate = sheetdata.outTime ?? "";
                                  } else if (_intimeClicked == false &&
                                      _outimeClicked) {
                                    inDate = sheetdata.inTime ?? "";
                                    var date2 =
                                        inputFormat.parse(popupoutputDate);
                                    outDate = outputFormat.format(date2);
                                  }

                                  Map approveData = {
                                    "AttendID": sheetdata.attendID,
                                    "EmpID": sheetdata.empID,
                                    "AttendInTime": inDate,
                                    "AttendOutTime": outDate,
                                    "SlNo": sheetdata.slNo,
                                    "Mile": sheetdata.mile ?? "",
                                    "Status": "R"
                                  };
                                  print(approveData);
                                  approve(true, false, approveData, context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              child: const Text("Reject",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }));
        });
  }

  //API

  approve(bool isPopup, bool isApprove, Map attendanceData,
      BuildContext context) async {
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
                String status = "A";
                if (isApprove == false) {
                  status = "R";
                }

                String query =
                    '${widget.attendanceID}/${status}/${point['UserID']}/1/${accessPoint}';
                String url = Constants.base_url + 'Attendance/Approve/' + query;

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
                print(response.body);
                if (response.statusCode == 200) {
                  Map parsed = json.decode(response.body);
                  if (isPopup) {
                    Navigator.pop(context);
                  }
                  _showToast("Updated successfully");
                  mySheets();
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

  mySheets() async {
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

                String query = '/${widget.attendanceID}/1/${accessPoint}';
                String url = Constants.base_url + 'AttendanceTail' + query;

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
                      timesheetList = data
                          .map((job) => TimesheetDetail.fromJson(job))
                          .toList();
                      _nodata = false;
                      if (timesheetList.isEmpty) {
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
