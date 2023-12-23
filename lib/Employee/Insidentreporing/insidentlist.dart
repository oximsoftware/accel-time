import 'dart:convert';
import 'package:acceltime/Employee/Insidentreporing/incidentpost.dart';
import 'package:acceltime/Employee/Mycliams/addclaim.dart';
import 'package:acceltime/Employee/Mycliams/claimdetails.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:http/http.dart' as http;
import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/Utilities/shared_preference_util.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:acceltime/Employee/model.dart';

class InsidentList extends StatefulWidget {
  const InsidentList({super.key});

  @override
  State<InsidentList> createState() => _InsidentListState();
}

class _InsidentListState extends State<InsidentList> {
  List<Incidents> claimList = [];
  bool _isLoading = false;
  bool _nodata = false;
  @override
  void initState() {
    // myClaims();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        print("View will appear");
        myInsidents();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("My Incidents"),
          ),
          backgroundColor: Colors.grey.withOpacity(1.0),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Incidentpost()));
            },
          ),
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
                        ? const Center(child: Text("No Incidents found"))
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
                                      trailing: Column(
                                        children: [
                                          Text(
                                            "Location",
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(claimList[index].location ?? "",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))
                                        ],
                                      ),
                                      title: Text(claimList[index].client ?? "",
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
                                              "Shift: ${claimList[index].shift ?? ""} "),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              "Time: ${claimList[index].fromTime ?? ""} - ${claimList[index].toTime ?? ""}  "),
                                          const SizedBox(
                                            height: 10,
                                          )
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
                            itemCount:
                                claimList.isNotEmpty ? claimList.length : 0),
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
  myInsidents() async {
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
                String url = Constants.base_url + 'IncidentList' + query;

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
                      claimList =
                          data.map((job) => Incidents.fromJson(job)).toList();
                      _nodata = false;
                      if (claimList.isEmpty) {
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
