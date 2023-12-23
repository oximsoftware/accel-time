import 'dart:convert';

import 'package:acceltime/Employee/model.dart';
import 'package:http/http.dart' as http;
import 'package:acceltime/Utilities/Utils.dart';
import 'package:flutter/material.dart';

import '../Utilities/shared_preference_util.dart';
import '../constants/constants.dart';

class EmployeeTerms extends StatefulWidget {
  const EmployeeTerms({super.key});

  @override
  State<EmployeeTerms> createState() => _EmployeeTermsState();
}

class _EmployeeTermsState extends State<EmployeeTerms> {
  bool _isLoading = false;
  bool _nodata = false;
  List<Tail> tails = [];
  List<Head> headers = [];
  bool ishowDeppartment = true;
  @override
  void initState() {
    terms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Terms"),
      ),
      backgroundColor: Colors.grey.withOpacity(1.0),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${headers[0].amount}",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      radius: 50,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "${headers[0].designation}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Visibility(
                                      visible: headers[0].department!.isNotEmpty
                                          ? true
                                          : false,
                                      child: Text(
                                          "Department: ${headers[0].department}")),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("As on Date: ${headers[0].date}"),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: _nodata
                          ? const Center(child: Text("No Terms found"))
                          : ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.currency_exchange),
                                  ),
                                  title: Text("${tails[index].allowance}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text("Type: ${tails[index].type}"),
                                  trailing: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("Rate"),
                                      Text("${tails[index].amount}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  color: Colors.white,
                                );
                              },
                              itemCount: tails.length),
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
  terms() async {
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
                String url = Constants.base_url + 'EmployeeTerms' + query;

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
                      Map data = parsed['value'];

                      if (data["Head"] != null && data["Tail"] != null) {
                        List headerData = data["Head"];
                        List tailData = data["Tail"];
                        headers = headerData
                            .map((job) => Head.fromJson(job))
                            .toList();
                        tails =
                            tailData.map((job) => Tail.fromJson(job)).toList();
                        _nodata = false;
                        if (tails.isEmpty) {
                          _nodata = true;
                        }
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
