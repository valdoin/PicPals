import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:picpals/requests/account_requests.dart';
import 'package:picpals/requests/responseHandler/account_responses_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'home_page.dart' as home;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Color randomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PicPals',
      theme: ThemeData(
        fontFamily: GoogleFonts.getFont('Varela Round').fontFamily,
        primaryColor: randomColor(),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const LoginScreen(),
      //home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              //logo
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  'img/IC.png',
                  height: 225,
                  width: 225,
                ),
              ),
              //texte
              Text(
                'Bienvenue.',
                style: GoogleFonts.getFont(
                  'Varela Round',
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),

              const SizedBox(height: 20),

              //textfield numéro de téléphone
              const LoginForm(),

              const SizedBox(height: 10),

              //création compte si nouvel utilisateur
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()));
                },
                child: Text(
                  'Vous êtes nouveau ? Créez un compte !',
                  style: GoogleFonts.getFont(
                    'Varela Round',
                    color: Colors.lightBlue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// le formulaire de login
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  var phoneCode = '33';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    phoneController.dispose();
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
        const SizedBox(height: 15),

        //bouton connexion
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
          ),
          onPressed: () async {
            AccountResponseHandler.login(
                context,
                await AccountRequest.login('+$phoneCode${phoneController.text}',
                    passwordController.text),
                '+$phoneCode${phoneController.text}',
                passwordController.text);
          },
          child: Text(
            'Connexion',
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

//choisi la page afficher selon que l'on est log ou non grace a la fonction choosePage
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<String> _choosenPage = choosePage();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: _choosenPage,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            if (snapshot.data == 'Connected') {
              //menu principal
              Fluttertoast.showToast(msg: 'Connected !');
              //return const DrawingBoard();
              return const home.HomePage();
            } else {
              //menu auth
              Fluttertoast.showToast(msg: 'Could not connect');
              return const HomePage(title: 'Flutter Demo Home Page');
            }
          } else if (snapshot.hasError) {
            Fluttertoast.showToast(msg: 'Error');
            return const HomePage(title: 'Flutter Demo Home Page');
          } else {
            children = <Widget>[
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Loading...',
                  style: GoogleFonts.getFont(
                    'Varela Round',
                    color: Colors.white,
                  ),
                ),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}

//sert a renvoyer sur la page selon qu'on soit log ou non
Future<String> choosePage() async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.getString('password') != null) {
    final loginResponse = await AccountRequest.login(
        prefs.getString('phone')!, prefs.getString('password')!);
    if (loginResponse.statusCode == 201) {
      return 'Connected';
    } else if (loginResponse.statusCode == 400) {
      return 'Wrong credentials';
    } else {
      return 'authentication failed';
    }
    //envoyer direct authentication
    //si erreur d'auth : on renvoie sur la page de connection
  } else {
    return 'Not connected';
    //on renvoie sur al page de connection
  }
}
