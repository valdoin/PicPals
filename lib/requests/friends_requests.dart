import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'server_ip.dart';

class FriendRequests {
  static const String url = "http://$serverIp:5000/api/auth/";

  static Future<http.Response> getFriendList() async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    http.Response res = await http.get(Uri.parse('${url}getFriendList'),
        headers: {'Content-type': 'application/json', 'cookie': cookie});

    return res;
  }

  static Future<http.Response> deleteFriend(phone) async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    http.Response res = await http.delete(Uri.parse('${url}deleteFriend'),
        headers: {'Content-type': 'application/json', 'cookie': cookie},
        body: jsonEncode({"phone": phone}));

    return res;
  }

  static Future<http.Response> requestFriend(phone) async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    http.Response res = await http.post(
      Uri.parse('${url}requestFriend'),
      headers: {'content-type': 'application/json', 'cookie': cookie},
      body: jsonEncode({"phone": phone}),
    );

    return res;
  }
}
