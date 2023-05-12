import 'package:flutter/material.dart';
import 'package:picpals/main.dart';
import 'package:picpals/user_info/manage_preferences.dart';

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
                radius: 50,
                child: Text(
                  UserInfo.name ?? "D",
                  style: const TextStyle(
                    fontSize: 35,
                  )),
              ),
            ),
            Text(
              UserInfo.name ?? "default",
              style: const TextStyle(color: Colors.white),),
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
            )
          ],
        ),
      ),
    );
  }
}
