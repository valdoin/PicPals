import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:picpals/requests/friends_requests.dart';
import 'package:picpals/user_info/manage_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_appbar.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  var searchRes;
  var clicked = false;

  final phoneController = TextEditingController();

  var phoneCode = '33';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: IntlPhoneField(
            controller: phoneController,
            invalidNumberMessage: "Numéro invalide",
            autofocus: false,
            cursorColor: Theme.of(context).primaryColor,
            dropdownTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            searchText: "Chercher un pays",
            style: const TextStyle(
              color: Colors.white,
            ),
            initialCountryCode: 'FR',
            onCountryChanged: (country) {
              phoneCode = country.dialCode;
            },
            decoration: const InputDecoration(
              counterText: '',
              labelText: 'Numéro de téléphone',
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        //bouton connexion
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor(UserInfo.primaryColor),
            elevation: 0,
          ),
          onPressed: () {
            setState(() {
              searchRes = FriendRequests.requestFriend(
                  '+$phoneCode${phoneController.text}');
              clicked = true;
            });
          },
          child: Text(
            'Ajouter',
            style: GoogleFonts.getFont(
              'Varela Round',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        FutureBuilder<http.Response>(
          future: searchRes,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              if (clicked) {
                return const CircularProgressIndicator();
              }
              return const Text('');
            } else if (snapshot.hasError) {
              return const Text("error");
            } else {
              print(jsonDecode(snapshot.data!.body));

              if (jsonDecode(snapshot.data!.body)["message"] ==
                  "user already requested") {
                return const Text("utilisateur déjà demandé !");
              }
              if (jsonDecode(snapshot.data!.body)["message"] ==
                  "friend request sent") {
                return const Text("demande envoyé !");
              }
              if (jsonDecode(snapshot.data!.body)["message"] ==
                  "friend added") {
                return const Text("Ami ajouté !");
              }

              return const Text("L'utilisateur n'existe pas :(");
            }
            return const Text("Demande envoyé !");
          },
        )
      ],
    );
  }
}
