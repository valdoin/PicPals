import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

class UserInfo {
  static var cookie;
  static var id;
  static var phone;
  static var name;
  static var password;
  static var primaryColor;
  static var secondaryColor;

  static void updateInfo(
      Response res, SharedPreferences prefs, phone, clearPassword) async {
    final jsonBody = jsonDecode(res.body);
    print(jsonBody);
    await prefs.setString('cookie', res.headers['set-cookie'] ?? '');
    await prefs.setString('id', jsonBody['id'] ?? '');
    await prefs.setString('phone', phone ?? '');
    await prefs.setString('name', jsonBody['name'] ?? '');
    await prefs.setString('password', clearPassword ?? '');
    await prefs.setString(
        'primaryColor', jsonBody['primaryColor'] ?? '#0d1b2a');
    await prefs.setString(
        'secondaryColor', jsonBody['secondaryColor'] ?? '#1b263b');

    updateDirectInfo(prefs);
  }

  static void updateDirectInfo(prefs) async {
    cookie = prefs.getString('cookie');
    id = prefs.getString('id');
    phone = prefs.getString('phone');
    name = prefs.getString('name');
    password = prefs.getString('password');
    primaryColor = prefs.getString('primaryColor');
    secondaryColor = prefs.getString('secondaryColor');
  }

  static void resetInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cookie');
    await prefs.remove('id');
    await prefs.remove('phone');
    await prefs.remove('name');
    await prefs.remove('password');

    await prefs.remove('primaryColor');
    await prefs.remove('secondaryColor');
    updateDirectInfo(prefs);
  }
}
