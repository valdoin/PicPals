import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:picpals/main_appbar.dart';
import 'package:picpals/requests/comment_requests.dart';

class PostDetailsPage extends StatefulWidget {
  const PostDetailsPage({super.key, this.post});

  final post;

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PostDetailElement(
                    post: widget.post,
                  ),
                  const SizedBox(height: 10),
                  if (widget.post['comments'].isEmpty)
                    Center(
                      child: Text(
                        "Soyez le premier à commenter !",
                        style: GoogleFonts.getFont(
                          'Varela Round',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (widget.post['comments'].isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.post['comments'].length,
                      itemBuilder: (context, index) {
                        var comment = widget.post['comments'][index];
                        return CommentElement(comment: comment);
                      },
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          CommentForm(
            post: widget.post,
          ),
        ],
      ),
    );
  }
}




class CommentForm extends StatefulWidget {
  const CommentForm({super.key, this.post});

  final post;
  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final commentFieldController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  decoration: const InputDecoration(
                    hintText: 'Ajouter un commentaire...',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (commentFieldController.text.isNotEmpty) {
                    await CommentRequest.create(
                        commentFieldController.text, widget.post['_id']);
                    commentFieldController.clear();
                  }
                },
                icon: const Icon(Icons.send),
                color: Colors.blue,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 65,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                child: Text(
                  widget.comment['author']['name'][0],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.comment['author']['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.comment['body'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}




          /*
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    widget.comment['author']['name'],
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    child: Text(widget.comment['author']['name'][0]),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      Align(
                        child: Text(
                          widget.comment['body'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),*/
    

class PostDetailElement extends StatefulWidget {
  const PostDetailElement({super.key, this.post});

  final post;

  @override
  State<PostDetailElement> createState() => _PostDetailElementState();
}

class _PostDetailElementState extends State<PostDetailElement> {
  @override
  Widget build(context) {
    print(widget.post);
    var postSize = MediaQuery.of(context).size.width * 0.95;
    return Container(
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.025,
          postSize * 0.1, MediaQuery.of(context).size.width * 0.025, 6),
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
                      widget.post["date"]
                          .toString()
                          .substring(0, 10)
                          .replaceAll("-", "/"),
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
                  color: HexColor(widget.post["secondaryColor"].toString())),
              child: Image.network(
                widget.post["url"].toString(),
                fit: BoxFit.fill,
              )),
          SizedBox(
            height: postSize * 0.1,
          ),
        ],
      ),
    );
  }
}
