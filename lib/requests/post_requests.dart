import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'server_ip.dart';

class PostRequests {
  static const String url = "http://$serverIp:5000/api/auth/";

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

  static Future<http.Response> deletePost(postId) async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    http.Response res = await http.delete(Uri.parse('${url}deletePost'),
        headers: {'content-type': 'application/json', 'cookie': cookie},
        body: jsonEncode({"postId": postId}));

    return res;
  }

  static Future<http.Response> getFriendsPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    http.Response res = await http.get(Uri.parse('${url}getFriendsPosts'),
        headers: {'content-type': 'application/json', 'cookie': cookie});

    return res;
  }

  //recupere tous les posts de l'utilisateur ayant pour numero 'phone'
  static Future<http.Response> getUserPosts(phone) async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    http.Response res = await http.post(
      Uri.parse('${url}getUserPosts'),
      headers: {'content-type': 'application/json', 'cookie': cookie},
      body: jsonEncode({"phone": phone}),
    );

    return res;
  }

  //recupere un post specifique
  static Future<http.Response> getPost(id) async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    http.Response res = await http.post(
      Uri.parse('${url}getPost'),
      headers: {'content-type': 'application/json', 'cookie': cookie},
      body: jsonEncode({"postId": id}),
    );

    return res;
  }
}
