import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:acceltime/Employee/model.dart';
import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/Utilities/shared_preference_util.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:flutter/material.dart';

class Leavebalance extends StatefulWidget {
  const Leavebalance({super.key});

  @override
  State<Leavebalance> createState() => _LeavebalanceState();
}

class _LeavebalanceState extends State<Leavebalance> {
  bool _isLoading = false;
  bool _nodata = false;
  List<LeaveBalances> balanceList = [];

  @override
  void initState() {
    myLeavebalances();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave Balance"),
      ),
      backgroundColor: Colors.grey.withOpacity(1.0),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                child: _nodata
                    ? const Center(child: Text("No Leave balance found"))
                    : ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.white.withOpacity(0.9),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(3, 15, 3, 15),
                              child: ListTile(
                                title: Text("${balanceList[index].leaves}",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        "Opening: ${balanceList[index].opening}"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              color: Colors.grey.shade300),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Credit: "),
                                                Text(
                                                    "${balanceList[index].credit}")
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              color: Colors.grey.shade300),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Availed: "),
                                                Text(
                                                    "${balanceList[index].availed}")
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Balances"),
                                    Text("${balanceList[index].balance}",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.transparent,
                          );
                        },
                        itemCount: balanceList.length),
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
  myLeavebalances() async {
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
                    Constants.base_url + 'EmployeeLeavebalance' + query;

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
                      balanceList = data
                          .map((job) => LeaveBalances.fromJson(job))
                          .toList();
                      _nodata = false;
                      if (balanceList.isEmpty) {
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
