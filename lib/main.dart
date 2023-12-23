import 'package:acceltime/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '',
        theme: ThemeData(
            fontFamily: 'Roboto',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primarySwatch: Colors.red),
        home: Splash());
  }
}
