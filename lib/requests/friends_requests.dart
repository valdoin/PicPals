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
}
