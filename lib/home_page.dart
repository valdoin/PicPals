import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

import 'profile.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Color randomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: GoogleFonts.getFont('Varela Round').fontFamily,
        //primaryColor: Colors.black, //randomColor(),
        useMaterial3: true,
        primaryColor: randomColor(),
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
            displaySmall: TextStyle(color: Colors.white),
            displayMedium: TextStyle(color: Colors.white),
            displayLarge: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Text("kikous"),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
          child: Text(
            "PicPals",
            style: GoogleFonts.getFont(
              'Varela Round',
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            label: 'profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          )
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
      /*
      body: Container(
        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.025,
            50, MediaQuery.of(context).size.width * 0.025, 0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.95,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Container(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 10,
                    ),
                    image: const DecorationImage(
                      image: AssetImage('img/squre_img.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),*/

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
            //USER
            height: postSize * 0.15,
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "John Smith",
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
              ),
              child: Image.asset(
                'img/squre_test_img.png',
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

/*
idee : couleur atitré chaque jour/ personne et un post = la bordure de couleur + le fond du post noir + la feuille du canvas de couleur */