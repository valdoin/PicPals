
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
        SizedBox(
          height: 60,
          child: NavigationBar(
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
          child: _pages.elementAt(_selectedIndex),
        )
      ],
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
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'View Profile') {
                // fonction pour voir le profil de l'ami
              } else if (result == 'Remove Friend') {
                FriendRequests.deleteFriend(widget.friend["phone"].toString());
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
