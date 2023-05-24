import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picpals/friend_requests_page.dart';
import 'package:picpals/friend_search_page.dart';
import 'package:picpals/friend_page.dart';
import 'requests/friends_requests.dart';

class FriendNavigation extends StatefulWidget {
  const FriendNavigation({super.key});

  @override
  State<FriendNavigation> createState() => FriendNavigationState();
}

class FriendNavigationState extends State<FriendNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const FriendPage(),
    const SearchForm(),
    const FriendRequestsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRect(
          clipper: NavBarClipper(),
          child: NavigationBar(
            indicatorColor: Colors.white,
            backgroundColor: Colors.black,
            destinations: const [
              NavigationDestination(
                label: "Amis",
                icon: Icon(Icons.emoji_people),
              ),
              NavigationDestination(
                label: "Ajouter",
                icon: Icon(Icons.add),
              ),
              NavigationDestination(
                label: "Demandes",
                icon: Icon(Icons.pending),
              ),
            ],
            onDestinationSelected: (index) {
              _onItemTapped(index);
            },
            selectedIndex: _selectedIndex,
          ),
        ),
        Container(
          transform: Matrix4.translationValues(0.0, -45.0, 0.0),
          child: _pages.elementAt(_selectedIndex),
        ),
      ],
    );
  }
}

class NavBarClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(0, 0, 1000, 160);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
