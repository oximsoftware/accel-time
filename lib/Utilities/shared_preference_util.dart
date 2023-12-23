import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  Preference._();

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// ----------------------------------------------------------
  /// Generic routine to fetch an application preference
  /// ----------------------------------------------------------
  static Future<String> getStringItem(String name) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(name) ?? '';
  }

  /// ----------------------------------------------------------
  /// Generic routine to saves an application preference
  /// ----------------------------------------------------------
  static Future<bool> setStringItem(String name, String value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(name, value);
  }

  static Future<Set<String>> getAll() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getKeys();
  }

  static clearAll() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
  }
}
