import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/Utilities/shared_preference_util.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:acceltime/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Activatepage extends StatefulWidget {
  const Activatepage({super.key});

  @override
  State<Activatepage> createState() => _ActivatepageState();
}

class _ActivatepageState extends State<Activatepage> {
  final _codefieldControler = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ui(),
    );
  }

  Widget ui() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _codefieldControler,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                hintText: "Agency code",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  )
                : Container(
                    width: 300,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                        onPressed: () {
                          checkActivation();
                        },
                        child: const Text(
                          "Activate",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  )
          ],
        ),
      ),
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assests/images/splash.png'),
        fit: BoxFit.cover,
      )),
    );
  }

  checkActivation() async {
    if (_codefieldControler.text.isEmpty) {
      _showToast("Please enter your Agecy code");
    } else {
      Utils.checkInternetConnection().then((connectionResult) async {
        if (connectionResult) {
          setState(() {
            _isLoading = true;
          });

          String query = '/${_codefieldControler.text}/1';
          String url = Constants.base_url + 'GetaccessPoint' + query;

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
              List data = parsed['value'];
              if (data.isNotEmpty &&
                  data[0]['AgencyID'] != null &&
                  data[0]['AccessPoint'] != null) {
                Map mapData = data[0];
                Preference.setStringItem(
                    Constants.activation_data, json.encode(mapData));

                setState(() {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const Login()));
                });
              }
            }
          } else {
            _showToast("Host Unreachable, try again later");
          }
        } else {
          _showToast("No internet connection available");
        }
      });
    }
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
}
