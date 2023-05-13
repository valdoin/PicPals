import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'server_ip.dart';

class DailyRequests {
  static const String url = "http://$serverIp:5000/api/auth/";

  static Future<http.Response> getFriendList() async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookie') ?? '';

    http.Response res = await http.get(Uri.parse('${url}getFriendList'),
        headers: {'Content-type': 'application/json', 'cookie': cookie});

    return res;
  }
}


/*
coté server :
var nexthour = la prochaine heure à laquelle la phrase sera genérée

condition prochaine heure : elle doit etre apres le prochain minuit et avant le prochain prochain minuit

if date.now == nexthour :
  generatenexthour()
  generatephrase()
  generateNewPostNotification()


coté client :
on envoie une requete toutes les x minutes au serveur pour savoir si il y a des nouvelle notif (demande d'ami, newPost etc ) c'est avec cette requete que l'on sait si on peut a nouveau poster
*/