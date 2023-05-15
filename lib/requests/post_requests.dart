import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'server_ip.dart';

class PostRequests {
  static const String url = "http://${serverIp}:5000/api/auth/";

  static Future<http.StreamedResponse> create(image) async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    var multipartReq =
        http.MultipartRequest('POST', Uri.parse('${url}createPost'));
    multipartReq.headers.addAll({'cookie': cookie});
    multipartReq.files.add(http.MultipartFile.fromBytes('image', image,
        filename: 'picpalsimg.png', contentType: MediaType('image', 'png')));

    var res = await multipartReq.send();
    return res;
  }

  static Future<http.Response> getFriendsPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    http.Response res = await http.get(Uri.parse('${url}getFriendsPosts'),
        headers: {'content-type': 'application/json', 'cookie': cookie});

    return res;
  }
}
