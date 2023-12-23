import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/Utilities/shared_preference_util.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:acceltime/Employee/model.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ClientLocations extends StatefulWidget {
  const ClientLocations({super.key});

  @override
  State<ClientLocations> createState() => _ClientLocationsState();
}

class _ClientLocationsState extends State<ClientLocations> {
  List<Location> timesheetList = [];
  bool _isLoading = false;
  bool _nodata = false;
  bool _isapply = false;
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
      progressIndicator: CircularProgressIndicator(
        color: Colors.red,
      ),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Locations"),
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
                        ? const Center(child: Text("No Locations found"))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {},
                                child: Card(
                                  color: Colors.white.withOpacity(0.9),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(3, 15, 3, 15),
                                    child: ListTile(
                                      leading: const CircleAvatar(
                                        backgroundColor: Colors.red,
                                        child: Icon(
                                          Icons.location_city,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                          timesheetList[index].locationName ??
                                              "",
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
                                          Text(
                                              "Address: ${timesheetList[index].address ?? ""} "),
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
                            itemCount: timesheetList.isNotEmpty
                                ? timesheetList.length
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

  approve(Map attendanceData, BuildContext context) async {
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

                String query = '/0/${point['EmpID']}/1/${accessPoint}';
                String url = Constants.base_url + 'ClaimForm/Save/' + query;

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
                  _showToast("Attendance approved successfully ");
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

                String query = '/${point['ClientID']}/1/${accessPoint}';
                String url = Constants.base_url + 'ClientLocation' + query;

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
                      timesheetList =
                          data.map((job) => Location.fromJson(job)).toList();
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
