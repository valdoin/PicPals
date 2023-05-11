import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picpals/requests/friends_requests.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => FriendPageState();
}

class FriendPageState extends State<FriendPage> {
  final Future<dynamic> _choosenPage = choosePage();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<dynamic>(
        future: _choosenPage,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if (snapshot.data == 'error') {
              //menu principal
              Fluttertoast.showToast(msg: 'Error !');
              return const Text("erreur");
            } else {
              //menu auth
              Fluttertoast.showToast(msg: 'Could not connect');
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Text(snapshot.data['friends'][index].toString());
                },
              );
            }
          } else if (snapshot.hasError) {
            Fluttertoast.showToast(msg: 'Error');
            return const Text("erreur");
          } else {
            children = <Widget>[
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Loading...',
                  style: GoogleFonts.getFont(
                    'Varela Round',
                    color: Colors.white,
                  ),
                ),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}

Future<dynamic> choosePage() async {
  final res = await FriendRequests.getFriendList();
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else {
    return "error";
  }
}
