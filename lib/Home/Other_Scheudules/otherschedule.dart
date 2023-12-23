import 'dart:convert';
import 'package:focus_detector/focus_detector.dart';
import 'package:http/http.dart' as http;
import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/Utilities/shared_preference_util.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:acceltime/Employee/model.dart';
import 'package:intl/intl.dart';

class Otherschedules extends StatefulWidget {
  const Otherschedules({super.key});

  @override
  State<Otherschedules> createState() => _OtherschedulesState();
}

class _OtherschedulesState extends State<Otherschedules> {
  List<ScheduleModel> scheduleList = [];
  bool _isLoading = false;
  bool _nodata = false;
  @override
  void initState() {
    mySchedules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {},
      child: Scaffold(
          appBar: AppBar(
            title: const Text("More Schedules"),
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
                        ? const Center(child: Text("No more schedules found"))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              String clientLocation = "";
                              String scheduledTime = "";
                              String first = scheduleList[0].client ?? "";
                              String second = scheduleList[0].location ?? "";

                              clientLocation = first + "," + second;
                              String one = scheduleList[0].shiftFromTime ?? "";
                              String two = scheduleList[0].shiftToTime ?? "";

                              scheduledTime = one + " - " + two;

                              final DateFormat format1 = DateFormat('MMM');
                              final DateFormat format2 = DateFormat('dd');
                              DateTime brazilianDate = DateFormat("dd/MM/yyyy")
                                  .parse(
                                      scheduleList[index].scheduleDate ?? "");

                              String month = format1.format(brazilianDate);
                              String day = format2.format(brazilianDate);

                              return InkWell(
                                onTap: () {},
                                child: Card(
                                  color: Colors.white.withOpacity(0.9),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 15, 3, 15),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.red,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(month,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(day,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                      title: Text(scheduledTime,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 3),
                                          Text(clientLocation,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
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
                            itemCount: scheduleList.isNotEmpty
                                ? scheduleList.length
                                : 0),
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
  mySchedules() async {
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
                    Constants.base_url + 'EmployeeOtherSchedule' + query;

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

                  setState(() {
                    List data = parsed['value'];
                    scheduleList =
                        data.map((job) => ScheduleModel.fromJson(job)).toList();
                    _nodata = false;
                    if (scheduleList.isEmpty) {
                      _nodata = true;
                    }
                  });
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
