import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picpals/main.dart';
import 'package:picpals/requests/post_requests.dart';
import 'package:picpals/user_info/manage_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: CircleAvatar(
                radius: 40,
                child: Text(UserInfo.name[0] ?? "D",
                    style: const TextStyle(
                      fontSize: 35,
                    )),
              ),
            ),
            Text(
              UserInfo.name ?? "default",
              style: const TextStyle(color: Colors.white),
            ),
            const Expanded(child: MainPage()),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      UserInfo.resetInfo();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage(
                                    title: 'Picpals',
                                  )));
                    },
                    child: const Text('Déconnexion'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Supprimer le compte"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.posts});

  final posts;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Future<http.Response> _userPostsRes =
      PostRequests.getUserPosts(UserInfo.phone.toString());
  @override
  Widget build(context) {
    return FutureBuilder<http.Response>(
      future: _userPostsRes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.statusCode != 200) {
            return const Text("error");
          }

          var res = jsonDecode(snapshot.data!.body)["posts"];

          return ListView.builder(
            itemCount: res.length,
            itemBuilder: (context, index) {
              print(res.toString());
              return PostElement(post: res[index]);
            },
          );
        } else if (snapshot.hasError) {
          return const Text(
            'error',
            style: TextStyle(color: Colors.white),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class PostElement extends StatefulWidget {
  const PostElement({super.key, this.post});

  final post;

  @override
  State<PostElement> createState() => _PostElementState();
}

class _PostElementState extends State<PostElement> {
  @override
  Widget build(context) {
    var postSize = MediaQuery.of(context).size.width * 0.95;
    return Container(
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.025,
          postSize * 0.1, MediaQuery.of(context).size.width * 0.025, 0),
      width: postSize,
      height: postSize * 1.22,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        children: [
          SizedBox(
            // USER
            height: postSize * 0.15,
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.post["author"]["name"].toString(),
                      style: GoogleFonts.getFont(
                        'Varela Round',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                   Text(
                    widget.post["date"].toString().substring(0, 10).replaceAll("-", "/"), 
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
              //image ici
              height: postSize * 0.97,
              width: postSize * 0.97,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Image.network(
                widget.post["url"].toString(),
                fit: BoxFit.fill,
              )),
          SizedBox(
            height: postSize * 0.1,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Commentaires",
                  style: GoogleFonts.getFont(
                    'Varela Round',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
