import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:picpals/friend_search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'requests/friends_requests.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => FriendRequestsPageState();
}

class FriendRequestsPageState extends State<FriendRequestsPage> {
  final Future<http.Response> _res = FriendRequests.getFriendsRequested();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<http.Response>(
        future: _res,
        builder: (context, snapshot) {
          Widget receivedContent;
          Widget sentContent;
          if (snapshot.hasData) {
            final jsonBody = jsonDecode(snapshot.data!.body);
            print(jsonBody);
            if (jsonBody['received'].length == 0) {
              receivedContent = Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  "Personne ne vous a envoyé de demande :'(",
                  style: GoogleFonts.getFont(
                    'Varela Round',
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            } else {
              receivedContent = SizedBox(
                height: jsonBody['received'].length * 50.0,
                child: FriendRequestsReceivedView(
                  friends: jsonBody['received'],
                ),
              );
            }

            if (jsonBody['sent'].length == 0) {
              sentContent = Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  "Vous n'avez envoyé aucune demande !",
                  style: GoogleFonts.getFont(
                    'Varela Round',
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            } else {
              sentContent = SizedBox(
                height: jsonBody['sent'].length * 50.0,
                child: FriendRequestsSentView(
                  friends: jsonBody['sent'],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      "Demandes reçues : ",
                      style: GoogleFonts.getFont(
                        'Varela Round',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  receivedContent,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      "Demandes envoyées : ",
                      style: GoogleFonts.getFont(
                        'Varela Round',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  sentContent,
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('error');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class FriendRequestsReceivedView extends StatefulWidget {
  const FriendRequestsReceivedView({super.key, this.friends});

  final friends;
  @override
  State<FriendRequestsReceivedView> createState() =>
      _FriendRequestsReceivedViewState();
}

class _FriendRequestsReceivedViewState
    extends State<FriendRequestsReceivedView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.friends.length,
      itemBuilder: (context, index) {
        return ReceivedFriendElement(friend: widget.friends[index]);
      },
    );
  }
}

class FriendRequestsSentView extends StatefulWidget {
  const FriendRequestsSentView({super.key, this.friends});

  final friends;
  @override
  State<FriendRequestsSentView> createState() => _FriendRequestsSentViewState();
}

class _FriendRequestsSentViewState extends State<FriendRequestsSentView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.friends.length,
      itemBuilder: (context, index) {
        return FriendElement(friend: widget.friends[index]);
      },
    );
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
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text('${widget.friend["name"][0]}'.toUpperCase()),
          ),
          Expanded(
            child: Text(
              '${widget.friend['name']}',
              style: GoogleFonts.getFont(
                'Varela Round',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReceivedFriendElement extends StatefulWidget {
  const ReceivedFriendElement({super.key, this.friend});

  final friend;

  @override
  State<ReceivedFriendElement> createState() => _ReceivedFriendElementState();
}

class _ReceivedFriendElementState extends State<ReceivedFriendElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text('${widget.friend["name"][0]}'.toUpperCase()),
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
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                FriendRequests.requestFriend(widget.friend['phone']);
                setState(() {});
              },
              child: const Icon(Icons.add))
        ],
      ),
    );
  }
}
