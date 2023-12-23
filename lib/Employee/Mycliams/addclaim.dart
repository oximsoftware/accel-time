import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'dart:convert';
import '../../Employee/model.dart';
import '../../Utilities/shared_preference_util.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddClaim extends StatefulWidget {
  String TrainingID = "0";
  AddClaim({super.key, required this.TrainingID});

  @override
  State<AddClaim> createState() => _AddClaimState();
}

class _AddClaimState extends State<AddClaim> {
  bool _isLoading = false;
  bool _numberLoading = false;
  List<Claimmaster> claim = [];
  Claimmaster? _selectedClaim;
  bool _isapply = false;

  final _dateControler = TextEditingController();
  final _amoutControler = TextEditingController();
  final _reasonControler = TextEditingController();
  final _noControler = TextEditingController();

  @override
  void initState() {
    claim = [];
    _isLoading = true;
    claimmaster();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Claim"),
      ),
      backgroundColor: Colors.grey.withOpacity(1.0),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : LoadingOverlay(
              isLoading: _isapply,
              opacity: 0.0,
              progressIndicator: CircularProgressIndicator(
                color: Colors.red,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Column(children: [
                            DropdownButtonFormField(
                                value: _selectedClaim,
                                iconEnabledColor: Colors.red,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.add_location,
                                      color: Colors.red,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(90.0)),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintStyle:
                                        TextStyle(color: Color(0xff123456)),
                                    filled: true,
                                    fillColor: Colors.grey.shade200,
                                    hintText: 'Select Claim'),
                                items: claim.map<DropdownMenuItem<Claimmaster>>(
                                    (Claimmaster value) {
                                  return DropdownMenuItem<Claimmaster>(
                                    value: value,
                                    child: Text(
                                      value.name ?? "",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedClaim = val as Claimmaster;
                                  });
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: this._dateControler,
                              maxLength: 50,
                              keyboardType: TextInputType.name,
                              onTap: _selectDate,
                              readOnly: true,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.calendar_month,
                                    color: Colors.red,
                                  ),
                                  border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none,
                                    //borderSide: const BorderSide(),
                                  ),
                                  hintStyle:
                                      TextStyle(color: Color(0xff123456)),
                                  filled: true,
                                  fillColor: Colors.grey.shade300,
                                  counterText: "",
                                  hintText: 'Claim date'),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: this._noControler,
                              maxLength: 50,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.calendar_month,
                                    color: Colors.red,
                                  ),
                                  border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none,
                                    //borderSide: const BorderSide(),
                                  ),
                                  hintStyle:
                                      TextStyle(color: Color(0xff123456)),
                                  filled: true,
                                  fillColor: Colors.grey.shade300,
                                  counterText: "",
                                  hintText: 'Claim Number'),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            _numberLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                    ),
                                  )
                                : TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: _amoutControler,
                                    maxLength: 50,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.select_all,
                                          color: Colors.red,
                                        ),
                                        border: OutlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(90.0)),
                                          borderSide: BorderSide.none,
                                          //borderSide: const BorderSide(),
                                        ),
                                        hintStyle:
                                            TextStyle(color: Color(0xff123456)),
                                        filled: true,
                                        fillColor: Colors.grey.shade300,
                                        counterText: "",
                                        hintText: 'Amout'),
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _reasonControler,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.select_all,
                                    color: Colors.red,
                                  ),
                                  border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none,
                                    //borderSide: const BorderSide(),
                                  ),
                                  hintStyle:
                                      TextStyle(color: Color(0xff123456)),
                                  filled: true,
                                  fillColor: Colors.grey.shade300,
                                  counterText: "",
                                  hintText: 'Reason'),
                            )
                          ])),
                    )),
                    Positioned(
                        bottom: 0,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 130,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    )),
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextButton(
                                  child: Text(
                                    "Apply",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    if (_selectedClaim == null) {
                                      _showToast('Please select a claim');
                                    } else if (_dateControler.text.isEmpty) {
                                      _showToast('Please enter a claim date');
                                    } else if (_noControler.text.isEmpty) {
                                      _showToast('Please enter a claim number');
                                    } else if (_amoutControler.text.isEmpty) {
                                      _showToast('Please enter a claim amout');
                                    } else if (_reasonControler.text.isEmpty) {
                                      _showToast('Please enter a reson');
                                    } else {
                                      Future<String> loginData =
                                          Preference.getStringItem(
                                              Constants.login_data);
                                      loginData.then((data) async {
                                        if (data.isNotEmpty) {
                                          Map point = json.decode(data);

                                          if (_selectedClaim != null) {
                                            int claimT =
                                                _selectedClaim?.value ?? 0;
                                            String claimN =
                                                _selectedClaim?.name ?? "";
                                            var inputFormat =
                                                DateFormat('MM/dd/yyyy');
                                            var date1 = inputFormat
                                                .parse(_dateControler.text);

                                            var outputFormat =
                                                DateFormat('yyyy-MM-dd');
                                            String claimDate =
                                                outputFormat.format(date1);

                                            Map headData = {
                                              "CompanyID": point["CompanyID"],
                                              "EmpID": point['EmpID'],
                                              "ClaimDate": claimDate,
                                              "ClaimNumber": _noControler.text,
                                              "ApprovalStatus": "N",
                                              "TrainingID": widget.TrainingID
                                            };

                                            Map tailData = {
                                              "ClaimID": claimT.toString(),
                                              "Claim": claimN,
                                              "Amount": _amoutControler.text,
                                              "Reason": _reasonControler.text,
                                              "Status": "0"
                                            };
                                            List<dynamic> tail = [];
                                            tail.add(tailData);

                                            Map main = {
                                              "Head": headData,
                                              "Tail": tail
                                            };
                                            print(main);
                                            applyClaim(main, context);
                                          }
                                        } else {}
                                      }, onError: (e) {});
                                    }
                                  },
                                ),
                              ),
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                  bottomLeft: Radius.zero,
                                  bottomRight: Radius.zero),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, -2),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  color: Colors.grey,
                                ),
                              ],
                            )))
                  ],
                ),
              ),
            ),
    );
  }

//Apis

  DateTime dateTime = DateTime.now();

  _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      dateTime = picked;
      //assign the chosen date to the controller
      _dateControler.text = DateFormat.yMd().format(dateTime);
    }
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

//Number of leaves

  applyClaim(Map leaveData, BuildContext context) async {
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
                var body = jsonEncode(leaveData);
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
                  _showToast("Claim added successfully applied");
                  Navigator.pop(context);
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

  //API
  claimmaster() async {
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
                    '/1/${accessPoint}/${point['EmpID']}/claimmaster';
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
                    List types = parsed['value'];
                    claim =
                        types.map((job) => Claimmaster.fromJson(job)).toList();
                  });
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
}
