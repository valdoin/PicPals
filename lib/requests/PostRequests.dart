import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostRequests {
  static const String url = "http://10.42.174.246/api/auth/";

  static Future<http.Response> create(image) async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    http.Response res = await http.post(Uri.parse('${url}createPost'),
        headers: {'Content-type': 'application/json', 'set-cookie': cookie},
        body: jsonEncode({"image": image}));
    return res;
  }
}
