import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'dart:convert';
import '../../Employee/model.dart';
import '../../Utilities/shared_preference_util.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Leaveapply extends StatefulWidget {
  const Leaveapply({super.key});

  @override
  State<Leaveapply> createState() => _LeaveapplyState();
}

class _LeaveapplyState extends State<Leaveapply> {
  bool _isLoading = false;
  bool _isapply = false;
  bool _numberLoading = false;
  List<Leavemaster> leave = [];
  List<NoLeaves> numberLeves = [];

  Leavemaster? _selectedLeave;
  String? _selectedleaveType;
  final _fromControler = TextEditingController();
  final _toControler = TextEditingController();
  final _reasonControler = TextEditingController();
  final _noleavesControler = TextEditingController();

  List<String> leaveTypres = [
    'Full Day',
    'Half Day',
  ];
  @override
  void initState() {
    leave = [];
    _isLoading = true;
    leavemaster();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave"),
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
              child: Container(
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
                                value: _selectedLeave,
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
                                    hintText: 'Select Leave'),
                                items: leave.map<DropdownMenuItem<Leavemaster>>(
                                    (Leavemaster value) {
                                  return DropdownMenuItem<Leavemaster>(
                                    value: value,
                                    child: Text(
                                      value.name ?? "",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedLeave = val as Leavemaster;
                                  });
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            DropdownButtonFormField(
                                value: _selectedleaveType,
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
                                    hintStyle: const TextStyle(
                                        color: Color(0xff123456)),
                                    filled: true,
                                    fillColor: Colors.grey.shade200,
                                    hintText: 'Select Leave Type'),
                                items: leaveTypres
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedleaveType = val as String;
                                  });
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: this._fromControler,
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
                                  hintText: 'From'),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: this._toControler,
                              maxLength: 50,
                              keyboardType: TextInputType.name,
                              onTap: _selecttoDate,
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
                                  hintText: 'To'),
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
                                    controller: _noleavesControler,
                                    maxLength: 50,
                                    keyboardType: TextInputType.name,
                                    readOnly: true,
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
                                        hintText: 'No of Leaves'),
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
                                    if (_selectedLeave == null) {
                                      _showToast('Please select a leave');
                                    } else if (_selectedleaveType == null) {
                                      _showToast('Please select a leave type');
                                    } else if (_fromControler.text.isEmpty) {
                                      _showToast('Please select a From date');
                                    } else if (_toControler.text.isEmpty) {
                                      _showToast('Please select a To date');
                                    } else if (_noleavesControler
                                            .text.isEmpty ||
                                        _noleavesControler.text == "0.0") {
                                      _showToast(
                                          'Number of leaves must be grater than zero');
                                    } else if (_reasonControler.text.isEmpty) {
                                      _showToast('Please enter a reson');
                                    } else {
                                      Future<String> loginData =
                                          Preference.getStringItem(
                                              Constants.login_data);
                                      loginData.then((data) async {
                                        if (data.isNotEmpty) {
                                          Map point = json.decode(data);
                                          String leaveType = "1";

                                          if (_selectedleaveType !=
                                              "Full Day") {
                                            leaveType = "2";
                                          }
                                          if (_selectedLeave != null) {
                                            int leaveT =
                                                _selectedLeave?.value ?? 0;
                                            var inputFormat =
                                                DateFormat('dd/MM/yyyy');
                                            var date1 = inputFormat
                                                .parse(_toControler.text);
                                            var date2 = inputFormat
                                                .parse(_fromControler.text);
                                            var outputFormat =
                                                DateFormat('yyyy-MM-dd');
                                            String toDate =
                                                outputFormat.format(date1);
                                            String fromDate =
                                                outputFormat.format(date2);

                                            Map innerData = {
                                              "CompanyID": point["CompanyID"],
                                              "LeaveID": leaveT.toString(),
                                              "EmpID": point['EmpID'],
                                              "LeaveType": leaveType,
                                              "FromDate": fromDate,
                                              "ToDate": toDate,
                                              "NoOfLeaves":
                                                  _noleavesControler.text,
                                              "ApprovalStatus": "N",
                                              "Reason": _reasonControler.text
                                            };
                                            print(innerData);
                                            Map main = {"Head": innerData};

                                            applyLeave(main, context);
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
      _fromControler.text = DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  _selecttoDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      dateTime = picked;
      //assign the chosen date to the controller
      _toControler.text = DateFormat('dd/MM/yyyy').format(dateTime);
      if (_fromControler.text.isNotEmpty && _toControler.text.isNotEmpty) {
        Future<String> loginData =
            Preference.getStringItem(Constants.login_data);
        loginData.then((data) async {
          if (data.isNotEmpty) {
            Map point = json.decode(data);
            String leaveType = "1";

            if (_selectedleaveType != "Full Day") {
              leaveType = "2";
            }
            if (_selectedLeave != null) {
              int leaveT = _selectedLeave?.value ?? 0;
              var inputFormat = DateFormat('dd/MM/yy');
              var date1 = inputFormat.parse(_toControler.text);
              var date2 = inputFormat.parse(_fromControler.text);
              var outputFormat = DateFormat('yyyy-MM-dd');
              String toDate = outputFormat.format(date1);
              String fromDate = outputFormat.format(date2);

              Map innerData = {
                "CompanyID": "",
                "LeaveID": leaveT.toString(),
                "EmpID": point['EmpID'],
                "LeaveType": leaveType,
                "FromDate": fromDate,
                "ToDate": toDate,
                "NoOfLeaves": "",
                "ApprovalStatus": "",
                "Reason": ""
              };
              print(innerData);
              Map main = {"Head": innerData};

              numberofLeaves(main);
            }
          } else {}
        }, onError: (e) {});
      }
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

  applyLeave(Map leaveData, BuildContext context) async {
    print(leaveData);
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
                String url =
                    Constants.base_url + 'LeaveApplication/Save' + query;

                var uri = Uri.parse(url);
                print(uri);
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
                  _showToast("Leave application successfully applied");
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

  numberofLeaves(Map leaveDetails) async {
    String accessPoint = "";
    Utils.checkInternetConnection().then((connectionResult) async {
      if (connectionResult) {
        setState(() {
          _numberLoading = true;
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

                String query = '/1/${accessPoint}';
                String url = Constants.base_url +
                    'LeaveApplication/LeaveCalculation' +
                    query;

                var uri = Uri.parse(url);
                var body = jsonEncode(leaveDetails);
                final response = await http.post(uri,
                    headers: <String, String>{
                      'Content-Type': "application/json",
                    },
                    body: body);
                setState(() {
                  _numberLoading = false;
                });

                if (response.statusCode == 200) {
                  Map parsed = json.decode(response.body);
                  if (parsed != null) {
                    setState(() {
                      List types = parsed['value'];
                      numberLeves =
                          types.map((job) => NoLeaves.fromJson(job)).toList();
                      if (numberLeves.isNotEmpty && numberLeves[0] != null) {
                        _noleavesControler.text =
                            numberLeves[0].noOfLeaves.toString();
                        if (numberLeves[0].noOfLeaves == 0.0) {
                          _showToast(numberLeves[0].eRRORMESSAGE ?? "");
                        }
                      }
                    });
                  }
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
  leavemaster() async {
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
                    '/${point['EmpID']}/${accessPoint}/1/leavemaster';
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
                    leave =
                        types.map((job) => Leavemaster.fromJson(job)).toList();
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
