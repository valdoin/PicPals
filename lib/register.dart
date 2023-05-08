import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'requests/AccountRequest.dart';
import 'requests/responseHandler/AccountResponseHandler.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  TextEditingController pseudocontroller = TextEditingController();

  //générateur de pseudo aléatoire
  String generateRandomPseudo() {
    List adjectives = [
      'Content',
      'Triste',
      'Marbré',
      'Vigilant',
      'Désinvolte',
      'Décontracté'
    ];
    List nouns = ['Chien', 'Chat', 'Crottard', 'Ramoneur', 'Bouseux', 'Bassem'];

    String adjective = adjectives[Random().nextInt(adjectives.length)];
    String noun = nouns[Random().nextInt(nouns.length)];
    int randomNum = Random().nextInt(100);

    return '$noun$adjective$randomNum';
  }

  void fillTextFieldWithRandomPseudo(TextEditingController controller) {
    String pseudo = generateRandomPseudo();
    controller.text = pseudo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Center(
          child: Column(children: [
            //logo
            Image.asset(
              'img/IC.png',
              height: 250,
              width: 250,
            ),
            //texte
            Text(
              'Créez votre compte',
              style: GoogleFonts.getFont(
                'Varela Round',
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            //texte
            Text(
              "C'est rapide et gratuit !",
              style: GoogleFonts.getFont(
                'Varela Round',
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 30),

            //textfield numéro de téléphone
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: IntlPhoneField(
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

            //textfield pseudo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: pseudocontroller,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                ],
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'Pseudo',
                  hintText: 'Pseudo',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            //générateur de pseudo
            GestureDetector(
              onTap: () {
                fillTextFieldWithRandomPseudo(pseudocontroller);
              },
              child: Text(
                "Pas d'idée ? On en génère un pour vous !",
                style: GoogleFonts.getFont(
                  'Varela Round',
                  color: Colors.lightBlue,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 20),

            //bouton connexion
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              onPressed: () async {
                /*
                AccountResponseHandler.register(
                    context,
                    await AccountRequest.register(
                        '+33612345678', 'regisent', '123456'),
                    '123456');*/
              },
              child: Text(
                "Je m'inscris",
                style: GoogleFonts.getFont(
                  'Varela Round',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
