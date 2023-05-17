import 'package:picpals/friend_navigation.dart';
import 'package:picpals/main_appbar.dart';
import 'package:picpals/user_info/manage_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picpals/canva.dart';
import 'package:picpals/friendpage.dart';
import 'package:http/http.dart' as http;
import 'package:picpals/requests/account_requests.dart';
import 'package:picpals/requests/post_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'package:hexcolor/hexcolor.dart';

/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Color randomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {

    print(UserInfo.secondaryColor);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: GoogleFonts.getFont('Varela Round').fontFamily,
        //primaryColor: HexColor(),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
            displaySmall: TextStyle(color: Colors.white),
            displayMedium: TextStyle(color: Colors.white),
            displayLarge: TextStyle(color: Colors.white)),
      ),
    );
  }
}
*/
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _pages = <Widget>[
    const ProfilePage(),
    const MainPage(),
    const DrawingBoard(),
    const FriendNavigation(),
  ];

  var userPrimaryColor = "#0d1b2a";
  var userSecondaryColor = "#1b263b";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      print(prefs.getString('secondaryColor'));
      userPrimaryColor = prefs.getString('primaryColor') ?? '#FFFFFF';
      userSecondaryColor = prefs.getString('secondaryColor') ?? '#FFFFFF';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: HexColor(userSecondaryColor),
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.draw), label: 'Dessiner'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Amis'),
        ],
        onTap: (index) {
          if (index == 2) {
            //ici rajouter condition pour voir si l'user a déjà dessiné et lui afficher erreur dans un toast le cas échéant, sinon le rediriger
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DrawingBoard()),
            );
          } else {
            _onItemTapped(index);
          }
        },
        currentIndex: _selectedIndex,
      ),
      body: _pages.elementAt(_selectedIndex),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Future<http.Response> _hasPosted = AccountRequest.getHasPosted();

  @override
  Widget build(context) {
    return FutureBuilder<http.Response>(
      future: _hasPosted,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.statusCode != 200) {
            return const Text("error while fetching user state");
          }
          if (jsonDecode(snapshot.data!.body)["hasposted"]) {
            return const PostsView();
          } else {
            return const DrawingBoard();
          }
        } else if (snapshot.hasError) {
          return const Text('error');
        } else {
          return const Center(
            child: SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class PostsView extends StatefulWidget {
  const PostsView({super.key});

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  Future<http.Response> _friendsPostsRes = PostRequests.getFriendsPosts();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: _friendsPostsRes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.statusCode != 200) {
            return const Text("error");
          }

          var res = jsonDecode(snapshot.data!.body)["posts"];

          return ListView.builder(
            itemCount: res.length,
            itemBuilder: (context, index) {
              return PostElement(post: res[index]);
            },
          );
        } else if (snapshot.hasError) {
          return const Text('error');
        } else {
          return const Text('loading...');
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
        color: HexColor(widget.post["primaryColor"].toString()),
      ),
      child: Column(
        children: [
          SizedBox(
            //USER
            height: postSize * 0.15,
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
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
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Dites ce que vous en pensez...",
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

//TODO faire une class post qui affihce un post unique avec en parametre un post puis on met ca dans un future builder que l'on met dans une list view 

/*
idee : couleur atitré chaque jour/ personne et un post = la bordure de couleur + le fond du post noir + la feuille du canvas de couleur */