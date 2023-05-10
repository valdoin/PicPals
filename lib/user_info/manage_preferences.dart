import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  static var cookie;
  static var id;
  static var phone;
  static var name;
  static var password;

  static void updateInfo(
      Response res, SharedPreferences prefs, phone, clearPassword) async {
    final jsonBody = jsonDecode(res.body);

    await prefs.setString('cookie', res.headers['set-cookie'] ?? '');
    await prefs.setString('id', jsonBody['id'] ?? '');
    await prefs.setString('phone', phone ?? '');
    await prefs.setString('name', name ?? '');
    await prefs.setString('password', clearPassword ?? '');
    print(prefs.getString("cookie"));
  }

  static void updateDirectInfo() async {
    final prefs = await SharedPreferences.getInstance();

    cookie = prefs.getString('cookie');
    id = prefs.getString('id');
    phone = prefs.getString('phone');
    name = prefs.getString('name');
    password = prefs.getString('password');
  }

  static void resetInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cookie');
    await prefs.remove('id');
    await prefs.remove('phone');
    await prefs.remove('name');
    await prefs.remove('password');
    updateDirectInfo();
  }
}
