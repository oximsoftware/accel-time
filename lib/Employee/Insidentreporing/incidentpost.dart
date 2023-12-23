import 'package:acceltime/Utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../../Utilities/shared_preference_util.dart';
import '../../constants/constants.dart';
import '../model.dart';

class Incidentpost extends StatefulWidget {
  const Incidentpost({super.key});

  @override
  State<Incidentpost> createState() => _IncidentpostState();
}

class _IncidentpostState extends State<Incidentpost> {
  File? imageFile;
  bool _isLoading = false;
  List<ScheduleModel> schelueList = [];
  final _remarkfieldControler = TextEditingController();
  @override
  void initState() {
    myschedules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Incident"),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                child: Column(
                  children: [
                    TextField(
                      controller: _remarkfieldControler,

                      keyboardType: TextInputType.multiline,
                      minLines: 1, //Normal textInputField will be displayed
                      maxLines: 5,
                      decoration: new InputDecoration(
                          prefixIcon:
                              new Icon(Icons.info, color: Color(0xff123456)),
                          hintText: "Remarks",
                          hintStyle: new TextStyle(color: Color(0xff123456))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          _settingModalBottomSheet(context);
                        },
                        child: Row(
                          children: [
                            const Text('Add Image',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16)),
                            Spacer(),
                            Icon(Icons.add_a_photo)
                          ],
                        ),
                      ),
                    ),
                    root(),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                          onPressed: () {
                            saveIncident(imageFile!);
                          },
                          child: Text('Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))),
                    )
                  ],
                ),
              ));
  }

  Widget root() {
    return Container(
      child: imageFile != null
          ? Image.file(
              imageFile!,
              height: MediaQuery.of(context).size.height / 3,
            )
          : Container(),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.music_note),
                    title: new Text('Pick Image from Gallery'),
                    onTap: () => {pickImage()}),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Pick Image from Camera'),
                  onTap: () => {pickImageC()},
                ),
              ],
            ),
          );
        });
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.imageFile = imageTemp);
      // ignore: nullable_type_in_catch_clause
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.imageFile = imageTemp);
      // ignore: nullable_type_in_catch_clause
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
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

  myschedules() async {
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
                    Constants.base_url + 'EmployeeTodaySchedule' + query;

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
                      schelueList = data
                          .map((job) => ScheduleModel.fromJson(job))
                          .toList();

                      if (schelueList.isEmpty) {
                      } else {}
                    });
                  }
                } else {
                  _showToast("Host Unreachable, try again later");
                  //_nodata = false;
                }
              } else {}
            }, onError: (e) {});
          }
        }, onError: (e) {});
      } else {
        _showToast("No internet connection available");
        //_nodata = true;
      }
    });
  }

  void saveIncident(File image) async {
    if (_remarkfieldControler.text.isEmpty) {
      _showToast("Please enter a remark");
    } else {
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
                  var today = DateTime.now();
                  String todayString = DateFormat('MM/dd/yyyy').format(today);
                  print(todayString);

                  String query =
                      '/0/${point['UserID']}/${point['EmpID']}/1/${accessPoint}?ResourceScheduleID=${schelueList[0].resourceScheduleID}&CompanyID=${point['CompanyID']}&ClientID=${schelueList[0].clientID}&LocationID=${schelueList[0].locationID}&DepartID=${schelueList[0].departID}&ShiftID=${schelueList[0].shiftID}&DesigID=${schelueList[0].desigID}&EmpID=${point['EmpID']}&Remarks=${_remarkfieldControler.text}&Date=${todayString}';
                  String url = Constants.base_url +
                      'IncidentPosting/SaveIncidentPosting' +
                      query;
                  var uri = Uri.parse(url);

                  var request = http.MultipartRequest('POST', uri);
                  if (image != null) {
                    request.files.add(http.MultipartFile('file',
                        image.readAsBytes().asStream(), image.lengthSync(),
                        filename: image.path.split("/").last));
                  }

                  var headers = <String, String>{
                    'Content-Type': 'application/json',
                  };

                  request.headers.addAll(headers);

                  setState(() {
                    _isLoading = false;
                  });
                  var response = await request.send();
                  response.stream.transform(utf8.decoder).listen((value) {
                    print('Result body: ' + value);
                  });
                  print(response);

                  if (response.statusCode == 200) {
                    _showToast("Incident added successfully applied");
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
  }
}
