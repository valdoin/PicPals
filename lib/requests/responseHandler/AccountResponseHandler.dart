import 'package:http/http.dart' as http;
import 'package:picpals/canva.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../user_info/manage_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountResponseHandler {
  static void register(
      BuildContext context, http.Response res, phone, String clearPassword) {
    if (res.statusCode == 400) {
      Fluttertoast.showToast(msg: 'this phone number is already used');
    } else if (res.statusCode == 201) {
      SharedPreferences.getInstance().then((prefs) {
        UserInfo.updateInfo(res, prefs, phone, clearPassword);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DrawingBoard(),
        ),
      );
    }
  }

  static void login(BuildContext context, http.Response res, phone,
      String clearPassword) async {
    if (res.statusCode == 400) {
      Fluttertoast.showToast(msg: 'wrong credentials');
    } else if (res.statusCode == 201) {
      SharedPreferences.getInstance().then((prefs) {
        UserInfo.updateInfo(res, prefs, phone, clearPassword);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DrawingBoard(),
        ),
      );
    }
  }
}
