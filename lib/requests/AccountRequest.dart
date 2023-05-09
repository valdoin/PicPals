import 'dart:convert';
import 'package:http/http.dart' as http;

class AccountRequest {
  static const String url = "http://10.42.150.17:5000/api/auth/";

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
}
