import 'dart:convert';
import 'package:acceltime/Employee/Mycliams/addclaim.dart';
import 'package:acceltime/Employee/Mycliams/claimdetails.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:http/http.dart' as http;
import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/Utilities/shared_preference_util.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:acceltime/Employee/model.dart';

class Myclaims extends StatefulWidget {
  const Myclaims({super.key});

  @override
  State<Myclaims> createState() => _MyclaimsState();
}

class _MyclaimsState extends State<Myclaims> {
  List<Myclaimmodel> claimList = [];
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
        myClaims();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("My Claims"),
          ),
          backgroundColor: Colors.grey.withOpacity(1.0),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddClaim(
                            TrainingID: "0",
                          )));
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
                        ? const Center(child: Text("No Claims found"))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Myclaimsdetail(
                                              claimID: claimList[index]
                                                  .claimFormID)));
                                },
                                child: Card(
                                  color: Colors.white.withOpacity(0.9),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(3, 15, 3, 15),
                                    child: ListTile(
                                      trailing: Column(
                                        children: [
                                          Text(
                                            "Amount",
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(claimList[index].amount ?? "",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18))
                                        ],
                                      ),
                                      title: Text(
                                          claimList[index].claimDate ?? "",
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
                                              "Status: ${claimList[index].status ?? ""} "),
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
  myClaims() async {
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
                String url = Constants.base_url + 'EmployeeClaim' + query;

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
                      claimList = data
                          .map((job) => Myclaimmodel.fromJson(job))
                          .toList();
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
