import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'server_ip.dart';

class AccountRequest {
  static const String url = 'http://$serverIp:5000/api/auth/';

  static Future<http.Response> login(String phone, String password) async {
    http.Response res = await http
        .post(Uri.parse('${url}login'),
            headers: {'Content-type': 'application/json'},
            body: jsonEncode({"phone": phone, "password": password}))
        .timeout(const Duration(seconds: 20));
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
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    http.Response res = await http.post(Uri.parse('$url/api/auth/deleteUser'),
        headers: {'Content-type': 'application/json', 'cookie': cookie},
        body: jsonEncode({'id': id}));

    return res;
  }
}
