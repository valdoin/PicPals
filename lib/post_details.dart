import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:picpals/main_appbar.dart';
import 'package:picpals/requests/comment_requests.dart';
import 'package:picpals/requests/post_requests.dart';
import 'package:intl/intl.dart';

class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({Key? key, this.post}) : super(key: key);

  final post;

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final commentFieldController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    commentFieldController.dispose();
    commentFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _postRes = PostRequests.getPost(widget.post);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: const MainAppBar(),
      body: FutureBuilder(
        future: _postRes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var _jsonRes = jsonDecode(snapshot.data!.body)["post"];

            if (snapshot.data!.statusCode != 200) {
              return const Text('error');
            }

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          PostDetailElement(
                            post: _jsonRes,
                          ),
                          const SizedBox(height: 10),
                          if (_jsonRes['comments'].length > 0)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _jsonRes['comments'].length,
                              itemBuilder: (context, index) {
                                var comment = _jsonRes['comments'][index];
                                return CommentElement(comment: comment);
                              },
                            ),
                          if (_jsonRes['comments'].length == 0)
                            Container(
                              margin: const EdgeInsets.only(top: 35),
                              child: const Text(
                                'Soyez le premier à commenter !',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentFieldController,
                            focusNode: commentFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'Ajouter un commentaire...',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (commentFieldController.text.isNotEmpty) {
                              await CommentRequest.create(
                                  commentFieldController.text, widget.post);
                              commentFieldController.clear();
                              commentFocusNode.unfocus();
                              setState(() {
                                _postRes = PostRequests.getPost(widget.post);
                              });
                            }
                          },
                          icon: const Icon(Icons.send),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class CommentElement extends StatefulWidget {
  const CommentElement({super.key, this.comment});

  final comment;

  @override
  State<CommentElement> createState() => CommentElementState();
}

class CommentElementState extends State<CommentElement> {
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
    return Column(
      children: [
        SizedBox(
          height: 65,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: CircleAvatar(
                  radius: 20,
                  child: Text(
                    widget.comment['author']['name'][0],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.comment['author']['name'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            formatDate(widget.comment['date']),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.comment['body'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class PostDetailElement extends StatefulWidget {
  const PostDetailElement({super.key, this.post});

  final post;

  @override
  State<PostDetailElement> createState() => _PostDetailElementState();
}

class _PostDetailElementState extends State<PostDetailElement> {
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
  Widget build(context) {
    final _postRes = PostRequests.getPost(widget.post);

    var postSize = MediaQuery.of(context).size.width * 0.95;
    return FutureBuilder(
      future: _postRes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.statusCode != 200) {
            return const Text('error');
          }
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Text(widget.post["phrase"]["phrase"].toString(),
                style: const TextStyle(fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.white,),)
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.025,
                    16,
                    MediaQuery.of(context).size.width * 0.025,
                    6),
                width: postSize,
                height: postSize * 1.22,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  color: HexColor(widget.post["primaryColor"].toString()),
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
                        //image ici
                        height: postSize * 0.97,
                        width: postSize * 0.97,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color:
                                HexColor(widget.post["secondaryColor"].toString())),
                        child: Image.network(
                          widget.post["url"].toString(),
                          fit: BoxFit.fill,
                        )),
                    SizedBox(
                      height: postSize * 0.1,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Text('error');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
