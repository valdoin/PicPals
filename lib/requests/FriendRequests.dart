import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FriendRequests {
  static const String url = "http://10.42.174.246:5000/api/auth/";

  static Future<http.Response> login(String phone, String password) async {
    http.Response res = await http.post(Uri.parse('${url}login'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({"phone": phone, "password": password}));
    return res;
  }

  static Future<http.Response> register(
      String phone, String name, String password) async {
    http.Response res = await http.post(Uri.parse('${url}register'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({'phone': phone, 'name': name, 'password': password}));
    return res;
  }

  static Future<http.Response> delete(String id) async {
    http.Response res = await http.post(Uri.parse('$url/api/auth/deleteUser'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({'id': id}));

    return res;
  }

  static Future <http.Response> getFriendList() async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie')!;
    http.Response res = await http.get(Uri.parse('${url}getFriendList'),
      headers: {'Content-type': 'application/json', 'cookie': cookie },
      );
    print(cookie);
    return res;
  }
}
