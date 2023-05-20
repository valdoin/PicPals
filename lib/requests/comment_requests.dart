import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'server_ip.dart';

class CommentRequest {
  static const String url = "http://${serverIp}:5000/api/auth/";

  static Future<http.Response> create(comment, postId) async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    http.Response res = await http.post(Uri.parse('${url}createComment'),
        headers: {'content-type': 'application/json', 'cookie': cookie},
        body: jsonEncode({"body": comment, "postId": postId}));
    return res;
  }
}
