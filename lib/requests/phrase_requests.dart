import 'package:http/http.dart' as http;
import 'server_ip.dart';

class PhraseRequests {
  static const String url = "http://$serverIp:5000/api/auth/";

  static Future<http.Response> getPhrase() async {
    http.Response res = await http.get(Uri.parse('${url}getPhrase'),
        headers: {'content-type': 'application/json'});

    return res;
  }
}
