import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'requests/AccountRequest.dart';
import 'requests/responseHandler/AccountResponseHandler.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
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
              height: 225,
              width: 225,
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

            const SizedBox(height: 20),

            //register form

            const RegisterForm()
          ]),
        ),
      ),
    );
  }
}

// le formulaire de login
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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

  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  var phoneCode = '33';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    phoneController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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

        //textfield pseudo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            controller: nameController,
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
            fillTextFieldWithRandomPseudo(nameController);
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

        const SizedBox(height: 15),

        //textfield mdp
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            controller: passwordController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              labelText: 'Mot de passe',
              hintText: 'Mot de passe',
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),

        //bouton connexion
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
          ),
          onPressed: () async {
            if (phoneController.text.length >= 4) {
              if (passwordController.text.length >= 6) {
                if (nameController.text.isNotEmpty) {
                  AccountResponseHandler.register(
                      context,
                      await AccountRequest.register(
                          '+$phoneCode${phoneController.text}',
                          nameController.text,
                          passwordController.text),
                      '+$phoneCode${phoneController.text}',
                      passwordController.text);
                } else {
                  Fluttertoast.showToast(msg: 'veuillez entrer un nom');
                }
              } else {
                Fluttertoast.showToast(msg: 'mot de passe trop court');
              }
            } else {
              Fluttertoast.showToast(msg: 'numéro invalide');
            }
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
      ],
    );
  }
}
