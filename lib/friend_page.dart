import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'requests/friends_requests.dart';
import 'package:picpals/friend_profile.dart';
import 'package:hexcolor/hexcolor.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => FriendPageState();
}

class FriendPageState extends State<FriendPage> {
  Future<dynamic> _choosenPage = choosePage();

  Future<void> refreshPage() async {
    setState(() {
      _choosenPage = choosePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: HexColor('#FCFBF4'),
        child: DefaultTextStyle(
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
                  if (snapshot.data['friends'].length == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Center(
                        child: Text(
                          "Vous n'avez aucun ami :( \nAjoutez-en !",
                          style: GoogleFonts.getFont(
                            'Varela Round',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                  //le menu des amis
                  Fluttertoast.showToast(msg: 'Friends loaded');
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                        child: Text(
                          'Vos amis',
                          style: GoogleFonts.getFont(
                            'Varela Round',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        itemCount: snapshot.data['friends'].length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: FriendElement(
                                friend: snapshot.data['friends'][index],
                                refreshPage: refreshPage),
                          );
                        },
                      ),
                    ],
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
        ),
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

class FriendElement extends StatefulWidget {
  const FriendElement({super.key, this.friend, required this.refreshPage});
  final Function() refreshPage;
  final friend;

  @override
  State<FriendElement> createState() => _FriendElementState();
}

class _FriendElementState extends State<FriendElement> {
  Future<void> removeFriend() async {
    await FriendRequests.deleteFriend(widget.friend["phone"].toString());
    widget.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: HexColor(widget.friend["primaryColor"] ?? '#FFFFFF'),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          CircleAvatar(
            backgroundColor:
                HexColor(widget.friend["secondaryColor"] ?? '#FFFFFF'),
            child: Text(
              '${widget.friend["name"][0]}'.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              '${widget.friend['name']}',
              style: GoogleFonts.getFont(
                'Varela Round',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (String result) {
              if (result == 'View Profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              phone: widget.friend["phone"].toString(),
                              name: widget.friend["name"].toString(),
                            )));
              } else if (result == 'Remove Friend') {
                removeFriend();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'View Profile',
                child: Text('Voir le profil'),
              ),
              const PopupMenuItem<String>(
                value: 'Remove Friend',
                child: Text("Supprimer l'ami"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
