import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:picpals/friend_page.dart';
import 'package:picpals/main.dart';
import 'package:picpals/requests/friends_requests.dart';
import 'package:picpals/requests/post_requests.dart';
import 'package:http/http.dart' as http;
import 'package:picpals/main_appbar.dart';
import 'package:picpals/post_details.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final String phone;
  final String name;
  final String secondaryColor;
  const ProfilePage(
      {super.key,
      required this.phone,
      required this.name,
      required this.secondaryColor});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: MainPage(
              phone: widget.phone,
              name: widget.name,
              secondaryColor: widget.secondaryColor,
            )),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  late String phone;
  late String name;
  late String secondaryColor;
  MainPage(
      {super.key,
      required this.phone,
      required this.name,
      required this.secondaryColor,
      this.posts});

  final posts;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    var postSize = MediaQuery.of(context).size.width * 0.95;
    Future<http.Response> userPostsRes =
        PostRequests.getUserPosts(widget.phone);

    Future<void> _refresh() async {
      setState(() {
        userPostsRes = PostRequests.getFriendsPosts();
      });
      return Future<void>.delayed(const Duration(seconds: 2));
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: HexColor(widget.secondaryColor) ?? Colors.black,
      child: FutureBuilder<http.Response>(
        future: userPostsRes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.statusCode != 200) {
              return const Text("error");
            }

            var res = jsonDecode(snapshot.data!.body)["posts"];

            return ListView.builder(
              itemCount: res.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Affichage de l'en-tête avec avatar et pseudo
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Options"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Confirmation"),
                                                  content: const Text(
                                                      "Êtes-vous sûr de vouloir supprimer cet ami ?"),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              "Annuler"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            FriendRequests
                                                                .deleteFriend(
                                                                    widget
                                                                        .phone);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const FriendPage()));
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "Friend deleted",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      700],
                                                              textColor:
                                                                  Colors.white,
                                                            );
                                                          },
                                                          style: ButtonStyle(
                                                            foregroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .red), // Couleur du texte en rouge
                                                          ),
                                                          child: const Text(
                                                              "Supprimer"),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: const Text("Supprimer l'ami"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: HexColor(widget.secondaryColor),
                          radius: 35,
                          child: Text(
                            widget.name[0],
                            style: const TextStyle(
                              fontSize: 35,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }

                // Affichage des posts
                var post = res[index - 1];
                return PostElement(post: post);
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
      ),
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
  void shareImage() async {
    try {
      final ByteData bytes =
          await NetworkAssetBundle(Uri.parse(widget.post["url"].toString()))
              .load('');
      await Share.file(
        'Partager l\'image',
        'image.jpg',
        bytes.buffer.asUint8List(),
        'image/jpeg',
      );
    } catch (e) {
      print(e.toString());
    }
  }

  String formatDate(String dateString) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ');
    final DateTime date = formatter.parse(dateString);

    final Duration difference = now.difference(date);

    if (difference.inHours < 1) {
      if (difference.inMinutes < 1) {
        return 'Il y a ${difference.inSeconds} s';
      } else {
        return 'Il y a ${difference.inMinutes} min';
      }
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} h';
    } else {
      return 'Il y a ${difference.inDays} j';
    }
  }

  @override
  Widget build(BuildContext context) {
    var postSize = MediaQuery.of(context).size.width * 0.95;
    return Container(
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.025,
        postSize * 0.03,
        MediaQuery.of(context).size.width * 0.025,
        6,
      ),
      width: postSize,
      height: postSize * 1.22,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: HexColor(widget.post["primaryColor"].toString()) ?? Colors.black,
      ),
      child: Column(
        children: [
          SizedBox(
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
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                    child: Text(
                      formatDate(widget.post["date"]),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: postSize * 0.97,
            width: postSize * 0.97,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: HexColor(widget.post["secondaryColor"].toString()) ??
                  Colors.black,
            ),
            child: Image.network(
              widget.post["url"].toString(),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: postSize * 0.1,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailsPage(
                            post: widget.post,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Voir les détails",
                      style: GoogleFonts.getFont(
                        'Varela Round',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: shareImage,
                    child: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
