import 'package:acceltime/Home/home.dart';
import 'package:acceltime/Utilities/Utils.dart';
import 'package:acceltime/Utilities/shared_preference_util.dart';
import 'package:acceltime/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Home/menu.dart';
import 'Notifications/notifications.dart';
import 'Profile/profile.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _check = false;
  final _emailfieldControler = TextEditingController();
  final _passwordfieldControler = TextEditingController();
  bool _isLoading = false;
  bool _isSecure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade200,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.23,
              ),
              Container(
                width: MediaQuery.of(context).size.height * 0.3,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Image.asset(
                  'assests/images/logo.png',
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2))
                      ]),
                  child: Center(
                    child: TextField(
                      controller: _emailfieldControler,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: "User ID",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        const BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2))
                      ]),
                  child: Center(
                    child: TextField(
                      controller: _passwordfieldControler,
                      obscureText: _isSecure,
                      decoration: InputDecoration(
                          hintText: "Password",
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: GestureDetector(
                            child: _isSecure
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onTap: () {
                              setState(() {
                                _isSecure = !_isSecure;
                              });
                            },
                          )),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _check = !_check;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                          value: _check,
                          onChanged: (value) {
                            setState(() {
                              if (value != null) {
                                _check = value;
                              }
                            });
                          }),
                      const Text("Remember me")
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    )
                  : Container(
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                          onPressed: () {
                            if (_emailfieldControler.text.isEmpty) {
                              _showToast("Enter valid email");
                            } else if (_passwordfieldControler.text.isEmpty) {
                              _showToast("Enter valid password");
                            } else {
                              checkLogin();
                            }
                          },
                          child: const Text(
                            "Sign",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
              const SizedBox(
                height: 15,
              ),
              TextButton(onPressed: () {}, child: const Text("Forgot Password"))
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
  checkLogin() async {
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

            String query =
                '/${point['AgencyID']}/${_emailfieldControler.text}/${_passwordfieldControler.text}/1/${point['AccessPoint']}';
            String url = Constants.base_url + 'Login' + query;

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

                if (data.isNotEmpty) {
                  Map mapData = data[0];
                  Preference.setStringItem(
                      Constants.login_data, json.encode(mapData));
                  Preference.setStringItem(
                      Constants.roleType, mapData["RoleType"].toString());

                  List<BottomNavigationBarItem> menus = [];
                  List<Widget> pages = [];
                  if (mapData["RoleType"].toString() == "2") {
                    menus = const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: "Home"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.person), label: "Profile")
                    ];
                    pages = const [Menu(), Profile()];
                  } else {
                    menus = const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: "Home"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.person), label: "Profile"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.search), label: "Notifications")
                    ];
                    pages = const [Menu(), Profile(), Notifications()];
                  }

                  setState(() {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Home(
                                  menus: menus,
                                  pages: pages,
                                )));
                  });
                }
              }
            } else {
              _showToast("Host Unreachable, try again later");
            }
          } else {}
        }, onError: (e) {});
      } else {
        _showToast("No internet connection available");
      }
    });
  }
}
