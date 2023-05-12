import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'requests/friends_requests.dart';

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
              //erreur !
              Fluttertoast.showToast(msg: 'Error !');
              return const Text("erreur");
            } else {
              //le menu des amis
              Fluttertoast.showToast(msg: 'Friends loaded');
              return ListView.builder(
                itemCount: snapshot.data['friends'].length,
                itemBuilder: (context, index) {
                  return FriendElement(friend: snapshot.data['friends'][index]);
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
    //print(res);
    SharedPreferences.getInstance().then((prefs) {
      //print(prefs.getString('cookie'));
    });
    return "error";
  }
}

class FriendElement extends StatefulWidget {
  const FriendElement({super.key, this.friend});

  final friend;

  @override
  State<FriendElement> createState() => _FriendElementState();
}

class _FriendElementState extends State<FriendElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text('A'),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            '${widget.friend['name']}',
            style: GoogleFonts.getFont(
              'Varela Round',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
