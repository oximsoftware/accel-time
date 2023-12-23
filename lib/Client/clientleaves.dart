import 'dart:convert';
import 'package:acceltime/Employee/model.dart';
import 'package:http/http.dart' as http;
import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/Utilities/shared_preference_util.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:flutter/material.dart';

class Clientleaves extends StatefulWidget {
  const Clientleaves({super.key});

  @override
  State<Clientleaves> createState() => _ClientleavesState();
}

class _ClientleavesState extends State<Clientleaves> {
  List<ClientLeaves> leaveList = [];
  bool _isLoading = false;
  bool _nodata = false;
  @override
  void initState() {
    myLeaves();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Leaves"),
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
                      ? const Center(child: Text("No Leave found"))
                      : ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            String type = "F";
                            if (leaveList[index].leaveType == "Full Day") {
                              type = "F";
                            } else if (leaveList[index].leaveType ==
                                "Half Day") {
                              type = "H";
                            }

                            return Card(
                              color: Colors.white.withOpacity(0.9),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(3, 15, 3, 15),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Text(type,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(leaveList[index].employeeName ?? "",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'Type: ${leaveList[index].leaveName ?? ""}',
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    ),
                                                    color: Colors.blueGrey),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          leaveList[index]
                                                                  .fromDate ??
                                                              "",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          const Text("-"),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    ),
                                                    color: Colors.blueGrey),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          leaveList[index]
                                                                  .toDate ??
                                                              "",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                          "Status: ${leaveList[index].status ?? ""} "),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(leaveList[index].noOfLeaves ?? "",
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      const Text("Days")
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
                          itemCount: leaveList.length),
                ),
              ));
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
  myLeaves() async {
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

                String query =
                    '/1/${accessPoint}/${point['UserID']}/clientemployeeleaves';
                String url = Constants.base_url + 'GetGeneralData' + query;

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
                    leaveList =
                        data.map((job) => ClientLeaves.fromJson(job)).toList();
                    _nodata = false;
                    if (leaveList.isEmpty) {
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
